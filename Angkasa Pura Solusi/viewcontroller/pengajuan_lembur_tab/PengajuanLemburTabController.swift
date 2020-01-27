//
//  PengajuanLemburTabController.swift
//  Angkasa Pura Solusi
//
//  Created by Arief Zainuri on 26/01/20.
//  Copyright © 2020 Gama Techno. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import SVProgressHUD

class PengajuanLemburTabController: BaseViewController, IndicatorInfoProvider {
    
    @IBOutlet weak var collectionPengajuan: UICollectionView!
    @IBOutlet weak var labelEmpty: CustomLabel!
    
    var year: String?
    var status: String?
    
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
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "PENGAJUAN")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initView()
        
        getOvertimeList()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        collectionPengajuan.collectionViewLayout.invalidateLayout()
    }
    
    private func getOvertimeList() {
        guard let _year = year, let _status = status else { return }
        print("tab year \(_year)")
        SVProgressHUD.show()
        
        informationNetworking.getOvertimeHistoryList(status: _status, page: currentPage, year: _year) { (error, overtimeHistory, isExpired) in
            SVProgressHUD.dismiss()
            
            if let _ = isExpired {
                self.forceLogout(self.navigationController!)
                return
            }
            
            if let _error = error {
                self.function.showUnderstandDialog(self, "Gagal Mendapatkan Data", _error, "Reload", "Cancel") {
                    self.getOvertimeList()
                }
                return
            }
            
            guard let _overtimeHistory = overtimeHistory else { return }
            
            _overtimeHistory.data?.overtime.forEach({ (item) in
                self.listPengajuan.append(item)
            })
            
            self.totalPage = _overtimeHistory.data?.total_page ?? 1
            self.currentPage += 1
            self.labelEmpty.text = _overtimeHistory.message
            self.labelEmpty.isHidden = !(self.listPengajuan.count == 0) && !(_overtimeHistory.data?.overtime.count ?? 0 == 0)
            self.collectionPengajuan.reloadData()
        }
    }

    override var preferredStatusBarStyle: UIStatusBarStyle { return .lightContent }
    
    private func initView() {
        collectionPengajuan.register(UINib(nibName: "PengajuanLemburCell", bundle: nil), forCellWithReuseIdentifier: "PengajuanLemburCell")
        collectionPengajuan.delegate = self
        collectionPengajuan.dataSource = self
        collectionPengajuan.addSubview(refreshControl)
        let collectionLayout = collectionPengajuan.collectionViewLayout as! UICollectionViewFlowLayout
        collectionLayout.itemSize = CGSize(width: UIScreen.main.bounds.width - 32, height: 60 - 33 + ((UIScreen.main.bounds.width - 32) * 0.11))
    }
}

extension PengajuanLemburTabController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.item == listPengajuan.count - 1 {
            if self.allowLoadMore && currentPage + 1 <= totalPage {
                self.getOvertimeList()
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
        cell.imageStatus.image = UIImage(named: listPengajuan[indexPath.item].status_icon ?? "")
        cell.viewContainer.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(collectionViewContainerClick(sender:))))
        return cell
    }
}

extension PengajuanLemburTabController {
    @objc func collectionViewContainerClick(sender: UITapGestureRecognizer) {
        guard let indexpath = collectionPengajuan.indexPathForItem(at: sender.location(in: collectionPengajuan)) else { return }
    }
    
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        refreshControl.endRefreshing()
        currentPage = 0
        listPengajuan.removeAll()
        getOvertimeList()
    }
}