//
//  DetailCutiController.swift
//  Angkasa Pura Solusi
//
//  Created by Arief Zainuri on 10/08/19.
//  Copyright © 2019 Gama Techno. All rights reserved.
//

import UIKit
import SVProgressHUD
import EzPopup

class DetailCutiController: BaseViewController, UICollectionViewDelegate {

    @IBOutlet weak var labelStatusTop: CustomButton!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var viewRootTopMargin: NSLayoutConstraint!
    @IBOutlet weak var labelKodeCuti: UILabel!
    @IBOutlet weak var labelDateSubmitted: UILabel!
    @IBOutlet weak var imageAccount: UIImageView!
    @IBOutlet weak var labelUnitKerja: UILabel!
    @IBOutlet weak var labelJenisIjin: UILabel!
    @IBOutlet weak var labelAlasan: UILabel!
    @IBOutlet weak var labelTanggal: UILabel!
    @IBOutlet weak var labelNama: UILabel!
    @IBOutlet weak var buttonBatalkan: CustomButton!
    @IBOutlet weak var statusPersetujuanCollectionView: UICollectionView!
    @IBOutlet weak var statusPersetujuanCollectionHeight: NSLayoutConstraint!
    @IBOutlet weak var labelAwalInput: UILabel!
    @IBOutlet weak var labelInfoPembatalan: CustomLabel!
    @IBOutlet weak var collectionTanggalCuti: UICollectionView!
    @IBOutlet weak var collectionTanggalCutiHeight: NSLayoutConstraint!
    @IBOutlet weak var labelUbahanTerakhir: CustomLabel!
    
    var listStatusPersetujuan = [ItemApproval]()
    var listTanggalCuti = [ItemDateShow]()
    var isCalculatePesertujuanHeight = false
    var isSetStatusPersetujuanHeight = false
    var isCalculateTanggalCutiHeight = false
    var isSetTanggalCutiHeight = false
    var cuti: ItemRiwayatCuti!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initView()
        
        initCollectionView()
        
        getDetailLeave()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle { return .lightContent }
    
    private func initView() {
        function.changeStatusBar(hexCode: 0x42a5f5, view: self.view, opacity: 1.0)
        
        labelStatusTop.layer.cornerRadius = labelStatusTop.frame.height / 2
        buttonBatalkan.layer.cornerRadius = 5
        imageAccount.clipsToBounds = true
        imageAccount.layer.cornerRadius = (UIScreen.main.bounds.width * 0.15) / 2
        
        scrollView.resizeScrollViewContentSize()
    }
    
    private func getDetailLeave() {
        SVProgressHUD.show()
        
        informationNetworking.getDetailLeaveById(id: cuti.id!) { (error, detailRiwayatCuti, isExpired) in
            SVProgressHUD.dismiss()
            
            if let _ = isExpired {
                self.forceLogout(self.navigationController!)
                return
            }
            
            if let error = error {
                self.function.showUnderstandDialog(self, "Gagal Mendapatkan Detail Cuti", error, "Reload", "Understand", completionHandler: {
                    self.getDetailLeave()
                })
                return
            }
            
            guard let detailRiwayatCuti = detailRiwayatCuti else { return }
            
            self.setViewContent(detailRiwayatCuti)
        }
    }
    
    private func setViewContent(_ detailRiwayatCuti: DetailRiwayatCuti) {
        let item = detailRiwayatCuti.data?.leave[0]
        
        if item?.cancel_button_is_show == "1" {
            buttonBatalkan.isHidden = false
            labelInfoPembatalan.text = ""
        } else {
            buttonBatalkan.isHidden = true
            labelInfoPembatalan.text = item?.cancel_notes
        }
        
        labelStatusTop.setTitle(item?.status, for: .normal)
        labelStatusTop.backgroundColor = UIColor(hexString: String((item?.status_color?.dropFirst())!))
        imageAccount.loadUrl((item?.photo)!)
        labelNama.text = ": \(item?.emp_name ?? "")"
        labelUnitKerja.text = ": \(item?.unit_name ?? "")"
        labelJenisIjin.text = ": \(item?.type_name ?? "")"
        labelAlasan.text = ": \(item?.reason ?? "")"
        labelTanggal.text = (item?.date_show.count)! > 0 ? ": -" : ": \(item?.dates ?? "")"
        labelInfoPembatalan.text = item?.cancel_notes
        labelAwalInput.text = item?.last_insert
        labelUbahanTerakhir.text = item?.last_update
        listTanggalCuti = item!.date_show
        listStatusPersetujuan = item!.approval
        
        DispatchQueue.main.async {
            self.collectionTanggalCuti.reloadData()
            self.statusPersetujuanCollectionView.reloadData()
        }
    }
    
