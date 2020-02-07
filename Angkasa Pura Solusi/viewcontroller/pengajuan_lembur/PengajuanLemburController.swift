//
//  PengajuanLemburController.swift
//  Angkasa Pura Solusi
//
//  Created by Arief Zainuri on 26/01/20.
//  Copyright © 2020 Gama Techno. All rights reserved.
//

import UIKit
import FittedSheets
import Toast_Swift
import SVProgressHUD

struct WaktuPengajuanLemburModel {
    var tanggalWaktuMulai: String
    var tanggalWaktuSelesai: String
}

class PengajuanLemburController: BaseViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var labelPegawai: CustomLabel!
    @IBOutlet weak var buttonUnitKerja: CustomButton!
    @IBOutlet weak var viewTanggalMulai: UIView!
    @IBOutlet weak var fieldTanggalMulai: CustomTextField!
    @IBOutlet weak var viewTanggalSelesai: UIView!
    @IBOutlet weak var fieldTanggalSelesai: CustomTextField!
    @IBOutlet weak var viewWaktuMulai: UIView!
    @IBOutlet weak var fieldWaktuMulai: CustomTextField!
    @IBOutlet weak var viewWaktuSelesai: UIView!
    @IBOutlet weak var fieldWaktuSelesai: CustomTextField!
    @IBOutlet weak var imageTambahkan: UIImageView!
    @IBOutlet weak var collectionWaktu: UICollectionView!
    @IBOutlet weak var collectionWaktuHeight: NSLayoutConstraint!
    @IBOutlet weak var viewKeterangan: UIView!
    @IBOutlet weak var textviewKeterangan: CustomTextView!
    @IBOutlet weak var viewPemberiPersetujuan: UIView!
    @IBOutlet weak var fieldPemberiPersetujuan: CustomDropDownField!
    @IBOutlet weak var buttonSimpan: UIButton!
    @IBOutlet weak var buttonSubmit: UIButton!
    
    private var listWaktu = [WaktuPengajuanLemburModel]()
    private var datetimes_start = [String]()
    private var datetimes_end = [String]()
    private var isPickTanggalMulai = false
    private var isPickWaktuMulai = false
    private var selectedPemberiPersetujuan = ""
    
    var overtimeId: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initView()
        
        initEvent()
        
        getProfile()
        
        if let _overtimeId = overtimeId {
            getEditDetailOvertime(_overtimeId)
        }
    }
    
    private func getEditDetailOvertime(_ overtimeId: String) {
        SVProgressHUD.show()
        
        informationNetworking.getEditDetailOvertimeById(overtimeId: overtimeId) { (error, editDetail, isExpired) in
            SVProgressHUD.dismiss()
            
            if let _ = isExpired {
                self.forceLogout(self.navigationController!)
                return
            }
            
            if let _error = error {
                self.function.showUnderstandDialog(self, "Gagal Mendapatkan Data Overtime", _error, "Reload", "Cancel", completionHandler: {
                    self.getEditDetailOvertime(overtimeId)
                })
                return
            }
            
            guard let _editDetail = editDetail?.data else { return }
            
            self.textviewKeterangan.text = _editDetail.reason
            
            for index in 0..._editDetail.datetimes_start.count - 1 {
                self.listWaktu.append(WaktuPengajuanLemburModel(tanggalWaktuMulai: _editDetail.datetimes_start[index], tanggalWaktuSelesai: _editDetail.datetimes_end[index]))
            }
            
            self.collectionWaktu.reloadData()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                UIView.animate(withDuration: 0.2) {
                    self.collectionWaktuHeight.constant = self.collectionWaktu.contentSize.height
                    self.scrollView.resizeScrollViewContentSize()
                    self.view.layoutIfNeeded()
                }
            }
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        collectionWaktu.collectionViewLayout.invalidateLayout()
    }
    
    private func initEvent() {
        imageTambahkan.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(imageTambahkanClick)))
        viewTanggalMulai.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(viewTanggalMulaiClick)))
        viewTanggalSelesai.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(viewTanggalSelesaiClick)))
        viewWaktuMulai.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(viewWaktuMulaiClick)))
        viewWaktuSelesai.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(viewWaktuSelesaiClick)))
        viewPemberiPersetujuan.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(viewPemberiPersetujuanClick)))
    }
    
    private func getProfile() {
        SVProgressHUD.show()
        
        informationNetworking.getProfile { (error, itemProfile, isExpired) in
            SVProgressHUD.dismiss()
            
            if let _ = isExpired {
                self.forceLogout(self.navigationController!)
                return
            }
            
            if let error = error {
                self.function.showUnderstandDialog(self, "Gagal Mendapatkan Data Profile", error, "Reload", "Cancel", completionHandler: {
                    self.getProfile()
                })
                return
            }
            
            guard let _itemProfile = itemProfile else { return }
            
            self.labelPegawai.text = _itemProfile.emp_name
            self.buttonUnitKerja.setTitle(_itemProfile.unit, for: .normal)
            UIView.animate(withDuration: 0.2) {
                self.scrollView.alpha = 1
            }
        }
    }

    private func initView() {
        scrollView.alpha = 0
        function.changeStatusBar(hexCode: 0x42A5F5, view: self.view, opacity: 1)
        buttonUnitKerja.giveBorder(3, 1, "dedede")
        viewTanggalMulai.giveBorder(3, 1, "dedede")
        viewTanggalSelesai.giveBorder(3, 1, "dedede")
        viewWaktuMulai.giveBorder(3, 1, "dedede")
        viewWaktuSelesai.giveBorder(3, 1, "dedede")
        viewKeterangan.giveBorder(3, 1, "dedede")
        viewPemberiPersetujuan.giveBorder(3, 1, "dedede")
        buttonSimpan.giveBorder(5, 0, "dedede")
        buttonSubmit.giveBorder(5, 0, "dedede")
        
        collectionWaktuHeight.constant = 0
        scrollView.resizeScrollViewContentSize()
        self.view.layoutIfNeeded()
        
        collectionWaktu.register(UINib(nibName: "WaktuPengajuanLemburCell", bundle: nil), forCellWithReuseIdentifier: "WaktuPengajuanLemburCell")
        collectionWaktu.delegate = self
        collectionWaktu.dataSource = self
        
        let collectionLayout = collectionWaktu.collectionViewLayout as! UICollectionViewFlowLayout
        collectionLayout.itemSize = CGSize(width: UIScreen.main.bounds.width - 32, height: 91)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle { return .lightContent }
}

