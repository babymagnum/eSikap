//
//  NotifikasiController.swift
//  Angkasa Pura Solusi
//
//  Created by Arief Zainuri on 28/07/19.
//  Copyright © 2019 Gama Techno. All rights reserved.
//

import UIKit
import SVProgressHUD

class NotifikasiController: BaseViewController, UICollectionViewDelegate {

    @IBOutlet weak var viewRootTopMargin: NSLayoutConstraint!
    @IBOutlet weak var notifikasiCollectionView: UICollectionView!
    @IBOutlet weak var viewNotifikasiKosong: UIView!
    
    private var listNotifikasi = [ItemListNotification]()
    var lastVelocityYSign = 0
    var allowLoadMore = false
    var totalPage = 0
    var currentPage = 0
    
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(handleRefresh(_:)),for: UIControl.Event.valueChanged)
        refreshControl.tintColor = UIColor.blue
        
        return refreshControl
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        checkTopMargin(viewRootTopMargin: viewRootTopMargin)
        
        function.changeStatusBar(hexCode: 0x42a5f5, view: self.view, opacity: 1.0)
        
        initCollectionView()
        
        getNotificationList()
    }
    
    private func getNotificationList() {
        SVProgressHUD.show()
        
        informationNetworking.getNotificationList(page: currentPage) { (error, listNotification, isExpired) in
            SVProgressHUD.dismiss()
            
            if let _ = isExpired {
                self.forceLogout(self.navigationController!)
                return
            }
            
            if let error = error {
                self.function.showUnderstandDialog(self, "Gagal Mendapatkan Daftar Notifikasi", error, "Reload", "Cancel", completionHandler: {
                    self.getNotificationList()
                })
                return
            }
            
            guard let listNotification = listNotification else { return }
            
            self.viewNotifikasiKosong.isHidden = listNotification.data?.notification.count == 0 && self.listNotifikasi.count == 0 ? false : true
            
            self.totalPage = (listNotification.data?.total_page)!
            
            for notification in listNotification.data!.notification {
                self.listNotifikasi.append(notification)
            }
            
            self.currentPage += 1
            self.notifikasiCollectionView.reloadData()
        }
    }
    
    private func initCollectionView() {
        notifikasiCollectionView.register(UINib(nibName: "NotifikasiCell", bundle: nil), forCellWithReuseIdentifier: "NotifikasiCell")
        
        notifikasiCollectionView.delegate = self
        notifikasiCollectionView.dataSource = self
        
        notifikasiCollectionView.addSubview(refreshControl)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle { return .lightContent }

}

extension NotifikasiController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.item == listNotifikasi.count - 1 {
            if self.allowLoadMore && currentPage + 1 < totalPage {
                self.getNotificationList()
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
    
    func getTextHeight(_ text: String, _ font_size: CGFloat) -> CGFloat {
        return text.getHeight(withConstrainedWidth: notifikasiCollectionView.frame.width, font_size: 10)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let item = listNotifikasi[indexPath.item]
        
        let heightMargin: CGFloat = 8.9 + 8.3 + 10.7 + 5 + 8
        let contentHeight = getTextHeight(item.title!, 10) + getTextHeight(item.date!, 6) + getTextHeight(item.content!, 11)
        return CGSize(width: notifikasiCollectionView.frame.width - 26.6, height: heightMargin + contentHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return listNotifikasi.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NotifikasiCell", for: indexPath) as! NotifikasiCell
        cell.data = listNotifikasi[indexPath.item]
        return cell
    }
}

extension NotifikasiController {
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        refreshControl.endRefreshing()
        currentPage = 0
        listNotifikasi.removeAll()
        getNotificationList()
    }
}
