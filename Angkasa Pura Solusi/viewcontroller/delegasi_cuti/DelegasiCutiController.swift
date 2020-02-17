//
//  DelegasiCutiController.swift
//  Angkasa Pura Solusi
//
//  Created by Arief Zainuri on 02/09/19.
//  Copyright © 2019 Gama Techno. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import SVProgressHUD

class DelegasiCutiController: BaseViewController, IndicatorInfoProvider, UICollectionViewDelegate {
    
    @IBOutlet weak var collectionDelegasiCuti: UICollectionView!
    @IBOutlet weak var labelDataKosong: CustomLabel!
    
    var listDelegasiCuti = [ItemDelegation]()
    var isCalculateCutiHeight = false
    var currentPage = 0
    var totalPage = 0
    var lastVelocityYSign = 0
    var allowLoadMore = false
    
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(handleRefresh(_:)),for: UIControl.Event.valueChanged)
        refreshControl.tintColor = UIColor(hexString: "42a5f5")
        
        return refreshControl
    }()
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionDelegasiCuti.collectionViewLayout.invalidateLayout()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initCollection()
        
        getLeaveDelegationList()
    }
    
    private func initCollection() {
        collectionDelegasiCuti.register(UINib(nibName: "CutiCell", bundle: nil), forCellWithReuseIdentifier: "CutiCell")
        
        collectionDelegasiCuti.addSubview(refreshControl)
        collectionDelegasiCuti.delegate = self
        collectionDelegasiCuti.dataSource = self
    }
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "DELEGASI CUTI")
    }

    func getLeaveDelegationList() {
        SVProgressHUD.show()
        
        informationNetworking.getLeaveDelegationList(page: currentPage) { (error, delegationList, isExpired) in
            DispatchQueue.main.async {
                SVProgressHUD.dismiss()
                
                if let _ = isExpired {
                    self.forceLogout(self.navigationController!)
                    return
                }
                
                if let error = error {
                    self.function.showUnderstandDialog(self, "Gagal Mendapatkan Daftar Delegasi Cuti", error, "Reload", "Cancel", completionHandler: {
                        self.getLeaveDelegationList()
                    })
                    return
                }
                
                guard let delegationList = delegationList else { return }
                
                if self.currentPage == 0 { self.listDelegasiCuti.removeAll() }
                
                if delegationList.data?.leave.count == 0 && self.listDelegasiCuti.count == 0 {
                    self.labelDataKosong.text = delegationList.message
                    self.labelDataKosong.isHidden = false
                } else {
                    self.labelDataKosong.isHidden = true
                }
                
                self.totalPage = (delegationList.data?.total_page)!
                
                for cuti in delegationList.data!.leave {
                    self.listDelegasiCuti.append(cuti)
                }
                
                self.currentPage += 1
                self.collectionDelegasiCuti.reloadData()
            }
        }
    }
}

extension DelegasiCutiController {
    @objc func cutiContainerClick(sender: UITapGestureRecognizer) {
        guard let indexpath = collectionDelegasiCuti.indexPathForItem(at: sender.location(in: collectionDelegasiCuti)) else { return }
        
        let vc = DetailCutiController()
        vc.leave_id = listDelegasiCuti[indexpath.item].id
        vc.title_content = "Detail Delegasi Cuti"
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        refreshControl.endRefreshing()
        currentPage = 0
        getLeaveDelegationList()
    }
}

extension DelegasiCutiController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.item == listDelegasiCuti.count - 1 {
            if self.allowLoadMore && currentPage + 1 <= totalPage {
                self.getLeaveDelegationList()
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
        return listDelegasiCuti.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cutiCell = collectionView.dequeueReusableCell(withReuseIdentifier: "CutiCell", for: indexPath) as! CutiCell
        
        if !isCalculateCutiHeight {
            self.isCalculateCutiHeight = true
            DispatchQueue.main.async {
                let cutiLayout = self.collectionDelegasiCuti.collectionViewLayout as! UICollectionViewFlowLayout
                cutiLayout.itemSize = CGSize(width: UIScreen.main.bounds.width - 26, height: cutiCell.viewContainer.getHeight() + 8.9)
            }
        }
        
        cutiCell.data = listDelegasiCuti[indexPath.item]
        cutiCell.viewContainer.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(cutiContainerClick(sender:))))
        return cutiCell
    }
}
