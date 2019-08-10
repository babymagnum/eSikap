//
//  DetailPersetujuanCutiController.swift
//  Angkasa Pura Solusi
//
//  Created by Arief Zainuri on 10/08/19.
//  Copyright © 2019 Gama Techno. All rights reserved.
//

import UIKit

class DetailPersetujuanCutiController: BaseViewController, UICollectionViewDelegate {

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
    
    var listStatusPersetujuan = [StatusPersetujuan]()
    var listStatusAction = [StatusAction]()
    
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
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            UIView.animate(withDuration: 0.2, animations: {
                self.statusActionCollectionHeight.constant = self.statusActionCollectionView.contentSize.height
                self.viewRootHeight.constant += self.statusActionCollectionView.contentSize.height
                self.view.layoutIfNeeded()
            })
        }
    }
    
    private func getStatusPersetujuan() {
        listStatusPersetujuan.append(StatusPersetujuan(index: "1", nama: "Wayan Wijaya", type: "Pengaju", status: "Submited"))
        listStatusPersetujuan.append(StatusPersetujuan(index: "2", nama: "RIYAN TRISNA WIBOWO", type: "-", status: "On Progress"))
        listStatusPersetujuan.append(StatusPersetujuan(index: "3", nama: "A. TOTO PRIYONO", type: "-", status: "Approved"))
        listStatusPersetujuan.append(StatusPersetujuan(index: "4", nama: "FEBRIANA PUTRI KUSUMA", type: "-", status: "Submited"))
        
        statusPersetujuanCollectionView.reloadData()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            UIView.animate(withDuration: 0.2, animations: {
                self.statusPersetujuanCollectionHeight.constant = self.statusPersetujuanCollectionView.contentSize.height
                self.viewRootHeight.constant += self.statusPersetujuanCollectionView.contentSize.height
                self.view.layoutIfNeeded()
            })
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle { return .lightContent }
    
    private func initCollectionView() {
        statusPersetujuanCollectionView.register(UINib(nibName: "StatusPersetujuanCell", bundle: nil), forCellWithReuseIdentifier: "StatusPersetujuanCell")
        
        statusActionCollectionView.register(UINib(nibName: "StatusActionCell", bundle: nil), forCellWithReuseIdentifier: "StatusActionCell")
        
        let statusPersetujuanCell = statusPersetujuanCollectionView.dequeueReusableCell(withReuseIdentifier: "StatusPersetujuanCell", for: IndexPath(item: 0, section: 0)) as! StatusPersetujuanCell
        let statusPersetujuanLayout = statusPersetujuanCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
        statusPersetujuanLayout.itemSize = CGSize(width: UIScreen.main.bounds.width - 28, height: statusPersetujuanCell.viewContainer.frame.height)
        
        let statusActionCell = statusActionCollectionView.dequeueReusableCell(withReuseIdentifier: "StatusActionCell", for: IndexPath(item: 0, section: 0)) as! StatusActionCell
        let statusActionLayout = statusActionCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
        statusActionLayout.itemSize = CGSize(width: UIScreen.main.bounds.width - 28, height: statusActionCell.viewContainer.frame.height)
        
        statusPersetujuanCollectionView.delegate = self
        statusPersetujuanCollectionView.dataSource = self
        
        statusActionCollectionView.delegate = self
        statusActionCollectionView.dataSource = self
    }
    
    private func initView() {
        viewImage.giveBorder(3, 1, "dedede")
        imageAccount.clipsToBounds = true
        imageAccount.layer.cornerRadius = 3
        viewFieldCatatan.giveBorder(3, 1, "dedede")
        
        viewRootHeight.constant -= statusPersetujuanCollectionHeight.constant + statusActionCollectionHeight.constant
        
        statusPersetujuanCollectionHeight.constant = 0
        statusActionCollectionHeight.constant = 0
        
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
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "StatusPersetujuanCell", for: indexPath) as! StatusPersetujuanCell
            cell.data = listStatusPersetujuan[indexPath.item]
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "StatusActionCell", for: indexPath) as! StatusActionCell
            cell.data = listStatusAction[indexPath.item]
            return cell
        }
    }
}

extension DetailPersetujuanCutiController {
    @IBAction func buttonBackClick(_ sender: Any) { navigationController?.popViewController(animated: true) }
    
    @IBAction func buttonProsesClick(_ sender: Any) { navigationController?.popViewController(animated: true) }
}
