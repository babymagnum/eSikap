//
//  SearchDelegasiOrAtasanController.swift
//  Angkasa Pura Solusi
//
//  Created by Arief Zainuri on 03/09/19.
//  Copyright © 2019 Gama Techno. All rights reserved.
//

import UIKit
import SVProgressHUD

protocol SearchDelegasiOrAtasanProtocol {
    func namePicked(itemEmp: ItemEmp, type: String)
}

class SearchDelegasiOrAtasanController: BaseViewController, UICollectionViewDelegate, UITextFieldDelegate {

    @IBOutlet weak var viewSearch: UIView!
    @IBOutlet weak var imageSearchTop: UIImageView!
    @IBOutlet weak var labelTitleTop: CustomLabel!
    @IBOutlet weak var fieldSearch: CustomTextField!
    @IBOutlet weak var viewRootTopMargin: NSLayoutConstraint!
    @IBOutlet weak var collectionName: UICollectionView!
    @IBOutlet weak var imageCancelSearch: UIImageView!
    
    private var lastVelocityYSign = 0
    private var allowLoadMore = false
    private var listEmpFilter = [ItemEmp]()
    private var isSetCollectionNameHeight = false
    private var currentPage = 0
    private var totalPage = 0
    
    var delegate: SearchDelegasiOrAtasanProtocol!
    var type: String!
    
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(handleRefresh(_:)),for: UIControl.Event.valueChanged)
        refreshControl.tintColor = UIColor(hexString: "42a5f5")
        
        return refreshControl
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initView()
        
        initEvent()
        
        initCollection()
        
        getEmpFilter()
    }
    
    private func initEvent() {
        imageSearchTop.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(imageSearchTopClick)))
        
        imageCancelSearch.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(imageCancelSearchClick)))
    }
    
    private func initView() {
        checkTopMargin(viewRootTopMargin: viewRootTopMargin)
        fieldSearch.attributedPlaceholder = NSAttributedString(string: "Tekan di sini untuk mencari \(type ?? "")...",attributes: [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12 + function.dynamicCustomDevice())])
        imageSearchTop.image = UIImage(named: "icSearchWhite")?.tinted(with: UIColor.white)
        imageCancelSearch.image = UIImage(named: "close-button")?.tinted(with: UIColor.white)
        labelTitleTop.text = "Cari \(type ?? "")"
        function.changeStatusBar(hexCode: 0x42a5f5, view: self.view, opacity: 1)
        fieldSearch.delegate = self
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle { return .lightContent }
    
    private func getEmpFilter() {
        SVProgressHUD.show()
        
        informationNetworking.getEmpListFilter(page: currentPage, keyword: fieldSearch.trim()) { (error, listEmpFilter, isExpired) in
            SVProgressHUD.dismiss()
            
            if let _ = isExpired {
                self.forceLogout(self.navigationController!)
                return
            }
            
            if let error = error {
                self.function.showUnderstandDialog(self, "Gagal Mendapatkan Daftar Atasan", error, "Reload", "Cancel", completionHandler: {
                    self.getEmpFilter()
                })
                return
            }
            
            guard let listEmpFilter = listEmpFilter else { return }
            self.totalPage = (listEmpFilter.data?.total_page)!
            
            for emp in listEmpFilter.data!.emp {
                self.listEmpFilter.append(emp)
            }
            
            self.currentPage += 1
            self.collectionName.reloadData()
        }
    }
    
    private func initCollection() {
        collectionName.register(UINib(nibName: "EmpFilterCell", bundle: nil), forCellWithReuseIdentifier: "EmpFilterCell")
        collectionName.addSubview(refreshControl)
        collectionName.delegate = self
        collectionName.dataSource = self
    }
    
}

extension SearchDelegasiOrAtasanController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.item == listEmpFilter.count - 1 {
            if self.allowLoadMore && currentPage + 1 <= totalPage {
                self.getEmpFilter()
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
        return listEmpFilter.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "EmpFilterCell", for: indexPath) as! EmpFilterCell
        cell.data = listEmpFilter[indexPath.item]
        cell.viewContainer.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(containerNameClick(sender:))))
        
        if !isSetCollectionNameHeight {
            self.isSetCollectionNameHeight = true
            DispatchQueue.main.async {
                let nameLayout = self.collectionName.collectionViewLayout as! UICollectionViewFlowLayout
                nameLayout.itemSize = CGSize(width: self.collectionName.frame.width - 26, height: cell.viewContainer.getHeight() + 11)
            }
        }
        
        return cell
    }
}

extension SearchDelegasiOrAtasanController {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == fieldSearch {
            fieldSearch.resignFirstResponder()
            self.currentPage = 0
            self.listEmpFilter.removeAll()
            self.getEmpFilter()
            return true
        }
        
        return true
    }
    
    @objc func imageSearchTopClick() {
        UIView.animate(withDuration: 0.2) {
            self.labelTitleTop.isHidden = true
            self.imageSearchTop.isHidden = true
            self.viewSearch.isHidden = false
            self.viewSearch.alpha = 1
            self.view.layoutIfNeeded()
        }
    }
    
    @objc func imageCancelSearchClick() {
        fieldSearch.text = ""
        listEmpFilter.removeAll()
        currentPage = 0
        getEmpFilter()
        
        UIView.animate(withDuration: 0.2) {
            self.labelTitleTop.isHidden = false
            self.imageSearchTop.isHidden = false
            self.viewSearch.isHidden = true
            self.viewSearch.alpha = 0
            self.view.layoutIfNeeded()
        }
    }
    
    @objc func containerNameClick(sender: UITapGestureRecognizer) {
        guard let indexpath = collectionName.indexPathForItem(at: sender.location(in: collectionName)) else { return }
        let item = listEmpFilter[indexpath.item]
        self.delegate.namePicked(itemEmp: item, type: self.type)
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        refreshControl.endRefreshing()
        listEmpFilter.removeAll()
        currentPage = 0
        getEmpFilter()
    }
    
    @IBAction func buttonBackClick(_ sender: Any) { navigationController?.popViewController(animated: true) }
}
