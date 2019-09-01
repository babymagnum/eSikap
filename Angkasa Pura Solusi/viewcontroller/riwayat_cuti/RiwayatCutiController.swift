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

    @IBOutlet weak var riwayatCutiCollectionView: UICollectionView!
    @IBOutlet weak var viewRootTopMargin: NSLayoutConstraint!
    
    var lastVelocityYSign = 0
    var allowLoadMore = false
    var listRiwayatCuti = [ItemRiwayatCuti]()
    var isCalculatRiwayatCutiHeight = false
    var totalPage = 0
    var currentPage = 0
    var status = ""
    var leave_type_id = ""
    var current_year = ""
    
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
        current_year = function.getCurrentDate(pattern: "yyyy")
            
        SVProgressHUD.show()
        
        informationNetworking.getLeaveHistoryList(page: currentPage, year: current_year, leave_type_id: leave_type_id, status: status) { (error, riwayatCuti, isExpired) in
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
            self.totalPage = (riwayatCuti.data?.total_page)!
            
            for riwayat in riwayatCuti.data!.leave {
                self.listRiwayatCuti.append(riwayat)
            }
            
            self.currentPage += 1
            self.riwayatCutiCollectionView.reloadData()
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        DispatchQueue.main.async {
            self.riwayatCutiCollectionView.collectionViewLayout.invalidateLayout()
        }
    }
    
    private func initCollectionView() {
        riwayatCutiCollectionView.register(UINib(nibName: "RiwayatCutiCell", bundle: nil), forCellWithReuseIdentifier: "RiwayatCutiCell")
        
        riwayatCutiCollectionView.addSubview(refreshControl)
        riwayatCutiCollectionView.delegate = self
        riwayatCutiCollectionView.dataSource = self
    }
    
    private func initView() {
        function.changeStatusBar(hexCode: 0x42a5f5, view: self.view, opacity: 1)
        
        checkTopMargin(viewRootTopMargin: viewRootTopMargin)
    }
    
}

extension RiwayatCutiController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.item == listRiwayatCuti.count - 1 {
            if self.allowLoadMore && currentPage + 1 < totalPage {
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
        
        let item = listRiwayatCuti[indexPath.item]
        
        DispatchQueue.main.async {
            if !self.isCalculatRiwayatCutiHeight {
                self.isCalculatRiwayatCutiHeight = true
                let originalHeight = cell.viewContainer.getHeight()
                let riwayatCutiLayout = self.riwayatCutiCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
                riwayatCutiLayout.itemSize = CGSize(width: UIScreen.main.bounds.width - 24, height: originalHeight + 7.9)
            }
        }
        
        cell.data = item
        return cell
    }
}

extension RiwayatCutiController {
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        refreshControl.endRefreshing()
        listRiwayatCuti.removeAll()
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
            vc.cuti = item
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @IBAction func buttonBackClick(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
}