    private func initCollectionView() {
        collectionTanggalCuti.register(UINib(nibName: "DetailTanggalCutiCell", bundle: nil), forCellWithReuseIdentifier: "DetailTanggalCutiCell")
        statusPersetujuanCollectionView.register(UINib(nibName: "StatusPersetujuanCell", bundle: nil), forCellWithReuseIdentifier: "StatusPersetujuanCell")
        
        statusPersetujuanCollectionView.delegate = self
        statusPersetujuanCollectionView.dataSource = self
        
        collectionTanggalCuti.delegate = self
        collectionTanggalCuti.dataSource = self
    }
    
}

extension DetailCutiController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == statusPersetujuanCollectionView {
            return listStatusPersetujuan.count
        } else {
            return listTanggalCuti.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == statusPersetujuanCollectionView {
            let statusPersetujuanCell = collectionView.dequeueReusableCell(withReuseIdentifier: "StatusPersetujuanCell", for: indexPath) as! StatusPersetujuanCell
            
            statusPersetujuanCell.data = listStatusPersetujuan[indexPath.item]
            
            if !isCalculatePesertujuanHeight {
                self.isCalculatePesertujuanHeight = true
                DispatchQueue.main.async {
                    let statusPersetujuanLayout = self.statusPersetujuanCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
                    let statusPersetujuanHeight = ((UIScreen.main.bounds.width - 28) * 0.075) + 5.3 + 2.7 + 5.2 + statusPersetujuanCell.labelStatus.getHeight(width: statusPersetujuanCell.labelStatus.frame.width)
                    statusPersetujuanLayout.itemSize = CGSize(width: UIScreen.main.bounds.width - 28, height: statusPersetujuanHeight)
                }
            }
            
            if indexPath.item == listStatusPersetujuan.count - 1 {
                if !self.isSetStatusPersetujuanHeight {
                    self.isSetStatusPersetujuanHeight = true
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                        self.statusPersetujuanCollectionHeight.constant = self.statusPersetujuanCollectionView.contentSize.height
                        self.scrollView.resizeScrollViewContentSize()
                    }
                }
            }
            
            return statusPersetujuanCell
        } else {
            let tanggalCutiCell = collectionView.dequeueReusableCell(withReuseIdentifier: "DetailTanggalCutiCell", for: indexPath) as! DetailTanggalCutiCell
            tanggalCutiCell.data = listTanggalCuti[indexPath.item]
            
            if !isCalculateTanggalCutiHeight {
                self.isCalculateTanggalCutiHeight = true
                DispatchQueue.main.async {
                    let tanggalCutiLayout = self.collectionTanggalCuti.collectionViewLayout as! UICollectionViewFlowLayout
                    tanggalCutiLayout.itemSize = CGSize(width: self.collectionTanggalCuti.frame.width, height: tanggalCutiCell.viewContainer.getHeight())
                }
            }
            
            if indexPath.item == listTanggalCuti.count - 1 {
                if !self.isSetTanggalCutiHeight {
                    self.isSetTanggalCutiHeight = true
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                        self.collectionTanggalCutiHeight.constant = self.collectionTanggalCuti.contentSize.height
                        self.scrollView.resizeScrollViewContentSize()
                    }
                }
            }
            
            return tanggalCutiCell
        }
        
    }
}

extension DetailCutiController: DialogBatalkanProtocol {
    func updateData() {
        getDetailLeave()
    }
    
    @IBAction func buttonBatalkanClick(_ sender: Any) {
        let controller = DialogBatalkanCutiController()
        controller.cuti = cuti
        controller.delegate = self
        let vc = PopupViewController(contentController: controller, popupWidth: UIScreen.main.bounds.width - 44, popupHeight: UIScreen.main.bounds.height * 0.4)
        vc.cornerRadius = 5
        present(vc, animated: true)
    }
    
    @IBAction func buttonBackClick(_ sender: Any) { navigationController?.popViewController(animated: true) }
}
