//
//  DetailPersetujuanCutiController.swift
//  Angkasa Pura Solusi
//
//  Created by Arief Zainuri on 10/08/19.
//  Copyright © 2019 Gama Techno. All rights reserved.
//

import UIKit

class DetailPersetujuanCutiController: BaseViewController, UICollectionViewDelegate {

    @IBOutlet weak var viewRootTopMargin: NSLayoutConstraint!
    @IBOutlet weak var labelKodeCuti: UILabel!
    @IBOutlet weak var labelDateSubmitted: UILabel!
    @IBOutlet weak var viewImage: UIView!
    @IBOutlet weak var imageAccount: UIImageView!
    @IBOutlet weak var labelUnitKerja: UILabel!
    @IBOutlet weak var labelJenisIjin: UILabel!
    @IBOutlet weak var labelAlasan: UILabel!
    @IBOutlet weak var labelTanggal: UILabel!
    @IBOutlet weak var labelNama: UILabel!
    @IBOutlet weak var statusPersetujuanCollectionView: UICollectionView!
    @IBOutlet weak var statusPersetujuanCollectionHeight: NSLayoutConstraint!
    @IBOutlet weak var switchStatusAction: UISwitch!
    @IBOutlet weak var labelStatusAction: UILabel!
    @IBOutlet weak var statusActionCollectionView: UICollectionView!
    @IBOutlet weak var statusActionCollectionHeight: NSLayoutConstraint!
    @IBOutlet weak var viewFieldCatatan: UIView!
    @IBOutlet weak var fieldCatatan: UITextView!
    @IBOutlet weak var buttonProses: UIButton!
    @IBOutlet weak var viewRootHeight: NSLayoutConstraint!
    
    var listStatusPersetujuan = [ItemApproval]()
    var listStatusAction = [StatusAction]()
    var isCalculateStatusAction = false
    var isCalculateStatusPersetujuan = false
    var isSetStatusActionHeight = false
    var isSetStatusPersetujuanHeight = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        function.changeStatusBar(hexCode: 0x42a5f5, view: self.view, opacity: 1)
        
        initView()
        
        initCollectionView()
        
        getStatusPersetujuan()
        
        getStatusAction()
    }
    
    private func getStatusAction() {
        listStatusAction.append(StatusAction(date: "31-05-2019", isApproved: true))
        listStatusAction.append(StatusAction(date: "01-06-2019", isApproved: false))
        listStatusAction.append(StatusAction(date: "02-06-2019", isApproved: false))
        
        statusActionCollectionView.reloadData()
    }
    
    private func getStatusPersetujuan() {
        
        statusPersetujuanCollectionView.reloadData()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle { return .lightContent }
    
    private func initCollectionView() {
        statusPersetujuanCollectionView.register(UINib(nibName: "StatusPersetujuanCell", bundle: nil), forCellWithReuseIdentifier: "StatusPersetujuanCell")
        
        statusActionCollectionView.register(UINib(nibName: "StatusActionCell", bundle: nil), forCellWithReuseIdentifier: "StatusActionCell")
        
        statusPersetujuanCollectionView.delegate = self
        statusPersetujuanCollectionView.dataSource = self
        
        statusActionCollectionView.delegate = self
        statusActionCollectionView.dataSource = self
    }
    
    private func initView() {
        checkTopMargin(viewRootTopMargin: viewRootTopMargin)
        checkRootHeight(viewRootHeight: viewRootHeight, 15, addHeightFor11Above: true, addHeightFor11Below: false)
        
        viewImage.giveBorder(3, 1, "dedede")
        imageAccount.clipsToBounds = true
        imageAccount.layer.cornerRadius = 3
        viewFieldCatatan.giveBorder(3, 1, "dedede")
        
        viewRootHeight.constant -= statusPersetujuanCollectionHeight.constant + statusActionCollectionHeight.constant
        
        buttonProses.layer.cornerRadius = 5
    }

}

extension DetailPersetujuanCutiController : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == statusPersetujuanCollectionView {
            return listStatusPersetujuan.count
        } else {
            return listStatusAction.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == statusPersetujuanCollectionView {
            let statusPersetujuanCell = collectionView.dequeueReusableCell(withReuseIdentifier: "StatusPersetujuanCell", for: indexPath) as! StatusPersetujuanCell
            
            statusPersetujuanCell.data = listStatusPersetujuan[indexPath.item]
            
            if !isCalculateStatusPersetujuan {
                self.isCalculateStatusPersetujuan = true
                DispatchQueue.main.async {
                    let statusPersetujuanHeight = ((UIScreen.main.bounds.width - 28) * 0.075) + 5.3 + 2.7 + 5.2 + statusPersetujuanCell.labelStatus.getHeight(width: statusPersetujuanCell.labelStatus.frame.width)
                    let statusPersetujuanLayout = self.statusPersetujuanCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
                    statusPersetujuanLayout.itemSize = CGSize(width: UIScreen.main.bounds.width - 28, height: statusPersetujuanHeight)
                }
            }
            
            if indexPath.item == listStatusPersetujuan.count - 1 {
                if !self.isSetStatusPersetujuanHeight {
                    self.isSetStatusPersetujuanHeight = true
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                        UIView.animate(withDuration: 0.2, animations: {
                            self.statusPersetujuanCollectionHeight.constant = self.statusPersetujuanCollectionView.contentSize.height
                            self.viewRootHeight.constant += self.statusPersetujuanCollectionView.contentSize.height
                            self.view.layoutIfNeeded()
                        })
                    }
                }
            }
            
            return statusPersetujuanCell
        } else {
            let statusActionCell = collectionView.dequeueReusableCell(withReuseIdentifier: "StatusActionCell", for: indexPath) as! StatusActionCell
            
            statusActionCell.data = listStatusAction[indexPath.item]
            
            if !isCalculateStatusAction {
                self.isCalculateStatusAction = true
                DispatchQueue.main.async {
                    let statusActionLayout = self.statusActionCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
                    statusActionLayout.itemSize = CGSize(width: UIScreen.main.bounds.width - 28, height: statusActionCell.viewContainer.frame.height)
                }
            }
            
            if indexPath.item == listStatusAction.count - 1 {
                if !self.isSetStatusActionHeight {
                    self.isSetStatusActionHeight = true
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                        self.statusActionCollectionHeight.constant = self.statusActionCollectionView.contentSize.height
                        self.viewRootHeight.constant += self.statusActionCollectionView.contentSize.height
                    }
                }
            }
            
            return statusActionCell
        }
    }
}

extension DetailPersetujuanCutiController {
    @IBAction func buttonBackClick(_ sender: Any) { navigationController?.popViewController(animated: true) }
    
    @IBAction func buttonProsesClick(_ sender: Any) { navigationController?.popViewController(animated: true) }
}
