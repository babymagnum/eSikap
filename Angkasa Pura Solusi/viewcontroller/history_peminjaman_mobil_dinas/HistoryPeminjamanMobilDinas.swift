//
//  HistoryPeminjamanMobilDinas.swift
//  Angkasa Pura Solusi
//
//  Created by Arief Zainuri on 15/01/20.
//  Copyright © 2020 Gama Techno. All rights reserved.
//

import UIKit
import SVProgressHUD

class HistoryPeminjamanMobilDinas: BaseViewController, UICollectionViewDelegate {

    @IBOutlet weak var constraintViewRoot: NSLayoutConstraint!
    @IBOutlet weak var collectionPeminjamanMobilDinas: UICollectionView!
    @IBOutlet weak var labelKosong: CustomLabel!
    
    private var listPeminjamanMobilDinas = [RequestCarHistoryItem]()
    private var lastVelocityYSign = 0
    private var allowLoadMore = false
    private var currentPage = 0
    private var totalPage = 0
    private var year = ""
    private var status = "0"
    
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
        
        collectionPeminjamanMobilDinas.collectionViewLayout.invalidateLayout()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle { return .lightContent }
    
    private func initView() {
        year = function.getCurrentDate(pattern: "yyyy")
        checkTopMargin(viewRootTopMargin: constraintViewRoot)
        function.changeStatusBar(hexCode: 0x42a5f5, view: self.view, opacity: 1)
        
        let layout = collectionPeminjamanMobilDinas.collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width - 30, height: 60)
        collectionPeminjamanMobilDinas.register(UINib(nibName: "HistoryPeminjamanMobilCell", bundle: nil), forCellWithReuseIdentifier: "HistoryPeminjamanMobilCell")
        collectionPeminjamanMobilDinas.delegate = self
        collectionPeminjamanMobilDinas.dataSource = self
        collectionPeminjamanMobilDinas.addSubview(refreshControl)
    }

    private func getHistory() {
        SVProgressHUD.show()
        
        informationNetworking.getRequestCarHistoryList(page: currentPage, year: year, status: status) { (error, requestCarHistory, isExpired) in
            SVProgressHUD.dismiss()
            
            if let _ = isExpired {
                self.forceLogout(self.navigationController!)
                return
            }
            
            if let _error = error {
                self.function.showUnderstandDialog(self, "Gagal Mendapatkan Data", _error, "Reload") {
                    self.getHistory()
                }
                return
            }
            
            DispatchQueue.main.async {
                guard let _requestCarHistory = requestCarHistory else { return }
                self.labelKosong.text = _requestCarHistory.message
                if self.currentPage == 0 { self.listPeminjamanMobilDinas.removeAll() }
                
                self.currentPage += 1
                self.totalPage = _requestCarHistory.data.total_page
                var indexpaths = [IndexPath]()
                _requestCarHistory.data.requestcar.forEach { (item) in
                    self.listPeminjamanMobilDinas.append(item)
                    indexpaths.append(IndexPath(item: self.listPeminjamanMobilDinas.count - 1, section: 0))
                }
                
                self.labelKosong.isHidden = self.listPeminjamanMobilDinas.count > 0
                self.collectionPeminjamanMobilDinas.insertItems(at: indexpaths)
            }
        }
    }
}

extension HistoryPeminjamanMobilDinas: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.item == listPeminjamanMobilDinas.count - 1 {
            if self.allowLoadMore && currentPage + 1 <= totalPage {
                self.getHistory()
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
        return listPeminjamanMobilDinas.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HistoryPeminjamanMobilCell", for: indexPath) as! HistoryPeminjamanMobilCell
        cell.data = listPeminjamanMobilDinas[indexPath.item]
        cell.viewRoot.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(collectionViewRootClick(sender:))))
        return cell
    }
}

extension HistoryPeminjamanMobilDinas: FilterHistoryPeminjamanMobilProtocol {
    func terapkan(years: String, status: String) {
        self.status = status
        self.year = years
        listPeminjamanMobilDinas.removeAll()
        currentPage = 0
        getHistory()
    }
    
    @objc func collectionViewRootClick(sender: UITapGestureRecognizer) {
        guard let indexpath = collectionPeminjamanMobilDinas.indexPathForItem(at: sender.location(in: collectionPeminjamanMobilDinas)) else { return }
        
        let vc = DetailPeminjamanMobilController()
        vc.requestId = listPeminjamanMobilDinas[indexpath.item].id
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func buttonFilterClick(_ sender: Any) {
        let vc = FilterHistoryPeminjamanMobilController()
        vc.delegate = self
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func buttonBackClick(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func handleRefresh(_ refresh: UIRefreshControl) {
        refresh.endRefreshing()
        listPeminjamanMobilDinas.removeAll()
        currentPage = 0
        getHistory()
    }
    
}
