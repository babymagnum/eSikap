//
//  RealisasiLemburTabController.swift
//  Angkasa Pura Solusi
//
//  Created by Arief Zainuri on 26/01/20.
//  Copyright © 2020 Gama Techno. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import SVProgressHUD

class RealisasiLemburTabController: BaseViewController, IndicatorInfoProvider {

    @IBOutlet weak var collectionRealisasi: UICollectionView!
    @IBOutlet weak var labelEmpty: CustomLabel!
    
    private var listPengajuan = [OvertimeHistoryListItem]()
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
    
    var year: String?
    var status: String?
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "REALISASI")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initView()
        
        getOvertimeRealization()
    }
    
    private func getOvertimeRealization() {
        guard let _status = status, let _year = year else { return }
        
        SVProgressHUD.show()
        
        informationNetworking.getOvertimeRealizationHistoryList(status: _status, page: currentPage, year: _year) { (error, overtimeHistory, isExpired) in
            DispatchQueue.main.async {
                SVProgressHUD.dismiss()
                
                if let _ = isExpired {
                    self.forceLogout(self.navigationController!)
                    return
                }
                
                if let _error = error {
                    self.function.showUnderstandDialog(self, "Gagal Mendapatkan Data", _error, "Reload", "Cancel") {
                        self.getOvertimeRealization()
                    }
                    return
                }
                
                guard let _overtimeHistory = overtimeHistory else { return }
                
                if self.currentPage == 0 { self.listPengajuan.removeAll() }
                
                _overtimeHistory.data?.overtime.forEach({ (item) in
                    self.listPengajuan.append(item)
                })
                
                self.totalPage = _overtimeHistory.data?.total_page ?? 1
                self.currentPage += 1
                self.labelEmpty.text = _overtimeHistory.message
                self.labelEmpty.isHidden = !(self.listPengajuan.count == 0) && !(_overtimeHistory.data?.overtime.count ?? 0 == 0)
                self.collectionRealisasi.reloadData()
            }
        }
    }

    private func initView() {
        collectionRealisasi.register(UINib(nibName: "PengajuanLemburCell", bundle: nil), forCellWithReuseIdentifier: "PengajuanLemburCell")
        collectionRealisasi.dataSource = self
        collectionRealisasi.delegate = self
        collectionRealisasi.addSubview(refreshControl)
        let collectionLayout = collectionRealisasi.collectionViewLayout as! UICollectionViewFlowLayout
        collectionLayout.itemSize = CGSize(width: UIScreen.main.bounds.width - 32, height: function.getGlobalHeight() + 60 - 33 + ((UIScreen.main.bounds.width - 32) * 0.11))
    }
}

extension RealisasiLemburTabController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let item = listPengajuan[indexPath.item]
        
        if item.status == "" {
            return CGSize(width: UIScreen.main.bounds.width - 32, height: 60 - 33 - 12.5 + ((UIScreen.main.bounds.width - 32) * 0.11))
        } else {
            return CGSize(width: UIScreen.main.bounds.width - 32, height: function.getGlobalHeight() + 60 - 33 + ((UIScreen.main.bounds.width - 32) * 0.11))
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.item == listPengajuan.count - 1 {
            if self.allowLoadMore && currentPage + 1 <= totalPage {
                self.getOvertimeRealization()
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
        return listPengajuan.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PengajuanLemburCell", for: indexPath) as! PengajuanLemburCell
        cell.labelDate.text = listPengajuan[indexPath.item].dates
        cell.labelTime.text = listPengajuan[indexPath.item].date
        cell.labelNumber.text = listPengajuan[indexPath.item].number
        cell.labelStatus.text = listPengajuan[indexPath.item].status
        let statusIcon = listPengajuan[indexPath.item].status_icon ?? ""
        cell.imageStatus.image = UIImage(named: statusIcon == "" ? "plus" : statusIcon)
        cell.viewContainer.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(collectionViewContainerClick(sender:))))
        return cell
    }
}

extension RealisasiLemburTabController: DetailPengajuanRealisasiLemburProtocol {
    func updateData() {
        currentPage = 0
        listPengajuan.removeAll()
        getOvertimeRealization()
    }
    
    @objc func collectionViewContainerClick(sender: UITapGestureRecognizer) {
        guard let indexpath = collectionRealisasi.indexPathForItem(at: sender.location(in: collectionRealisasi)) else { return }
        
        let item = listPengajuan[indexpath.item]
        
        if item.status ?? "" == "" {
            let vc = DetailPengajuanRealisasiLembur()
            vc.overtimeId = item.id
            vc.delegate = self
            self.navigationController?.pushViewController(vc, animated: true)
        } else {
            let vc = DetailRealisasiLemburController()
            vc.overtimeId = item.id
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        refreshControl.endRefreshing()
        currentPage = 0
        listPengajuan.removeAll()
        getOvertimeRealization()
    }
}
