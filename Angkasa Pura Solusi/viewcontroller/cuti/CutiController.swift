//
//  CutiController.swift
//  Angkasa Pura Solusi
//
//  Created by Arief Zainuri on 09/08/19.
//  Copyright © 2019 Gama Techno. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import SVProgressHUD

class CutiController: BaseViewController, IndicatorInfoProvider, UICollectionViewDelegate {
    
    @IBOutlet weak var cutiCollectionView: UICollectionView!
    @IBOutlet weak var labelDataKosong: CustomLabel!
    
    var listCuti = [ItemDelegation]()
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
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "CUTI")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initCollectionView()
        
        getLeaveApprovalList()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        cutiCollectionView.collectionViewLayout.invalidateLayout()
    }
    
    private func getLeaveApprovalList() {
        SVProgressHUD.show()
        
        informationNetworking.getLeaveApprovalList(page: currentPage) { (error, delegationList, isExpired) in
            SVProgressHUD.dismiss()
            
            if let _ = isExpired {
                self.forceLogout(self.navigationController!)
                return
            }
            
            if let error = error {
                self.function.showUnderstandDialog(self, "Gagal Daftar List", error, "Reload", "Cancel", completionHandler: {
                    self.getLeaveApprovalList()
                })
                return
            }
            
            guard let delegationList = delegationList else { return }
            if delegationList.data?.leave.count == 0 && self.listCuti.count == 0 {
                self.labelDataKosong.text = delegationList.message
                self.labelDataKosong.isHidden = false
            } else {
                self.labelDataKosong.isHidden = true
            }
            self.totalPage = (delegationList.data?.total_page)!
            
            for cuti in delegationList.data!.leave {
                self.listCuti.append(cuti)
            }
            
            self.currentPage += 1
            self.cutiCollectionView.reloadData()
        }
    }
    
    private func initCollectionView() {
        cutiCollectionView.register(UINib(nibName: "CutiCell", bundle: nil), forCellWithReuseIdentifier: "CutiCell")
        
        cutiCollectionView.addSubview(refreshControl)
        cutiCollectionView.delegate = self
        cutiCollectionView.dataSource = self
    }
}

extension CutiController {
    @objc func cutiContainerClick(sender: UITapGestureRecognizer) {
        guard let indexpath = cutiCollectionView.indexPathForItem(at: sender.location(in: cutiCollectionView)) else { return }
        
        let vc = DetailPersetujuanCutiController()
        vc.leave_id = listCuti[indexpath.item].id
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        refreshControl.endRefreshing()
        listCuti.removeAll()
        currentPage = 0
        getLeaveApprovalList()
    }
}

extension CutiController : UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.item == listCuti.count - 1 {
            if self.allowLoadMore && currentPage + 1 < totalPage {
                self.getLeaveApprovalList()
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
        return listCuti.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cutiCell = collectionView.dequeueReusableCell(withReuseIdentifier: "CutiCell", for: indexPath) as! CutiCell
        
        if !isCalculateCutiHeight {
            self.isCalculateCutiHeight = true
            DispatchQueue.main.async {
                let cutiLayout = self.cutiCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
                cutiLayout.itemSize = CGSize(width: UIScreen.main.bounds.width - 26, height: cutiCell.viewContainer.getHeight() + 8.9)
            }
        }
        
        cutiCell.data = listCuti[indexPath.item]
        cutiCell.viewContainer.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(cutiContainerClick(sender:))))
        return cutiCell
    }
}
