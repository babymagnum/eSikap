//
//  RiwayatCutiController.swift
//  Angkasa Pura Solusi
//
//  Created by Arief Zainuri on 10/08/19.
//  Copyright © 2019 Gama Techno. All rights reserved.
//

import UIKit
import SVProgressHUD

class RiwayatCutiController: BaseViewController, UICollectionViewDelegate {

    @IBOutlet weak var labelDataKosong: CustomLabel!
    @IBOutlet weak var viewRootTopMargin: NSLayoutConstraint!
    @IBOutlet weak var riwayatCutiCollectionView: UICollectionView!
    
    private var lastVelocityYSign = 0
    private var allowLoadMore = false
    private var listRiwayatCuti = [ItemRiwayatCuti]()
    private var totalPage = 0
    private var currentPage = 0
    private var status = ""
    private var leave_type_id = ""
    private var current_year = ""
    
    var isFromAddLeaveRequest: Bool?
    
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(handleRefresh(_:)),for: UIControl.Event.valueChanged)
        refreshControl.tintColor = UIColor(hexString: "42a5f5")
        return refreshControl
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initView()
        
        initCollectionView()
        
        getRiwayatCuti()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle { return .lightContent }
    
    private func getRiwayatCuti() {
        SVProgressHUD.show()
        
        informationNetworking.getLeaveHistoryList(page: currentPage, year: current_year, leave_type_id: leave_type_id, status: status) { (error, riwayatCuti, isExpired) in
            DispatchQueue.main.async {
                SVProgressHUD.dismiss()
                
                if let _ = isExpired {
                    self.forceLogout(self.navigationController!)
                    return
                }
                
                if let error = error {
                    self.function.showUnderstandDialog(self, "Gagal Mendapatkan Riwayat Cuti", error, "Reload", "Understand", completionHandler: {
                        self.getRiwayatCuti()
                    })
                    return
                }
                
                guard let riwayatCuti = riwayatCuti else { return }
                
                if self.currentPage == 0 { self.listRiwayatCuti.removeAll() }
                
                if riwayatCuti.data?.leave.count == 0 && self.listRiwayatCuti.count == 0 {
                    self.labelDataKosong.text = riwayatCuti.message
                    self.labelDataKosong.isHidden = false
                } else {
                    self.labelDataKosong.isHidden = true
                }
                
                self.totalPage = (riwayatCuti.data?.total_page)!
                
                riwayatCuti.data?.leave.forEach({ (riwayat) in
                    self.listRiwayatCuti.append(riwayat)
                })
                
                self.currentPage += 1
                
                self.riwayatCutiCollectionView.reloadData()
            }
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        riwayatCutiCollectionView.collectionViewLayout.invalidateLayout()
    }
    
    private func initCollectionView() {
        riwayatCutiCollectionView.register(UINib(nibName: "RiwayatCutiCell", bundle: nil), forCellWithReuseIdentifier: "RiwayatCutiCell")
        
        riwayatCutiCollectionView.addSubview(refreshControl)
        riwayatCutiCollectionView.delegate = self
        riwayatCutiCollectionView.dataSource = self
    }
    
    private func initView() {
        function.changeStatusBar(hexCode: 0x42a5f5, view: self.view, opacity: 1)
        current_year = function.getCurrentDate(pattern: "yyyy")
        checkTopMargin(viewRootTopMargin: viewRootTopMargin)
    }
    
}

extension RiwayatCutiController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.item == listRiwayatCuti.count - 1 {
            if self.allowLoadMore && currentPage + 1 <= totalPage {
                self.getRiwayatCuti()
            }
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let currentVelocityY =  scrollView.panGestureRecognizer.velocity(in: scrollView.superview).y
        let currentVelocityYSign = Int(currentVelocityY).signum()
        
        if currentVelocityYSign != lastVelocityYSign &&
            currentVelocityYSign != 0 {
            lastVelocityYSign = currentVelocityYSign
        }
        
        if lastVelocityYSign < 0 {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.allowLoadMore = true
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return listRiwayatCuti.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RiwayatCutiCell", for: indexPath) as! RiwayatCutiCell
        cell.viewContainer.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(cutiContainerClick(sender:))))
        cell.data = listRiwayatCuti[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let item = listRiwayatCuti[indexPath.item]
        
        let screenWidth = UIScreen.main.bounds.width
        let typeHeight = item.type_name?.getHeight(withConstrainedWidth: screenWidth - 59 - 20, font_size: 8)
        let dateHeight = item.dates?.getHeight(withConstrainedWidth: screenWidth - 59 - 20, font_size: 8)
        let numberHeight = item.number?.getHeight(withConstrainedWidth: screenWidth - 59 - 20, font_size: 8)
        let contentHeight = typeHeight! + dateHeight! + numberHeight!
        let originalHeight = (51 - 28.5) + contentHeight
        return CGSize(width: UIScreen.main.bounds.width - 24, height: originalHeight)
    }
}

extension RiwayatCutiController: RiwayatCutiFilterProtocol {
    func filter(tahun: String, jenisCuti: String, status: String) {
        print("status \(status), tahun \(tahun), jenisCuti \(jenisCuti)")
        self.status = status
        self.current_year = tahun
        self.leave_type_id = jenisCuti
        currentPage = 0
        listRiwayatCuti.removeAll()
        getRiwayatCuti()
    }
    
    @IBAction func buttonFilterClick(_ sender: Any) {
        let vc = RiwayatCutiFilterController()
        vc.delegate = self
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        refreshControl.endRefreshing()
        currentPage = 0
        getRiwayatCuti()
    }
    
    @objc func cutiContainerClick(sender: UITapGestureRecognizer) {
        guard let indexpath = riwayatCutiCollectionView.indexPathForItem(at: sender.location(in: riwayatCutiCollectionView)) else { return }
        
        let item = listRiwayatCuti[indexpath.item]
        
        if item.status == "Save" {
            let vc = PengajuanCutiController()
            vc.leave_id = item.id
            navigationController?.pushViewController(vc, animated: true)
        } else {
            let vc = DetailCutiController()
            vc.leave_id = item.id
            vc.title_content = "Detail Cuti"
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @IBAction func buttonBackClick(_ sender: Any) {
        if let _ = isFromAddLeaveRequest {
            let transition = CATransition()
            transition.duration = 0.4
            transition.type = CATransitionType.push
            transition.subtype = CATransitionSubtype.fromLeft
            self.navigationController?.view.layer.add(transition, forKey: kCATransition)
            self.navigationController?.pushViewController(HomeController(), animated: true)
        } else {
            navigationController?.popViewController(animated: true)
        }
    }
}
