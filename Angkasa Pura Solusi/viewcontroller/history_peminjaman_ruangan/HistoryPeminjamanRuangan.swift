//
//  HistoryPeminjamanRuangan.swift
//  Angkasa Pura Solusi
//
//  Created by Arief Zainuri on 25/01/20.
//  Copyright © 2020 Gama Techno. All rights reserved.
//

import UIKit
import SVProgressHUD

class HistoryPeminjamanRuangan: BaseViewController {

    @IBOutlet weak var collectionHistoryPeminjamanRuangan: UICollectionView!
    @IBOutlet weak var labelKosong: CustomLabel!
    
    private var year = ""
    private var listHistory = [RequestRoomsHistoryItem]()
    private var lastVelocityYSign = 0
    private var allowLoadMore = false
    private var currentPage = 0
    private var totalPage = 0
    
    var isFromPeminjamanRuangan: Bool?
    
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(handleRefresh(_:)),for: UIControl.Event.valueChanged)
        refreshControl.tintColor = UIColor(hexString: "42a5f5")
        
        return refreshControl
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initView()
        
        getHistory()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        collectionHistoryPeminjamanRuangan.collectionViewLayout.invalidateLayout()
    }

    private func initView() {
        year = function.getCurrentDate(pattern: "yyyy")
        function.changeStatusBar(hexCode: 0x42a5f5, view: self.view, opacity: 1)
        
        collectionHistoryPeminjamanRuangan.register(UINib(nibName: "HistoryPeminjamanRuanganCell", bundle: nil), forCellWithReuseIdentifier: "HistoryPeminjamanRuanganCell")
        collectionHistoryPeminjamanRuangan.dataSource = self
        collectionHistoryPeminjamanRuangan.delegate = self
        collectionHistoryPeminjamanRuangan.addSubview(refreshControl)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle { return .lightContent }
    
    private func getHistory() {
        SVProgressHUD.show()
        
        informationNetworking.getRequestRoomsHistoryList(page: currentPage, year: year) { (error, requestRoomHistory, isExpired) in
            DispatchQueue.main.async {
                SVProgressHUD.dismiss()
                
                if let _ = isExpired {
                    self.forceLogout(self.navigationController!)
                    return
                }
                
                if let _error = error {
                    self.function.showUnderstandDialog(self, "Gagal Mendapatkan Data", _error, "Reload", "Cancel") {
                        self.getHistory()
                    }
                }
                
                guard let _requestRoomHistory = requestRoomHistory else { return }
                
                _requestRoomHistory.data?.requestrooms.forEach({ (item) in
                    self.listHistory.append(item)
                })
                
                self.labelKosong.text = _requestRoomHistory.message
                self.labelKosong.isHidden = _requestRoomHistory.data?.requestrooms.count ?? 0 > 0 && self.listHistory.count > 0
                
                self.collectionHistoryPeminjamanRuangan.reloadData()
            }
        }
    }
}

extension HistoryPeminjamanRuangan: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let item = listHistory[indexPath.item]
        let titleHeight = item.title_agenda?.getHeight(withConstrainedWidth: UIScreen.main.bounds.width - 30 - 20 - 30 - 14 - 22, font_size: 12) ?? 0
        let dateHeight = item.date_use?.getHeight(withConstrainedWidth: UIScreen.main.bounds.width - 30 - 20 - 30 - 14 - 22, font_size: 12) ?? 0
        return CGSize(width: UIScreen.main.bounds.width - 30, height: titleHeight + dateHeight + 27)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.item == listHistory.count - 1 {
            if self.allowLoadMore && currentPage + 1 <= totalPage {
                getHistory()
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
        return listHistory.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HistoryPeminjamanRuanganCell", for: indexPath) as! HistoryPeminjamanRuanganCell
        cell.labelTitle.text = listHistory[indexPath.item].title_agenda
        cell.labelDate.text = listHistory[indexPath.item].date_use
        let fullTime = "\(listHistory[indexPath.item].date_use?.suffix(8) ?? "\(function.getCurrentDate(pattern: "dd MMMM yyyy HH:mm:ss"))")"
        cell.labelTime.text = "\(fullTime.prefix(5))"
        cell.viewContainer.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(collectionViewContainer(sender:))))
        return cell
    }
}

extension HistoryPeminjamanRuangan: FilterHistoryPeminjamanMobilProtocol {
    func terapkan(years: String, status: String) {
        year = years
        listHistory.removeAll()
        currentPage = 0
        getHistory()
    }
    
    @objc func collectionViewContainer(sender: UITapGestureRecognizer) {
        guard let indexpath = collectionHistoryPeminjamanRuangan.indexPathForItem(at: sender.location(in: collectionHistoryPeminjamanRuangan)) else { return }
        
        let vc = DetailPeminjamanRuanganController()
        vc.isFromHistory = true
        vc.requestRoomId = listHistory[indexpath.item].id
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func buttonFilterClick(_ sender: Any) {
        let vc = FilterHistoryPeminjamanMobilController()
        vc.delegate = self
        vc.isFromPeminjamanRuangan = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func buttonBackClick(_ sender: Any) {
        if let _ = isFromPeminjamanRuangan {
            backToHome()
        } else {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    @objc func handleRefresh(_ refresh: UIRefreshControl) {
        refreshControl.endRefreshing()
        listHistory.removeAll()
        currentPage = 0
        getHistory()
    }
    
    private func backToHome() {
        let transition = CATransition()
        transition.duration = 0.4
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromLeft
        self.navigationController?.view.layer.add(transition, forKey: kCATransition)
        self.navigationController?.pushViewController(HomeController(), animated: true)
    }
}
