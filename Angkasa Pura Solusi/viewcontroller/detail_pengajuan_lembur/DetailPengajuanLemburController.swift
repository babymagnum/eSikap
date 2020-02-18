//
//  DetailPengajuanLemburController.swift
//  Angkasa Pura Solusi
//
//  Created by Arief Zainuri on 27/01/20.
//  Copyright © 2020 Gama Techno. All rights reserved.
//

import UIKit
import SVProgressHUD
import EzPopup

class DetailPengajuanLemburController: BaseViewController {
    
    @IBOutlet weak var constraintViewRoot: NSLayoutConstraint!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var buttonStatus: CustomButton!
    @IBOutlet weak var labelNumber: CustomLabel!
    @IBOutlet weak var labelPengajuan: CustomLabel!
    @IBOutlet weak var imageProfile: UIImageView!
    @IBOutlet weak var labelNama: CustomLabel!
    @IBOutlet weak var labelUnitKerja: CustomLabel!
    @IBOutlet weak var collectionInformasiStatusHeight: NSLayoutConstraint!
    @IBOutlet weak var labelKeterangan: CustomLabel!
    @IBOutlet weak var collectionInformasiStatus: UICollectionView!
    @IBOutlet weak var collectionTanggalLembur: UICollectionView!
    @IBOutlet weak var collectionTanggalLemburHeight: NSLayoutConstraint!
    @IBOutlet weak var buttonBatalkan: CustomButton!
    @IBOutlet weak var labelInformasiPembatalan: CustomLabel!
    @IBOutlet weak var labelAwalInput: CustomLabel!
    @IBOutlet weak var labelUbahanTerakhir: CustomLabel!
    
    private var listTanggalLembur = [DetailOvertimeDataItemDates]()
    private var listInformasiStatus = [DetailOvertimeDataItemApproval]()
    
    var overtimeId: String?
    var isBackToHome: Bool?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initView()
        