extension PengajuanLemburController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return listWaktu.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WaktuPengajuanLemburCell", for: indexPath) as! WaktuPengajuanLemburCell
        cell.labelMulai.text = listWaktu[indexPath.item].tanggalWaktuMulai
        cell.labelSelesai.text = listWaktu[indexPath.item].tanggalWaktuSelesai
        cell.imageDelete.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(imageDeleteClick(sender:))))
        return cell
    }
}

extension PengajuanLemburController: BottomSheetDatePickerProtocol, SearchDelegasiOrAtasanProtocol {
    func addOvertime(postType: String) {
        
        if listWaktu.count == 0 {
            self.view.makeToast("Tanggal dan waktu lembur masih kosong.")
        } else if selectedPemberiPersetujuan == "" {
            self.view.makeToast("Pemberi persetujuan masih kosong.")
        } else {
            var body: [String: String] = [
                "reason": textviewKeterangan.text.trim(),
                "supervisor_emp_id": selectedPemberiPersetujuan,
                "post_type": postType,
                "overtime_id": overtimeId ?? ""
            ]
            
            for (index, item) in listWaktu.enumerated() {
                let tanggalMulaiWaktu = item.tanggalWaktuMulai.components(separatedBy: " ")
                let tanggalSelesaiWaktu = item.tanggalWaktuSelesai.components(separatedBy: " ")
                let tanggalMulai = function.dateStringTo(date: tanggalMulaiWaktu[0], original: "dd-MM-yyyy", toFormat: "yyyy-MM-dd")
                let tanggalSelesai = function.dateStringTo(date: tanggalSelesaiWaktu[0], original: "dd-MM-yyyy", toFormat: "yyyy-MM-dd")
                body.updateValue("\(tanggalMulai) \(tanggalMulaiWaktu[1])", forKey: "datetimes_start[\(index)]")
                body.updateValue("\(tanggalSelesai) \(tanggalSelesaiWaktu[1])", forKey: "datetimes_end[\(index)]")
            }
            
            SVProgressHUD.show()
            
            informationNetworking.addOvertime(body: body) { (error, success, isExpired) in
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
                        self.function.showUnderstandDialog(self, "Gagal Melakukan Pengajuan Lembur", _error, "Cancel")
                    }
                    return
                }
                
                guard let _success = success else { return }
                
                self.view.makeToast(_success.message, duration: 1)
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    let vc = TabRiwayatController()
                    vc.afterAddLeave = true
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
        }
    }
    
    func namePicked(itemEmp: ItemEmp, type: String) {
        fieldPemberiPersetujuan.text = itemEmp.emp_name
        selectedPemberiPersetujuan = itemEmp.emp_id ?? ""
    }
    
    func pickDate(formatedDate: String) {
        if isPickTanggalMulai {
            fieldTanggalMulai.text = formatedDate
        } else {
            fieldTanggalSelesai.text = formatedDate
        }
    }
    
    func pickTime(pickedTime: String) {
        if isPickWaktuMulai {
            fieldWaktuMulai.text = pickedTime
        } else {
            fieldWaktuSelesai.text = pickedTime
        }
    }
    
    private func openDateTimePicker(_ picker: PickerTypeEnum) {
        let vc = BottomSheetDatePicker()
        vc.delegate = self
        vc.picker = picker
        vc.isBackDate = false
        present(SheetViewController(controller: vc), animated: false, completion: nil)
    }
    
    @objc func viewPemberiPersetujuanClick() {
        let vc = SearchDelegasiOrAtasanController()
        vc.type = "Cari Pemberi Persetujuan"
        vc.delegate = self
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func imageTambahkanClick() {
        if fieldTanggalMulai.text?.trim() == "" {
            self.view.makeToast("Tanggal mulai tidak boleh kosong.")
        } else if fieldTanggalSelesai.text?.trim() == "" {
            self.view.makeToast("Tanggal selesai tidak boleh kosong.")
        } else if fieldWaktuMulai.text?.trim() == "" {
            self.view.makeToast("Waktu mulai tidak boleh kosong.")
        } else if fieldWaktuSelesai.text?.trim() == "" {
            self.view.makeToast("Waktu selesai tidak boleh kosong.")
        } else {
            let tanggalWaktuMulai = "\(fieldTanggalMulai.text ?? "") \(fieldWaktuMulai.text ?? "")"
            let tanggalWaktuSelesai = "\(fieldTanggalSelesai.text ?? "") \(fieldWaktuSelesai.text ?? "")"
            
            if listWaktu.contains(where: {($0.tanggalWaktuMulai == tanggalWaktuMulai && $0.tanggalWaktuSelesai == tanggalWaktuSelesai)}){
                self.view.makeToast("Anda sudah memilih waktu ini.")
                return
            }
            
            fieldTanggalMulai.text = ""
            fieldTanggalSelesai.text = ""
            fieldWaktuMulai.text = ""
            fieldWaktuSelesai.text = ""
            listWaktu.append(WaktuPengajuanLemburModel(tanggalWaktuMulai: tanggalWaktuMulai, tanggalWaktuSelesai: tanggalWaktuSelesai))
            collectionWaktu.reloadData()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                UIView.animate(withDuration: 0.2) {
                    self.collectionWaktuHeight.constant = self.collectionWaktu.contentSize.height
                    self.scrollView.resizeScrollViewContentSize()
                    self.view.layoutIfNeeded()
                }
            }
        }
    }
    
    @objc func viewWaktuSelesaiClick() {
        isPickWaktuMulai = false
        openDateTimePicker(PickerTypeEnum.time)
    }
    
    @objc func viewWaktuMulaiClick() {
        isPickWaktuMulai = true
        openDateTimePicker(PickerTypeEnum.time)
    }
    
    @objc func viewTanggalMulaiClick() {
        isPickTanggalMulai = true
        openDateTimePicker(PickerTypeEnum.date)
    }
    
    @objc func viewTanggalSelesaiClick() {
        isPickTanggalMulai = false
        openDateTimePicker(PickerTypeEnum.date)
    }
    
    @objc func imageDeleteClick(sender: UITapGestureRecognizer) {
        guard let indexpath = collectionWaktu.indexPathForItem(at: sender.location(in: collectionWaktu)) else { return }
        
        listWaktu.remove(at: indexpath.item)
        collectionWaktu.deleteItems(at: [indexpath])
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
            UIView.animate(withDuration: 0.2) {
                self.collectionWaktuHeight.constant = self.collectionWaktu.contentSize.height
                self.scrollView.resizeScrollViewContentSize()
                self.view.layoutIfNeeded()
            }
        }
    }
    
    @IBAction func buttonHistory(_ sender: Any) {
        self.navigationController?.pushViewController(TabRiwayatController(), animated: true)
    }
    
    @IBAction func buttonBackClick(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func buttonSimpan(_ sender: Any) {
        addOvertime(postType: "save")
    }
    
    @IBAction func buttonSubmit(_ sender: Any) {
        addOvertime(postType: "submit")
    }
}
