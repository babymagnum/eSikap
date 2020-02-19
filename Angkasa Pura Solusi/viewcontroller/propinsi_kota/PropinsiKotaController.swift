//
//  PropinsiKotaController.swift
//  Angkasa Pura Solusi
//
//  Created by Arief Zainuri on 15/01/20.
//  Copyright © 2020 Gama Techno. All rights reserved.
//

import UIKit
import SVProgressHUD

protocol PropinsiKotaProtocol {
    func propinsiKotaPicked(propinsiCity: PropinsiCityDataItem)
}

class PropinsiKotaController: BaseViewController, UICollectionViewDelegate, UITextFieldDelegate {

    @IBOutlet weak var constraintViewRoot: NSLayoutConstraint!
    @IBOutlet weak var viewSearch: UIView!
    @IBOutlet weak var fieldSearch: CustomTextField!
    @IBOutlet weak var labelTitleTop: CustomLabel!
    @IBOutlet weak var imageCancelSearch: UIImageView!
    @IBOutlet weak var imageSearchTop: UIImageView!
    @IBOutlet weak var collectionPropinsiKota: UICollectionView!
    
    var titleString: String?
    var isSearchPropinsi: Bool?
    var delegate: PropinsiKotaProtocol?
    var propinsiId: String?
    
    private var listPropinsiKota = [PropinsiCityDataItem]()
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
        
        initEvent()
        
        getPropinsiKota()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        collectionPropinsiKota.collectionViewLayout.invalidateLayout()
    }
    
    private func initEvent() {
        imageSearchTop.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(imageSearchTopClick)))
        
        imageCancelSearch.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(imageCancelSearchClick)))
    }
    
    private func initView() {
        if let _title = titleString {
            labelTitleTop.text = _title
            fieldSearch.attributedPlaceholder = NSAttributedString(string: "Cari \(_title)",attributes: [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12 + function.dynamicCustomDevice())])
        }
        
        checkTopMargin(viewRootTopMargin: constraintViewRoot)
        function.changeStatusBar(hexCode: 0x42a5f5, view: self.view, opacity: 1)
        
        fieldSearch.delegate = self
        
        imageSearchTop.image = UIImage(named: "icSearchWhite")?.tinted(with: UIColor.white)
        imageCancelSearch.image = UIImage(named: "close-button")?.tinted(with: UIColor.white)
        
        let layoutMenuCollectionView = collectionPropinsiKota.collectionViewLayout as! UICollectionViewFlowLayout
        layoutMenuCollectionView.itemSize = CGSize(width: UIScreen.main.bounds.width - 20, height: 44)
        
        collectionPropinsiKota.register(UINib(nibName: "PropinsiKotaCell", bundle: nil), forCellWithReuseIdentifier: "PropinsiKotaCell")
        collectionPropinsiKota.addSubview(refreshControl)
        collectionPropinsiKota.delegate = self
        collectionPropinsiKota.dataSource = self
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle { return .lightContent }

    @IBAction func buttonBackClick(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    private func getPropinsiKota() {
        guard let _isSearchPropinsi = isSearchPropinsi else { return }
        
        SVProgressHUD.show()
        
        if _isSearchPropinsi {
            informationNetworking.getStateFilter(page: currentPage, keyword: fieldSearch.text ?? "") { (error, propinsiCity, isExpired) in
                DispatchQueue.main.async {
                    SVProgressHUD.dismiss()
                    
                    if let _ = isExpired {
                        self.forceLogout(self.navigationController!)
                        return
                    }
                    
                    if let _error = error {
                        print("error get propinsi \(_error)")
                        self.function.showUnderstandDialog(self, "Gagal Mendapatkan Data", _error, "Reload", "Cancel", completionHandler: {
                            self.getPropinsiKota()
                        })
                        return
                    }
                    
                    guard let _propinsiCity = propinsiCity else { return }
                    
                    if self.currentPage == 0 { self.listPropinsiKota.removeAll() }
                    
                    _propinsiCity.data?.emp.forEach({ (item) in
                        self.listPropinsiKota.append(item)
                    })
                    
                    self.totalPage = _propinsiCity.data?.total_page ?? 1
                    self.currentPage += 1
                    
                    self.collectionPropinsiKota.reloadData()
                }
            }
        } else {
            informationNetworking.getCityFilter(page: currentPage, propinsiId: propinsiId ?? "", keyword: fieldSearch.text ?? "") { (error, propinsiCity, isExpired) in
                DispatchQueue.main.async {
                    SVProgressHUD.dismiss()
                    
                    if let _ = isExpired {
                        self.forceLogout(self.navigationController!)
                        return
                    }
                    
                    if let _error = error {
                        self.function.showUnderstandDialog(self, "Gagal Mendapatkan Data", _error, "Reload", "Cancel", completionHandler: {
                            self.getPropinsiKota()
                        })
                        return
                    }
                    
                    guard let _propinsiCity = propinsiCity else { return }
                    
                    if self.currentPage == 0 { self.listPropinsiKota.removeAll() }
                    
                    _propinsiCity.data?.emp.forEach({ (item) in
                        self.listPropinsiKota.append(item)
                    })
                    
                    self.totalPage = _propinsiCity.data?.total_page ?? 1
                    self.currentPage += 1
                    
                    self.collectionPropinsiKota.reloadData()
                }
            }
        }
    }
}

extension PropinsiKotaController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.item == listPropinsiKota.count - 1 {
            if self.allowLoadMore && currentPage + 1 <= totalPage {
                self.getPropinsiKota()
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
        return listPropinsiKota.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PropinsiKotaCell", for: indexPath) as! PropinsiKotaCell
        cell.data = listPropinsiKota[indexPath.item]
        cell.viewRoot.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(collectionViewRootClick(sender:))))
        return cell
    }
}

extension PropinsiKotaController {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == fieldSearch {
            fieldSearch.resignFirstResponder()
            self.currentPage = 0
            self.listPropinsiKota.removeAll()
            self.getPropinsiKota()
            return true
        }
        
        return true
    }
    
    @objc func collectionViewRootClick(sender: UITapGestureRecognizer) {
        guard let indexpath = collectionPropinsiKota.indexPathForItem(at: sender.location(in: collectionPropinsiKota)) else { return }
        
        guard let _delegate = delegate else { return }
        
        _delegate.propinsiKotaPicked(propinsiCity: listPropinsiKota[indexpath.item])
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        refreshControl.endRefreshing()
        currentPage = 0
        getPropinsiKota()
    }
    
    @objc func imageSearchTopClick() {
        UIView.animate(withDuration: 0.2) {
            self.labelTitleTop.isHidden = true
            self.imageSearchTop.isHidden = true
            self.viewSearch.isHidden = false
            self.viewSearch.alpha = 1
            self.fieldSearch.becomeFirstResponder()
            self.view.layoutIfNeeded()
        }
    }
    
    @objc func imageCancelSearchClick() {
        fieldSearch.text = ""
        listPropinsiKota.removeAll()
        currentPage = 0
        getPropinsiKota()
        
        UIView.animate(withDuration: 0.2) {
            self.labelTitleTop.isHidden = false
            self.imageSearchTop.isHidden = false
            self.viewSearch.isHidden = true
            self.viewSearch.alpha = 0
            self.view.layoutIfNeeded()
        }
    }
}
