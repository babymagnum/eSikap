//
//  DetailPersetujuanRealisasiLemburController.swift
//  Angkasa Pura Solusi
//
//  Created by Arief Zainuri on 31/01/20.
//  Copyright © 2020 Gama Techno. All rights reserved.
//

import UIKit
import SVProgressHUD
import Toast_Swift

class DetailPersetujuanRealisasiLemburController: BaseViewController {

    @IBOutlet weak var constraintViewRoot: NSLayoutConstraint!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var buttonStatus: CustomButton!
    @IBOutlet weak var labelNumber: CustomLabel!
    @IBOutlet weak var labelDate: CustomLabel!
    @IBOutlet weak var imageProfile: UIImageView!
    @IBOutlet weak var labelNama: CustomLabel!
    @IBOutlet weak var labelUnitKerja: CustomLabel!
    @IBOutlet weak var labelKeterangan: CustomLabel!
    @IBOutlet weak var collectionTanggalLembur: UICollectionView!
    @IBOutlet weak var collectionTanggalLemburHeight: NSLayoutConstraint!
    @IBOutlet weak var labelApprove: CustomLabel!
    @IBOutlet weak var switchApprove: UISwitch!
    @IBOutlet weak var viewCatatanStatus: UIView!
    @IBOutlet weak var textviewCatatanStatus: CustomTextView!
    @IBOutlet weak var buttonProses: CustomButton!
    
    private var datetime_id = [String]()
    private var datetimes_start = [String]()
    private var datetimes_start_show = [String]()
    private var datetimes_end = [String]()
    private var datetimes_end_show = [String]()
    private var datetimes_real_start = [String]()
    private var datetimes_real_end = [String]()
    
    var overtimeId: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initView()
        
        initEvent()
        
        getDetailApproval()
    }
    
    private func initView() {
        scrollView.alpha = 0
        constraintViewRoot.constant += UIApplication.shared.statusBarFrame.height
        imageProfile.giveBorder(UIScreen.main.bounds.width * 0.16 / 2, 0, "fff")
        function.changeStatusBar(hexCode: 0x42a5f5, view: self.view, opacity: 1)
        buttonStatus.giveBorder(17 / 2, 0, "fff")
        buttonProses.giveBorder(5, 0, "fff")
        viewCatatanStatus.giveBorder(3, 1, "dedede")
        collectionTanggalLembur.register(UINib(nibName: "TanggalLemburRealisasiCell", bundle: nil), forCellWithReuseIdentifier: "TanggalLemburRealisasiCell")
        collectionTanggalLembur.delegate = self
        collectionTanggalLembur.dataSource = self
        let collectionLayout = collectionTanggalLembur.collectionViewLayout as! UICollectionViewFlowLayout
        collectionLayout.itemSize = CGSize(width: UIScreen.main.bounds.width - 32, height: 324)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle { return .lightContent }
    
    private func initEvent() {
        switchApprove.addTarget(self, action: #selector(switchChanged), for: UIControl.Event.valueChanged)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        collectionTanggalLembur.collectionViewLayout.invalidateLayout()
    }

    private func getDetailApproval() {
        guard let _overtimeId = overtimeId else { return }
        
        SVProgressHUD.show()
        
        informationNetworking.getDetailOvertimeRealizationApprovalById(overtimeId: _overtimeId) { (error, detailApproval, isExpired) in
            SVProgressHUD.dismiss()
            
            if let _ = isExpired {
                self.forceLogout(self.navigationController!)
                return
            }
            
            if let _error = error {
                self.function.showUnderstandDialog(self, "Gagal Mendapatkan Data", _error, "Reload", "Cancel") {
                    self.getDetailApproval()
                }
                return
            }
            
            guard let _data = detailApproval?.data else { return }
            
            self.textviewCatatanStatus.text = _data.real_status_notes
            self.imageProfile.loadUrl(_data.photo ?? "")
            self.buttonStatus.setTitle(_data.real_status, for: .normal)
            self.buttonStatus.backgroundColor = UIColor(hexString: _data.real_status_color?.replacingOccurrences(of: "#", with: "") ?? "#")
            self.labelNumber.text = _data.number
            self.labelDate.text = "Diajkukan pada \(_data.date ?? "")"
            self.labelNama.text = ": \(_data.emp_name ?? "")"
            self.labelUnitKerja.text = ": \(_data.unit_name ?? "")"
            self.labelKeterangan.text = ": \(_data.real_reason ?? "")"
            self.datetime_id = _data.datetime_id
            self.datetimes_start = _data.datetimes_start
            self.datetimes_start_show = _data.datetimes_start_show
            self.datetimes_end = _data.datetimes_end
            self.datetimes_end_show = _data.datetimes_end_show
            self.datetimes_real_start = _data.datetimes_real_start
            self.datetimes_real_end = _data.datetimes_real_end
            
            self.collectionTanggalLembur.reloadData()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                UIView.animate(withDuration: 0.2) {
                    self.collectionTanggalLemburHeight.constant = self.collectionTanggalLembur.contentSize.height
                    self.scrollView.resizeScrollViewContentSize()
                    self.view.layoutIfNeeded()
                    self.scrollView.alpha = 1
                }
            }
        }
    }
}

