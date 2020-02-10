//
//  DaftarCutiController.swift
//  Angkasa Pura Solusi
//
//  Created by Arief Zainuri on 01/02/20.
//  Copyright © 2020 Gama Techno. All rights reserved.
//

import UIKit
import SVProgressHUD

class DaftarCutiController: BaseViewController {

    @IBOutlet weak var constraintViewRoot: NSLayoutConstraint!
    @IBOutlet weak var collectionDaftarCuti: UICollectionView!
    @IBOutlet weak var labelEmpty: CustomLabel!
    
    private var listDaftarCuti = [LeaveListItem]()
    private var lastVelocityYSign = 0
    private var allowLoadMore = false
    private var currentPage = 0
    private var totalPage = 0
    private var empName = ""
    private var startDate = ""
    private var endDate = ""
    private var leaveTypeId = ""
    private var status = ""
    
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(handleRefresh(_:)),for: UIControl.Event.valueChanged)
        refreshControl.tintColor = UIColor(hexString: "42a5f5")
        
        return refreshControl
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initView()
        
        getDaftarCuti()
    }

    private func initView() {
        checkTopMargin(viewRootTopMargin: constraintViewRoot)
        function.changeStatusBar(hexCode: 0x42a5f5, view: self.view, opacity: 1)
        
        collectionDaftarCuti.register(UINib(nibName: "DaftarCutiCell", bundle: nil), forCellWithReuseIdentifier: "DaftarCutiCell")
        collectionDaftarCuti.dataSource = self
        collectionDaftarCuti.delegate = self
        collectionDaftarCuti.addSubview(refreshControl)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle { return .lightContent }
    
    private func getDaftarCuti() {
        let body: [String: String] = [
            "page": "\(currentPage)",
            "emp_name": empName,
            "start_date": startDate,
            "end_date": endDate,
            "leave_type_id": leaveTypeId,
            "status": status
        ]
        
        SVProgressHUD.show()
        
        informationNetworking.getLeaveList(body: body) { (error, leaveList, isExpired) in
            SVProgressHUD.dismiss()
            
            if let _ = isExpired {
                self.forceLogout(self.navigationController!)
                return
            }
            
            if let _error = error {
                self.function.showUnderstandDialog(self, "Gagal Mendapatkan Data", _error, "Reload", "Cancel") {
                    self.getDaftarCuti()
                }
                return
            }
            
            guard let _data = leaveList?.data, let _leaveList = leaveList else { return }
            
            if self.currentPage == 0 { self.listDaftarCuti.removeAll() }
            
            _data.leave.forEach { (item) in
                self.listDaftarCuti.append(item)
            }
            
            self.labelEmpty.isHidden = _data.leave.count > 0 && self.listDaftarCuti.count > 0
            self.labelEmpty.text = _leaveList.message
            self.totalPage = _data.total_page
            self.currentPage += 1
            self.collectionDaftarCuti.reloadData()
        }
    }
}

extension DaftarCutiController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let numberHeight = listDaftarCuti[indexPath.item].number?.getHeight(withConstrainedWidth: UIScreen.main.bounds.width - 32, font_size: 10) ?? 0
        let dateHeight = listDaftarCuti[indexPath.item].dates?.getHeight(withConstrainedWidth: UIScreen.main.bounds.width - 32, font_size: 10) ?? 0
        let totalHeight = (numberHeight * 2) + (dateHeight * 2) + 36
        return CGSize(width: UIScreen.main.bounds.width - 32, height: totalHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.item == listDaftarCuti.count - 1 {
            if self.allowLoadMore && currentPage + 1 <= totalPage {
                self.getDaftarCuti()
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
        return listDaftarCuti.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DaftarCutiCell", for: indexPath) as! DaftarCutiCell
        let item = listDaftarCuti[indexPath.item]
        cell.imageProfile.loadUrl(item.photo ?? "")
        cell.buttonStatus.setTitle(item.status, for: .normal)
        cell.buttonStatus.backgroundColor = UIColor(hexString: item.status_color?.replacingOccurrences(of: "#", with: "") ?? "#")
        cell.labelNama.text = item.emp_name
        cell.labelNumber.text = item.number
        cell.labelTypeCuti.text = item.type_name
        cell.labelDate.text = item.dates
        cell.labelTime.text = item.date        
        cell.viewContainer.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(collectionViewContainerClick(sender:))))
        return cell
    }
}

extension DaftarCutiController: FilterDaftarCutiProtocol {
    func updateData(nama: String, startDate: String, endDate: String, typeCuti: String, status: String) {
        empName = nama
        self.startDate = startDate
        self.endDate = endDate
        leaveTypeId = typeCuti
        self.status = status
        currentPage = 0
        listDaftarCuti.removeAll()
        getDaftarCuti()
    }
    
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        refreshControl.endRefreshing()
        currentPage = 0
        listDaftarCuti.removeAll()
        getDaftarCuti()
    }
    
    @objc func collectionViewContainerClick(sender: UITapGestureRecognizer) {
        guard let indexpath = collectionDaftarCuti.indexPathForItem(at: sender.location(in: collectionDaftarCuti)) else { return }
        
        let vc = DetailCutiController()
        vc.leave_id = listDaftarCuti[indexpath.item].id
        vc.title_content = "Detail Cuti"
        vc.isFromDaftarCuti = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func buttonBackClick(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func buttonFilterClick(_ sender: Any) {
        let vc = FilterDaftarCutiController()
        vc.delegate = self
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