        getDetailOvertime()
    }
    
    private func getDetailOvertime() {
        guard let _overtimeId = overtimeId else { return }
        SVProgressHUD.show()
        
        informationNetworking.getDetailOvertimeById(overtimeId: _overtimeId) { (error, detailOvertime, isExpired) in
            DispatchQueue.main.async {
                SVProgressHUD.dismiss()
                
                if let _ = isExpired {
                    self.forceLogout(self.navigationController!)
                    return
                }
                
                if let _error = error {
                    self.function.showUnderstandDialog(self, "Gagal Mendapatkan Data", _error, "Reload", "Cancel") {
                        self.getDetailOvertime()
                    }
                    return
                }
                
                guard let _detailOvertime = detailOvertime else { return }
                
                self.updateLayout(_detailOvertime.data?.overtime[0])
            }
        }
    }

    private func updateLayout(_ data: DetailOvertimeDataItem?) {
        guard let _data = data else { return }
        
        imageProfile.loadUrl(_data.photo ?? "")
        labelNumber.text = _data.number
        labelPengajuan.text = "Diajukan pada \(_data.date ?? "")"
        labelNama.text = ": \(_data.emp_name ?? "")"
        labelUnitKerja.text = ": \(_data.unit_name ?? "") "
        labelKeterangan.text = ": \(_data.reason ?? "")"
        buttonStatus.setTitle(_data.status, for: .normal)
        buttonStatus.backgroundColor = UIColor(hexString: "\(_data.status_color?.replacingOccurrences(of: "#", with: "") ?? "")")
        listTanggalLembur = _data.date_show
        listInformasiStatus = _data.approval
        buttonBatalkan.isHidden = _data.cancel_button_is_show == "0" ? true : false
        labelInformasiPembatalan.text = _data.cancel_button_is_show == "0" ? _data.cancel_notes : ""
        labelAwalInput.text = _data.last_insert
        labelUbahanTerakhir.text = _data.last_update
        collectionTanggalLembur.reloadData()
        collectionInformasiStatus.reloadData()
        
        scrollView.alpha = 1
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
            UIView.animate(withDuration: 0.2) {
                self.collectionTanggalLemburHeight.constant = self.collectionTanggalLembur.contentSize.height
                self.collectionInformasiStatusHeight.constant = self.collectionInformasiStatus.contentSize.height
                self.scrollView.resizeScrollViewContentSize()
                self.view.layoutIfNeeded()
            }
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle { return .lightContent }
    
    private func initView() {
        constraintViewRoot.constant += UIApplication.shared.statusBarFrame.height
        function.changeStatusBar(hexCode: 0x42a5f5, view: self.view, opacity: 1.0)
        
        scrollView.alpha = 0
        buttonStatus.layer.cornerRadius = buttonStatus.frame.height / 2
        buttonBatalkan.giveBorder(5, 1, "ea1c18")
        imageProfile.clipsToBounds = true
        imageProfile.layer.cornerRadius = (UIScreen.main.bounds.width * 0.16) / 2
        
        // register collectionview
        collectionTanggalLembur.register(UINib(nibName: "TanggalLemburCell", bundle: nil), forCellWithReuseIdentifier: "TanggalLemburCell")
        collectionTanggalLembur.delegate = self
        collectionTanggalLembur.dataSource = self
        
        collectionInformasiStatus.register(UINib(nibName: "StatusPengajuanLemburCell", bundle: nil), forCellWithReuseIdentifier: "StatusPengajuanLemburCell")
        collectionInformasiStatus.dataSource = self
        collectionInformasiStatus.delegate = self
    }
}

extension DetailPengajuanLemburController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == collectionInformasiStatus {
            
            let item = listInformasiStatus[indexPath.item]
            
            let statusDateHeight = item.status_date?.getHeight(withConstrainedWidth: UIScreen.main.bounds.width - 32, font_size: 7)
            let statusHeight = (item.status_name?.getHeight(withConstrainedWidth: UIScreen.main.bounds.width - 32, font_size: 7))!
            let imageHeight = ((UIScreen.main.bounds.width - 32) * 0.075)
            
            let fullHeight = imageHeight + 25 + statusHeight + statusDateHeight!
            let withoutDateHeight = imageHeight + 25 + statusHeight
            
            return CGSize(width: UIScreen.main.bounds.width - 32, height: item.status_date == "" ? withoutDateHeight : fullHeight)
        } else {
            return CGSize(width: UIScreen.main.bounds.width - 32, height: 91)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == collectionTanggalLembur {
            return listTanggalLembur.count
        } else {
            return listInformasiStatus.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == collectionTanggalLembur {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TanggalLemburCell", for: indexPath) as! TanggalLemburCell
            let item = listTanggalLembur[indexPath.item]
            cell.labelTanggalMulai.text = item.start
            cell.labelTanggalSelesai.text = item.end
            cell.labelStatus.text = item.status?.uppercased()
            if item.status == "Waiting" {
                cell.imageStatus.image = UIImage(named: "waiting")
            } else if item.status == "Approved" {
                cell.imageStatus.image = UIImage(named: "approved")
            } else if item.status == "Rejected" {
                cell.imageStatus.image = UIImage(named: "cancel")
            }
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "StatusPengajuanLemburCell", for: indexPath) as! StatusPengajuanLemburCell
            let item = listInformasiStatus[indexPath.item]
            cell.buttonNomor.setTitle("\(item.no ?? 1)", for: .normal)
            cell.labelDate.text = item.status_date
            cell.labelNama.text = item.emp_name
            cell.labelAlasan.text = item.status_notes ?? "-"
            cell.labelStatus.text = item.status_name
            if item.status_name == "Waiting" {
                cell.imageStatus.image = UIImage(named: "waiting")
            } else if item.status_name == "Approved" {
                cell.imageStatus.image = UIImage(named: "approved")
            } else if item.status_name == "Rejected" {
                cell.imageStatus.image = UIImage(named: "cancel")
            }
            return cell
        }
    }
}

extension DetailPengajuanLemburController: DialogBatalkanProtocol {
    func updateData() {
        getDetailOvertime()
    }
    
    @IBAction func buttonBatalkanClick(_ sender: Any) {
        guard let _overtimeId = overtimeId else { return }
        
        let dialogVc = DialogBatalkanCutiController()
        dialogVc.overtime_id = _overtimeId
        dialogVc.delegate = self
        let vc = PopupViewController(contentController: dialogVc, popupWidth: UIScreen.main.bounds.width, popupHeight: UIScreen.main.bounds.height)
        vc.shadowEnabled = false
        present(vc, animated: true)
    }
    
    @IBAction func buttonBackClick(_ sender: Any) {
        if let _ = isBackToHome {
            backToHome()
        } else {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    private func backToHome() {
        let transition = CATransition()
        transition.duration = 0.4
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromLeft
        self.navigationController?.view.layer.add(transition, forKey: kCATransition)
        self.navigationController?.pushViewController(HomeController(), animated: true)
    }
}
