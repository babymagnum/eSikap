//
//  BeritaController.swift
//  Angkasa Pura Solusi
//
//  Created by Arief Zainuri on 28/07/19.
//  Copyright © 2019 Gama Techno. All rights reserved.
//

import UIKit
import SVProgressHUD

class BeritaController: BaseViewController, UICollectionViewDelegate {
    
    @IBOutlet weak var viewRootTopMargin: NSLayoutConstraint!
    @IBOutlet weak var beritaCollectionView: UICollectionView!
    @IBOutlet weak var labelBeritaKosong: CustomLabel!
    @IBOutlet weak var collectionBeritaBottomMargin: NSLayoutConstraint!
    
    var listBerita = [News]()
    var isCalculateBeritaHeight = false
    var lastVelocityYSign = 0
    var allowLoadMore = false
    var totalPage = 0
    var currentPage = 0
    
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(handleRefresh(_:)),for: UIControl.Event.valueChanged)
        refreshControl.tintColor = UIColor(hexString: "42a5f5")
        
        return refreshControl
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        checkTopMargin(viewRootTopMargin: viewRootTopMargin)
        
        function.changeStatusBar(hexCode: 0x42A5F5, view: self.view, opacity: 1)

        initCollectionView()
        
        getAllNews()
        
        checkVersion()
    }
    
    private func checkVersion() {
        if #available(iOS 11, *) {
            //do nothing
        } else {
            collectionBeritaBottomMargin.constant += 49 // 49 is height of ui tabbar
            self.view.layoutIfNeeded()
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle { return .lightContent }
    
    private func initCollectionView() {
        beritaCollectionView.addSubview(refreshControl)
        
        beritaCollectionView.register(UINib(nibName: "BeritaCell", bundle: nil), forCellWithReuseIdentifier: "BeritaCell")
        
        beritaCollectionView.delegate = self
        beritaCollectionView.dataSource = self
    }
    
    private func getAllNews() {
        SVProgressHUD.show()
        
        informationNetworking.getAllNews(page: currentPage) { (error, allNews, isExpired) in
            DispatchQueue.main.async {
                SVProgressHUD.dismiss()
                
                if let _ = isExpired {
                    self.forceLogout(self.navigationController!)
                    return
                }
                
                if let error = error {
                    self.function.showUnderstandDialog(self, "Error getting news", error, "Reload", "Cancel", completionHandler: {
                        self.getAllNews()
                    })
                    return
                }
                
                guard let allNews = allNews else { return }
                
                if allNews.count == 0 && self.listBerita.count == 0 {
                    self.labelBeritaKosong.isHidden = false
                } else {
                    self.labelBeritaKosong.isHidden = true
                }
                
                self.currentPage += 1
                
                for news in allNews {
                    self.listBerita.append(news)
                }
                
                self.beritaCollectionView.reloadData()
            }
        }
    }
}

extension BeritaController {
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        refreshControl.endRefreshing()
        listBerita.removeAll()
        currentPage = 0
        getAllNews()
    }
    
    @objc func viewContainerClick(sender: UITapGestureRecognizer){
        if let indexpath = beritaCollectionView.indexPathForItem(at: sender.location(in: beritaCollectionView)) {
            let vc = DetailBeritaController()
            vc.news = listBerita[indexpath.item]
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @IBAction func buttonFilterClick(_ sender: Any) { showInDevelopmentDialog() }
}

extension BeritaController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.item == listBerita.count - 1 {
            if self.allowLoadMore && currentPage + 1 <= totalPage {
                self.getAllNews()
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
        return listBerita.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let beritaCell = collectionView.dequeueReusableCell(withReuseIdentifier: "BeritaCell", for: indexPath) as! BeritaCell
        
        if !isCalculateBeritaHeight {
            self.isCalculateBeritaHeight = true
            let beritaHeight = ((UIScreen.main.bounds.width - 26) * 0.45) + beritaCell.labelCreatedAt.getHeight(width: beritaCell.labelCreatedAt.frame.width) + beritaCell.labelTitle.getHeight(width: beritaCell.labelTitle.frame.width) + 29.5
            let layoutBeritaCollectionView = beritaCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
            layoutBeritaCollectionView.itemSize = CGSize(width: UIScreen.main.bounds.width - 26, height: beritaHeight)
        }
        
        beritaCell.data = listBerita[indexPath.item]
        beritaCell.viewContainer.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(viewContainerClick(sender:))))
        return beritaCell
    }
    
}
