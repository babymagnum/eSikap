//
//  KebijakanPeraturanController.swift
//  Angkasa Pura Solusi
//
//  Created by Arief Zainuri on 16/01/20.
//  Copyright © 2020 Gama Techno. All rights reserved.
//

import UIKit
import SVProgressHUD

class KebijakanPeraturanController: BaseViewController, UICollectionViewDelegate {
    
    @IBOutlet weak var collectionPolicyCategory: UICollectionView!
    @IBOutlet weak var constraintViewRoot: NSLayoutConstraint!
    @IBOutlet weak var labelKosong: CustomLabel!
    
    private var year = ""
    private var listPolicyCategory = [PolicyCategoryDataItem]()
    private var lastVelocityYSign = 0
    private var allowLoadMore = false
    private var currentPage = 0
    private var totalPage = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initView()
        
        getPolicyCategory()
    }
    
    private func getPolicyCategory() {
        SVProgressHUD.show()
        
        informationNetworking.getPolicyCategory(page: currentPage, year: year) { (error, policyCategory, isExpired) in
            SVProgressHUD.dismiss()
            
            if let _ = isExpired {
                self.forceLogout(self.navigationController!)
                return
            }
            
            if let _error = error {
                self.function.showUnderstandDialog(self, "Gagal Mendapatkan Data", _error, "Reload", "Cancel") {
                    self.getPolicyCategory()
                }
                return
            }
            
            guard let _policyCategory = policyCategory else { return }
            
            DispatchQueue.main.async {
                self.labelKosong.text = _policyCategory.message
                self.totalPage = _policyCategory.data?.total_page ?? 1
                self.currentPage += 1
                
                _policyCategory.data?.policy_category.forEach({ (item) in
                    self.listPolicyCategory.append(item)
                })
                
                self.labelKosong.isHidden = self.listPolicyCategory.count > 0
                self.collectionPolicyCategory.reloadData()
            }
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        collectionPolicyCategory.collectionViewLayout.invalidateLayout()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle { return .lightContent }
    
    private func initView() {
        year = function.getCurrentDate(pattern: "yyyy")
        checkTopMargin(viewRootTopMargin: constraintViewRoot)
        function.changeStatusBar(hexCode: 0x42a5f5, view: self.view, opacity: 1)
        
        let collectionLayout = collectionPolicyCategory.collectionViewLayout as! UICollectionViewFlowLayout
        collectionLayout.itemSize = CGSize(width: UIScreen.main.bounds.width - 32, height: 44)
        collectionPolicyCategory.register(UINib(nibName: "KebijakanPeraturanCell", bundle: nil), forCellWithReuseIdentifier: "KebijakanPeraturanCell")
        collectionPolicyCategory.delegate = self
        collectionPolicyCategory.dataSource = self
    }

}

extension KebijakanPeraturanController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.item == listPolicyCategory.count - 1 {
            if self.allowLoadMore && currentPage + 1 <= totalPage {
                self.getPolicyCategory()
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
        return listPolicyCategory.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "KebijakanPeraturanCell", for: indexPath) as! KebijakanPeraturanCell
        cell.data = listPolicyCategory[indexPath.item]
        cell.viewRoot.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(collectionViewRootClick(sender:))))
        return cell
    }
}

extension KebijakanPeraturanController: FilterKebijakanPeraturanProtocol {
    func yearsPick(year: String) {
        self.year = year
        currentPage = 0
        listPolicyCategory.removeAll()
        getPolicyCategory()
    }
    
    @objc func collectionViewRootClick(sender: UITapGestureRecognizer) {
        guard let indexpath = collectionPolicyCategory.indexPathForItem(at: sender.location(in: collectionPolicyCategory)) else { return }
        
        let vc = KebijakanPeraturanDetail()
        vc.titleString = listPolicyCategory[indexpath.item].name
        vc.policyCategoryId = listPolicyCategory[indexpath.item].id
        vc.previousSelectedYear = year
        self.navigationController?.pushViewController(vc, animated: true)
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
