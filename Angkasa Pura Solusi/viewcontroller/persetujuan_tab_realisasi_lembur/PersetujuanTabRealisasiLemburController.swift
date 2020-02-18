//
//  PersetujuanTabRealisasiLemburController.swift
//  Angkasa Pura Solusi
//
//  Created by Arief Zainuri on 30/01/20.
//  Copyright © 2020 Gama Techno. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import SVProgressHUD

class PersetujuanTabRealisasiLemburController: BaseViewController, IndicatorInfoProvider {
    
    @IBOutlet weak var collectionRealisasiLembur: UICollectionView!
    @IBOutlet weak var labelEmpty: CustomLabel!
    
    private var listLembur = [OvertimeApprovalListDataItem]()
    private var lastVelocityYSign = 0
    private var allowLoadMore = false
    private var currentPage = 0
    private var totalPage = 0
        
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(handleRefresh(_:)),for: UIControl.Event.valueChanged)
        refreshControl.tintColor = UIColor(hexString: "42a5f5")
        
        return refreshControl
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initView()
        
        getLembur()
    }

    private func initView() {
        collectionRealisasiLembur.register(UINib(nibName: "PersetujuanLemburTabCell", bundle: nil), forCellWithReuseIdentifier: "PersetujuanLemburTabCell")
        collectionRealisasiLembur.delegate = self
        collectionRealisasiLembur.dataSource = self
        collectionRealisasiLembur.addSubview(refreshControl)
        let collectionLayout = collectionRealisasiLembur.collectionViewLayout as! UICollectionViewFlowLayout
        collectionLayout.itemSize = CGSize(width: UIScreen.main.bounds.width - 32, height: 60)
    }
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "REALISASI LEMBUR")
    }
    
    private func getLembur() {
        SVProgressHUD.show()
        
        informationNetworking.getOvertimeRealizationApprovalList(page: currentPage, year: "", status: "") { (error, overtimeApproval, isExpired) in
            DispatchQueue.main.async {
                SVProgressHUD.dismiss()
                
                if let _ = isExpired {
                    self.forceLogout(self.navigationController!)
                    return
                }
                
                if let _error = error {
                    self.function.showUnderstandDialog(self, "Gagal Mendapatkan Data", _error, "Reload", "Cancel") {
                        self.getLembur()
                    }
                    return
                }
                
                guard let _data = overtimeApproval?.data else { return }
                
                if self.currentPage == 0 { self.listLembur.removeAll() }
                
                _data.overtime.forEach { (item) in
                    self.listLembur.append(item)
                }
                
                self.totalPage = _data.total_page
                
                self.currentPage += 1
                
                self.labelEmpty.isHidden = _data.overtime.count > 0 && self.listLembur.count > 0
                
                self.collectionRealisasiLembur.reloadData()
            }
        }
    }
}

extension PersetujuanTabRealisasiLemburController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.item == listLembur.count - 1 {
            if self.allowLoadMore && currentPage + 1 <= totalPage {
                self.getLembur()
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
        return listLembur.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PersetujuanLemburTabCell", for: indexPath) as! PersetujuanLemburTabCell
        let item = listLembur[indexPath.item]
        cell.imageProfile.loadUrl(item.photo ?? "")
        cell.labelNumber.text = item.number
        cell.labelDate.text = item.dates
        cell.labelTime.text = item.date
        cell.viewContainer.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(collectionViewContainerClick(sender:))))
        return cell
    }
}

extension PersetujuanTabRealisasiLemburController {
    @objc func collectionViewContainerClick(sender: UITapGestureRecognizer) {
        guard let indexpath = collectionRealisasiLembur.indexPathForItem(at: sender.location(in: collectionRealisasiLembur)) else { return }
        
        let vc = DetailPersetujuanRealisasiLemburController()
        vc.overtimeId = listLembur[indexpath.item].id
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func handleRefresh(_ refreshControl: UIRefreshControl){
        refreshControl.endRefreshing()
        currentPage = 0
        listLembur.removeAll()
        getLembur()
    }
}