extension DetailPersetujuanRealisasiLemburController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return datetime_id.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TanggalLemburRealisasiCell", for: indexPath) as! TanggalLemburRealisasiCell
        cell.labelMulaiPermintaan.text = datetimes_start_show[indexPath.item]
        cell.labelSelesaiPermintaan.text = datetimes_end_show[indexPath.item]
        let tanggalWaktuMulai = datetimes_real_start[indexPath.item].components(separatedBy: " ")
        let tanggalWaktuSelesai = datetimes_real_end[indexPath.item].components(separatedBy: " ")
        cell.fieldTanggalMulai.text = function.dateStringTo(date: tanggalWaktuMulai[0], original: "yyyy-MM-dd", toFormat: "dd-MM-yyyy")
        cell.fieldWaktuMulai.text = tanggalWaktuMulai[1]
        cell.fieldTanggalSelesai.text = function.dateStringTo(date: tanggalWaktuSelesai[0], original: "yyyy-MM-dd", toFormat: "dd-MM-yyyy")
        cell.fieldWaktuSelesai.text = tanggalWaktuSelesai[1]
        return cell
    }
}

extension DetailPersetujuanRealisasiLemburController {
    @objc func switchChanged(mySwitch: UISwitch) {
        let value = mySwitch.isOn
        
        labelApprove.text = value ? "APPROVED" : "REJECTED"
        
    }
    
    @IBAction func buttonProsesClick(_ sender: Any) {
        approvalOvertime()
    }
    
    @IBAction func buttonBackClick(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    private func approvalOvertime() {
        guard let _overtimeId = overtimeId else { return }
        
        var body: [String: String] = [
            "overtime_id": _overtimeId,
            "approval_notes": textviewCatatanStatus.text.trim(),
            "status": switchApprove.isOn ? "1" : "0"
        ]
        
        for (index, item) in datetime_id.enumerated() {
            body.updateValue(item, forKey: "datetimes_id[\(index)]")
            body.updateValue(datetimes_real_start[index], forKey: "datetimes_start_real[\(index)]")
            body.updateValue(datetimes_real_end[index], forKey: "datetimes_end_real[\(index)]")
        }
        
        SVProgressHUD.show()
        
        informationNetworking.approvalOvertimeRealization(body: body) { (error, success, isExpired) in
            SVProgressHUD.dismiss()
            
            if let _ = isExpired {
                self.forceLogout(self.navigationController!)
                return
            }
            
            if let _error = error {
                if _error.contains("</ul>") || _error.contains("</li>") || _error.contains("</span>") {
                    let vc = DialogPengajuanCutiController()
                    vc.exception = _error
                    self.showCustomDialog(vc)
                } else {
                    self.function.showUnderstandDialog(self, "Gagal Melakukan Persetujuan Realisasi Lembur", _error, "Ulangi", "Cancel") {
                        self.approvalOvertime()
                    }
                }
                return
            }
            
            guard let _success = success else { return }
            
            self.view.makeToast(_success.message)
            
            self.getDetailApproval()
        }
    }
}
