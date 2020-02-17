//
//  KebijakanPeraturanDetail.swift
//  Angkasa Pura Solusi
//
//  Created by Arief Zainuri on 17/01/20.
//  Copyright © 2020 Gama Techno. All rights reserved.
//

import UIKit
import SVProgressHUD

class KebijakanPeraturanDetail: BaseViewController, UICollectionViewDelegate {

    @IBOutlet weak var constraintViewRoot: NSLayoutConstraint!
    @IBOutlet weak var collectionKebijakanPeraturan: UICollectionView!
    @IBOutlet weak var labelKosong: CustomLabel!
    @IBOutlet weak var labelTitle: CustomLabel!
    
    var titleString: String?
    var policyCategoryId: String?
    var previousSelectedYear: String?
    
    private var year = ""
    private var listPolicy = [PolicyDataListItem]()
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
        
        getDetailList()
    }
    
    private func getDetailList() {
        guard let _id = policyCategoryId else { return }
        
        SVProgressHUD.show()
        
        informationNetworking.getPolicy(page: currentPage, year: year, categoryId: _id) { (error, policy, isExpired) in
            DispatchQueue.main.async {
                SVProgressHUD.dismiss()
                
                if let _ = isExpired {
                    self.forceLogout(self.navigationController!)
                    return
                }
                
                if let _error = error {
                    self.function.showUnderstandDialog(self, "Gagal Mendapatkan Data", _error, "Reload", "Cancel") {
                        self.getDetailList()
                    }
                }
                
                guard let _policy = policy else { return }
                
                if self.currentPage == 0 { self.listPolicy.removeAll() }
                self.totalPage = _policy.data?.total_page ?? 1
                self.currentPage += 1
                
                _policy.data?.policy.forEach({ (item) in
                    self.listPolicy.append(PolicyDataListItem(id: item.id, name: item.name, date: item.date, files: item.files, isExpanded: false))
                })
                
                self.labelKosong.text = _policy.message
                self.labelKosong.isHidden = self.listPolicy.count > 0
                self.collectionKebijakanPeraturan.reloadData()
            }
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle { return .lightContent }
    
    private func initView() {
        year = previousSelectedYear ?? function.getCurrentDate(pattern: "yyyy")
        labelTitle.text = titleString ?? ""
        checkTopMargin(viewRootTopMargin: constraintViewRoot)
        function.changeStatusBar(hexCode: 0x42a5f5, view: self.view, opacity: 1)
        
        collectionKebijakanPeraturan.register(UINib(nibName: "KebijakanPeraturanDetailCell", bundle: nil), forCellWithReuseIdentifier: "KebijakanPeraturanDetailCell")
        collectionKebijakanPeraturan.delegate = self
        collectionKebijakanPeraturan.dataSource = self
        collectionKebijakanPeraturan.addSubview(refreshControl)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        collectionKebijakanPeraturan.collectionViewLayout.invalidateLayout()
    }

}

extension KebijakanPeraturanDetail: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, KebijakanPeraturanDetailProtocol, URLSessionDownloadDelegate, UIDocumentInteractionControllerDelegate {
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.item == listPolicy.count - 1 {
            if self.allowLoadMore && currentPage + 1 <= totalPage {
                self.getDetailList()
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
    
    func documentInteractionControllerViewControllerForPreview(_ controller: UIDocumentInteractionController) -> UIViewController {
        return self
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        SVProgressHUD.dismiss()
        
        // create destination URL with the original pdf name
        guard let url = downloadTask.originalRequest?.url else { return }
        let documentsPath = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)[0]
        let destinationURL = documentsPath.appendingPathComponent(url.lastPathComponent)
        // delete original copy
        try? FileManager.default.removeItem(at: destinationURL)
        // copy from temp to Document
        do {
            try FileManager.default.copyItem(at: location, to: destinationURL)
            DispatchQueue.main.async {
                let docOpener = UIDocumentInteractionController.init(url: destinationURL)
                docOpener.delegate = self
                docOpener.presentPreview(animated: true)
            }
        } catch let error {
            print("Copy Error: \(error.localizedDescription)")
        }
    }
    
    func expandClick(index: Int, isExpanded: Bool) {
        listPolicy[index].isExpanded = isExpanded
        collectionKebijakanPeraturan.reloadData()
        collectionKebijakanPeraturan.collectionViewLayout.invalidateLayout()
    }
    
    func subItemClick(data: PolicyDataFilesItem) {
        guard let url = URL(string: data.file ?? "") else {
            self.function.showUnderstandDialog(self, "File Tidak Ditemukan", "File yang ingin didownload tidak tersedia di server.", "Mengerti")
            return
        }
        
        let urlSession = URLSession(configuration: .default, delegate: self, delegateQueue: OperationQueue())
        let downloadTask = urlSession.downloadTask(with: url)
        downloadTask.resume()
        SVProgressHUD.show(withStatus: "Sedang mendownload file...")
    }
    
    func updateLayout() {
        collectionKebijakanPeraturan.collectionViewLayout.invalidateLayout()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return listPolicy.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "KebijakanPeraturanDetailCell", for: indexPath) as! KebijakanPeraturanDetailCell
        cell.position = indexPath.item
        cell.data = listPolicy[indexPath.item]
        cell.delegate = self
        return cell
    }
    
    func getTextHeight(_ text: String, _ font_size: CGFloat) -> CGFloat {
        return text.getHeight(withConstrainedWidth: collectionKebijakanPeraturan.frame.width - 30, font_size: font_size)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        var textHeight: CGFloat = 0
        
        listPolicy[indexPath.item].files.forEach { (item) in
            textHeight += getTextHeight(item.file_name ?? "", 12)
        }
        
        let isExpanded = listPolicy[indexPath.item].isExpanded
        let spaceHeight: CGFloat = (CGFloat(4 * (listPolicy[indexPath.item].files.count - 1)))
        if isExpanded {
            return CGSize(width: UIScreen.main.bounds.width - 30, height: 58 + textHeight + 26 + spaceHeight)
        } else {
            return CGSize(width: UIScreen.main.bounds.width - 30, height: 55)
        }
    }
}

extension KebijakanPeraturanDetail: FilterKebijakanPeraturanProtocol {
    func yearsPick(year: String) {
        self.year = year
        currentPage = 0
        listPolicy.removeAll()
        getDetailList()
    }
    
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        refreshControl.endRefreshing()
        currentPage = 0
        listPolicy.removeAll()
        getDetailList()
    }
    
    @IBAction func buttonFilterClick(_ sender: Any) {
        let vc = FilterKebijakanPeraturan()
        vc.delegate = self
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func buttonBackClick(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}
