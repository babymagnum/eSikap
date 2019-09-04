//
//  PengajuanCutiController.swift
//  Angkasa Pura Solusi
//
//  Created by Arief Zainuri on 05/08/19.
//  Copyright © 2019 Gama Techno. All rights reserved.
//

import UIKit
import iOSDropDown
import SVProgressHUD
import FittedSheets

enum DatePickerEnum {
    case date
    case dateStart
    case dateEnd
    case timeStart
    case timeEnd
}

class PengajuanCutiController: BaseViewController, UICollectionViewDelegate, UITextFieldDelegate {

    //outlet root
    @IBOutlet weak var imageAtasan: UIImageView!
    @IBOutlet weak var imageDelegasi: UIImageView!
    @IBOutlet weak var imageFile: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var viewRootTopMargin: NSLayoutConstraint!
    @IBOutlet weak var labelNama: UILabel!
    @IBOutlet weak var labelUnit: UIButton!
    @IBOutlet weak var fieldJenisCuti: DropDown!
    @IBOutlet weak var viewJenisCuti: UIView!
    @IBOutlet weak var viewAlasan: UIView!
    @IBOutlet weak var fieldAlasan: CustomTextView!
    @IBOutlet weak var viewDelegasi: UIView!
    @IBOutlet weak var fieldDelegasi: CustomDropDownField!
    @IBOutlet weak var viewAtasan: UIView!
    @IBOutlet weak var fieldAtasan: CustomDropDownField!
    @IBOutlet weak var buttonSimpan: UIButton!
    @IBOutlet weak var buttonSubmit: UIButton!
    @IBOutlet weak var labelMaksimalCuti: CustomLabel!
    @IBOutlet weak var labelMaksimalCutiHeight: NSLayoutConstraint!
    
    //view jatah cuti
    @IBOutlet weak var viewJatahCuti: UIView!
    @IBOutlet weak var viewJatahCutiHeight: NSLayoutConstraint!
    @IBOutlet weak var jatahCutiCollectionView: UICollectionView!
    @IBOutlet weak var jatahCutiCollectionHeight: NSLayoutConstraint!
    
    //view tanggal cuti picked
    @IBOutlet weak var viewTanggalCutiPicked: UIView!
    @IBOutlet weak var viewTanggalPickedHeight: NSLayoutConstraint!
    @IBOutlet weak var tanggalCutiCollectionView: UICollectionView!
    @IBOutlet weak var tanggalCutiCollectionHeight: NSLayoutConstraint!
    
    //view pick tanggal
    @IBOutlet weak var viewRootPickTanggal: UIView!
    @IBOutlet weak var viewPickTanggalHeight: NSLayoutConstraint!
    @IBOutlet weak var viewPickTanggal: UIView!
    @IBOutlet weak var fieldPickTanggal: CustomTextField!
    
    //view rentang tanggal
    @IBOutlet weak var viewRentangTanggal: UIView!
    @IBOutlet weak var viewRentangTanggalHeight: NSLayoutConstraint!
    @IBOutlet weak var viewRentangTanggalAwal: UIView!
    @IBOutlet weak var viewRentangTanggalAkhir: UIView!
    @IBOutlet weak var fieldRentangTanggalAwal: CustomTextField!
    @IBOutlet weak var fieldRentangTanggalAkhir: CustomTextField!
    
    //view lampirkan file
    @IBOutlet weak var viewRootLampirkanFile: UIView!
    @IBOutlet weak var viewLampirkanHeight: NSLayoutConstraint!
    @IBOutlet weak var viewLampirkanFile: UIView!
    
    //view rentang waktu
    @IBOutlet weak var viewRangeWaktu: UIView!
    @IBOutlet weak var viewRentangWaktuHeight: NSLayoutConstraint!
    @IBOutlet weak var viewRentangWaktuAkhir: UIView!
    @IBOutlet weak var viewRentangWaktuAwal: UIView!
    @IBOutlet weak var fieldRentangWaktuAwal: CustomTextField!
    @IBOutlet weak var fieldRentangWaktuAkhir: CustomTextField!
    
    private var datePicker: DatePickerEnum!
    private var defaultJatahCutiHeight: CGFloat = 0
    private var defaultPickTanggalHeight: CGFloat = 0
    private var defaultRentangTanggalHeight: CGFloat = 0
    private var defaultLampirkanHeight: CGFloat = 0
    private var defaultRentangWaktuHeight: CGFloat = 0
    private var defaultTanggalPickedHeight: CGFloat = 0
    private var defaultLabelMaksimalCutiHeight: CGFloat = 0
    private var isDay = ""
    private var isRange = ""
    private var leave_type_id = ""
    private var delegation_emp_id = ""
    private var supervisor_emp_id = ""
    private var idPilih = 99999999
    
    private var listLeaveType = [ItemType]()
    private var listJatahCuti = [ItemQuota]()
    private var listTanggalCuti = [TanggalCuti]()
    private var isCalculateTanggalCutiHeight = false
    private var isCalculateJatahCutiHeight = false
    private var isSetJatahCutiHeight = false
    private var isSetTanggalCutiHeight = false
    private var isBackDate = true
    private var isTanggalCutiVisible = false
    
    var leave_id: String?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        defaultJatahCutiHeight = viewJatahCuti.getHeight() - jatahCutiCollectionHeight.constant + 100
        defaultPickTanggalHeight = 150
        defaultRentangTanggalHeight = viewRentangTanggal.getHeight() + 100
        defaultLampirkanHeight = viewRootLampirkanFile.getHeight() + 100
        defaultRentangWaktuHeight = viewRangeWaktu.getHeight() + 100
        defaultTanggalPickedHeight = 0
        defaultLabelMaksimalCutiHeight = (labelMaksimalCuti.text?.height(withConstrainedWidth: labelMaksimalCuti.frame.width, font: UIFont(name: labelMaksimalCuti.font.fontName, size: labelMaksimalCuti.font.pointSize)!))!
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initView()
        
        initEvent()
        
        initCollectionView()
        
        dropdownListener()
        
        getProfile()
        
        if let leave_id = leave_id {
            self.getEditDetailLeaveById(id: leave_id)
        } else {
            getLeaveType()
        }
    }
    
    private func getEditDetailLeaveById(id: String) {
        SVProgressHUD.show()
        
        informationNetworking.getEditDetailLeaveById(id: id) { (error, detailLeaveById, isExpired) in
            SVProgressHUD.dismiss()
            
            if let _ = isExpired {
                self.forceLogout(self.navigationController!)
                return
            }
            
            if let error = error {
                self.function.showUnderstandDialog(self, "Gagal Mendapatkan Data Edit Cuti", error, "Reload", "Cancel", completionHandler: {
                    self.getEditDetailLeaveById(id: id)
                })
                return
            }
            
            guard let detailLeave = detailLeaveById else { return }
            
            self.setViewContent(detailLeave)
        }
    }
    
    private func setViewContent(_ detailLeave: DetailLeaveById) {
        let item = detailLeave.data
        
        if (item?.dates.count)! > 0 {
            self.isTanggalCutiVisible = true
            
            for date in item!.dates {
                self.listTanggalCuti.append(TanggalCuti(tanggal: date))
            }
            
            self.tanggalCutiCollectionView.reloadData()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                self.tanggalCutiCollectionHeight.constant = self.tanggalCutiCollectionView.contentSize.height
                self.viewTanggalPickedHeight.constant = self.tanggalCutiCollectionHeight.constant
                self.scrollView.resizeScrollViewContentSize()
            }
        }
        
        leave_type_id = (item?.type_id)!
        fieldAlasan.text = item?.reason
        fieldRentangWaktuAwal.text = item?.start_time
        fieldRentangWaktuAkhir.text = item?.end_time
        fieldRentangTanggalAwal.text = item?.leave_start
        fieldRentangTanggalAkhir.text = item?.leave_end
        fieldPickTanggal.text = item?.date?.components(separatedBy: " ")[0]
        if item?.url_file != "" { imageFile.loadUrl((item?.url_file)!) }
        
        getLeaveType()
    }
    
    private func initEvent() {
        imageDelegasi.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(imageDelegasiClick)))
        
        imageAtasan.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(imageAtasanClick)))
        
        imageFile.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(imageFileClick)))
        
        viewPickTanggal.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(viewPickTanggalClick)))
        
        viewRentangTanggalAwal.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(viewRentangTanggalAwalClick)))
        
        viewRentangTanggalAkhir.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(viewRentangTanggalAkhirClick)))
        
        viewRentangWaktuAwal.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(viewRentangWaktuAwalClick)))
        
        viewRentangWaktuAkhir.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(viewRentangWaktuAkhirClick)))
        
        viewDelegasi.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(viewDelegasiClick)))
        
        viewAtasan.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(viewAtasanClick)))
    }
    
    private func getLeaveType() {
        SVProgressHUD.show()
        
        perizinanNetworking.getLeaveType { (error, leaveType, isExpired) in
            SVProgressHUD.dismiss()
            
            if let _ = isExpired {
                self.forceLogout(self.navigationController!)
                return
            }
            
            if let error = error {
                self.function.showUnderstandDialog(self, "Gagal Mendapatkan Tipe Cuti", error, "Reload", "Cancel", completionHandler: {
                    self.getLeaveType()
                })
                return
            }
            
            guard let leaveType = leaveType else { return }
            
            self.listLeaveType = leaveType.data
            var listName = [String]()
            var listId = [Int]()
            
            for (index, type) in leaveType.data.enumerated() {
                
                if self.leave_type_id != "" && type.id == self.leave_type_id {
                    self.checkSelectedLeaveType(type, index)
                }
                
                listName.append(type.name ?? "")
                
                if index == 0 {
                    listId.append(self.idPilih)
                } else {
                    listId.append(Int(type.id!)!)
                }
            }
            
            self.fieldJenisCuti.optionArray = listName
            self.fieldJenisCuti.optionIds = listId
        }
    }
    
    private func getProfile() {
        informationNetworking.getProfile { (error, itemProfile, isExpired) in
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
            
            guard let itemProfile = itemProfile else { return }
            
            self.setProfileView(item: itemProfile)
        }
    }
    
    private func setProfileView(item: ItemProfile) {
        labelNama.text = item.emp_name
        labelUnit.setTitle(item.unit, for: .normal)
    }
    
    private func getLeaveQuota() {
        SVProgressHUD.show()
        
        perizinanNetworking.getLeaveQuota { (error, leaveQuota, isExpired) in
            SVProgressHUD.dismiss()
            
            if let _ = isExpired {
                self.forceLogout(self.navigationController!)
                return
            }
            
            if let error = error {
                self.function.showUnderstandDialog(self, "Error", error, "Reload", "Cancel", completionHandler: {
                    self.getLeaveQuota()
                })
                return
            }
            
            guard let leaveQuota = leaveQuota else { return }
            
            self.listJatahCuti = leaveQuota.data
            
            self.jatahCutiCollectionView.reloadData()
            
            if !self.isSetJatahCutiHeight {
                self.isSetJatahCutiHeight = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                    self.jatahCutiCollectionHeight.constant = self.jatahCutiCollectionView.contentSize.height
                    self.defaultJatahCutiHeight = self.defaultJatahCutiHeight + self.jatahCutiCollectionView.contentSize.height
                    self.showJatahCuti()
                }
            }
        }
    }
    
    private func initCollectionView() {
        jatahCutiCollectionView.register(UINib(nibName: "JatahCutiCell", bundle: nil), forCellWithReuseIdentifier: "JatahCutiCell")
        tanggalCutiCollectionView.register(UINib(nibName: "TanggalCutiCell", bundle: nil), forCellWithReuseIdentifier: "TanggalCutiCell")
        
        // set delegate
        tanggalCutiCollectionView.delegate = self
        jatahCutiCollectionView.delegate = self
        
        // set datasource
        tanggalCutiCollectionView.dataSource = self
        jatahCutiCollectionView.dataSource = self
    }
    
    private func hideLabelMaksimalCuti() {
        labelMaksimalCutiHeight.constant = 0
        scrollView.resizeScrollViewContentSize()
    }
    
    private func showLabelMaksimalCuti() {
        labelMaksimalCutiHeight.constant = defaultLabelMaksimalCutiHeight
        scrollView.resizeScrollViewContentSize()
    }
    
    private func resetPengajuanCuti() {
        hideLabelMaksimalCuti()
        hidePickTanggal()
        hideJatahCuti()
        hideRentangTanggal()
        hideLampirkan()
        hideRentangWaktu()
        hideTanggalPicked()
    }
    
    private func dropdownListener() {
        fieldDelegasi.didSelect { (text, index, id) in
            self.delegation_emp_id = String(id)
            self.fieldDelegasi.text = text
        }
        
        fieldAtasan.didSelect { (text, index, id) in
            self.supervisor_emp_id = String(id)
            self.fieldAtasan.text = text
        }
        
        fieldJenisCuti.didSelect { (text, index, id) in
            let selectedLeaveType = self.listLeaveType[index]
            
            self.listTanggalCuti.removeAll()
            self.tanggalCutiCollectionHeight.constant = 0
            self.fieldPickTanggal.text = ""
            
            self.checkSelectedLeaveType(selectedLeaveType, index)
        }
    }
    
    private func checkSelectedLeaveType(_ selectedItem: ItemType, _ index: Int) {
        if index == 0 && fieldJenisCuti.trim() == "" {
            return
        } else if index == 0 {
            self.resetPengajuanCuti()
            return
        }
        
        labelMaksimalCuti.text = "Maksimal Cuti: \(selectedItem.days_count ?? "") Hari"
        
        leave_type_id = String(selectedItem.id!)
        isRange = selectedItem.is_range!
        isDay = selectedItem.is_day!
        fieldJenisCuti.text = selectedItem.name
        
        showPickTanggal()
        
        if selectedItem.is_day == "0" {
            self.showRentangWaktu()
            self.hideTanggalPicked()
        }
        
        if selectedItem.is_range == "0" && selectedItem.is_day == "1" {
            self.isTanggalCutiVisible = true
            self.showTanggalPicked()
            self.hideRentangTanggal()
            self.hideRentangWaktu()
        } else if selectedItem.is_range == "1" && selectedItem.is_day == "1" {
            self.isTanggalCutiVisible = false
            self.showRentangTanggal()
            self.hidePickTanggal()
            self.hideTanggalPicked()
            self.hideRentangWaktu()
        } else {
            self.hideRentangTanggal()
        }
        
        if selectedItem.days_count != "0" { self.showLabelMaksimalCuti() } else { self.hideLabelMaksimalCuti() }
        
        if selectedItem.is_reduced == "1" {
            if !self.isSetJatahCutiHeight {
                self.getLeaveQuota()
            }
            
            self.showJatahCuti()
        } else {
            self.hideJatahCuti()
        }
        
        if selectedItem.is_backdated == "0" { self.isBackDate = false } else { self.isBackDate = true }
        
        if selectedItem.is_lampiran == "1" { self.showLampirkan() } else { self.hideLampirkan() }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle { return .lightContent }
    
    private func initView() {
        function.changeStatusBar(hexCode: 0x42a5f5, view: self.view, opacity: 1.0)
        checkTopMargin(viewRootTopMargin: viewRootTopMargin)
        
        fieldJenisCuti.delegate = self
        labelUnit.layer.cornerRadius = 5
        viewJenisCuti.giveBorder(3, 1, "dedede")
        viewAlasan.giveBorder(3, 1, "dedede")
        viewDelegasi.giveBorder(3, 1, "dedede")
        viewAtasan.giveBorder(3, 1, "dedede")
        buttonSimpan.layer.cornerRadius = 5
        buttonSubmit.layer.cornerRadius = 5
        viewPickTanggal.giveBorder(3, 1, "dedede")
        viewRentangTanggalAwal.giveBorder(3, 1, "dedede")
        viewRentangTanggalAkhir.giveBorder(3, 1, "dedede")
        viewLampirkanFile.giveBorder(3, 1, "dedede")
        viewRentangWaktuAwal.giveBorder(3, 1, "dedede")
        viewRentangWaktuAkhir.giveBorder(3, 1, "dedede")
        
        resetPengajuanCuti()
    }
    
    private func showView(_ viewRootHeight: NSLayoutConstraint, _ viewRoot: UIView, _ height: CGFloat) {
        UIView.animate(withDuration: 0.2) {
            viewRootHeight.constant = height
            self.scrollView.resizeScrollViewContentSize()
            viewRoot.isHidden = false
            self.view.layoutIfNeeded()
        }
    }
    
    private func hideView(_ viewRootHeight: NSLayoutConstraint, _ viewRoot: UIView) {
        UIView.animate(withDuration: 0.2) {
            viewRootHeight.constant = 0
            self.scrollView.resizeScrollViewContentSize()
            viewRoot.isHidden = true
            self.view.layoutIfNeeded()
        }
    }

}

//function show hide hidden view
extension PengajuanCutiController {
    private func showPickTanggal() { showView(viewPickTanggalHeight, viewRootPickTanggal, defaultPickTanggalHeight) }
    
    private func hidePickTanggal() { hideView(viewPickTanggalHeight, viewRootPickTanggal) }
    
    private func showJatahCuti() { showView(viewJatahCutiHeight, viewJatahCuti, defaultJatahCutiHeight) }
    
    private func hideJatahCuti() { hideView(viewJatahCutiHeight, viewJatahCuti) }
    
    private func showRentangTanggal() { showView(viewRentangTanggalHeight, viewRentangTanggal, defaultRentangTanggalHeight) }
    
    private func hideRentangTanggal() { hideView(viewRentangTanggalHeight, viewRentangTanggal) }
    
    private func showLampirkan() { showView(viewLampirkanHeight, viewRootLampirkanFile, defaultLampirkanHeight) }
    
    private func hideLampirkan() { hideView(viewLampirkanHeight, viewRootLampirkanFile) }
    
    private func showRentangWaktu() { showView(viewRentangWaktuHeight, viewRangeWaktu, defaultRentangWaktuHeight) }
    
    private func hideRentangWaktu() { hideView(viewRentangWaktuHeight, viewRangeWaktu) }
    
    private func showTanggalPicked() { showView(viewTanggalPickedHeight, viewTanggalCutiPicked, defaultTanggalPickedHeight) }
    
    private func hideTanggalPicked() { hideView(viewTanggalPickedHeight, viewTanggalCutiPicked) }
}

//date picker protocol
extension PengajuanCutiController: BottomSheetDatePickerProtocol {
    func pickDate(pickedDate: String) {
        print("picked date \(pickedDate)")
        switch datePicker {
            case .date?:
                fieldPickTanggal.text = pickedDate
            
                if self.isTanggalCutiVisible {
                    listTanggalCuti.append(TanggalCuti(tanggal: pickedDate))
                    self.tanggalCutiCollectionView.reloadData()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                        self.tanggalCutiCollectionHeight.constant = self.tanggalCutiCollectionView.contentSize.height
                        self.viewTanggalPickedHeight.constant = self.tanggalCutiCollectionHeight.constant
                        self.scrollView.resizeScrollViewContentSize()
                    }
                }
            
            case .dateStart?: fieldRentangTanggalAwal.text = pickedDate
            case .dateEnd?: fieldRentangTanggalAkhir.text = pickedDate
            default: break
        }
    }
    
    func pickTime(pickedTime: String) {
        print("picked time \(pickedTime)")
        switch datePicker {
            case .timeStart?: fieldRentangWaktuAwal.text = pickedTime
            case .timeEnd?: fieldRentangWaktuAkhir.text = pickedTime
            default: break
        }
    }
}

//click event
extension PengajuanCutiController: SearchDelegasiOrAtasanProtocol {
    func namePicked(itemEmp: ItemEmp, type: String) {
        if type == "Delegasi" {
            imageDelegasi.image = UIImage(named: "group489")
            fieldDelegasi.text = itemEmp.emp_name
            delegation_emp_id = itemEmp.emp_id!
        } else {
            imageAtasan.image = UIImage(named: "group489")
            fieldAtasan.text = itemEmp.emp_name
            supervisor_emp_id = itemEmp.emp_id!
        }
    }
    
    private func openDateTimePicker(_ datePicker: DatePickerEnum, _ picker: PickerTypeEnum) {
        self.datePicker = datePicker
        let vc = BottomSheetDatePicker()
        vc.delegate = self
        vc.picker = picker
        vc.isBackDate = isBackDate
        present(SheetViewController(controller: vc), animated: false, completion: nil)
    }
    
    private func addLeaveRequest(body: [String: String]) {
        let imageData = imageFile.image?.jpegData(compressionQuality: 0.5)
        
        SVProgressHUD.show()
        informationNetworking.postLeaveRequest(imageData: imageData!, body: body) { (error, message, isExpired) in
            SVProgressHUD.dismiss()
            
            if let _ = isExpired {
                self.forceLogout(self.navigationController!)
                return
            }
            
            if let error = error {
                if error.contains("</ul>") || error.contains("</li>") || error.contains("</span>") {
                    let vc = DialogPengajuanCutiController()
                    vc.exception = error
                    self.showCustomDialog(vc)
                } else {
                    self.function.showUnderstandDialog(self, "Error", error, "Mengerti")
                }
                return
            }
            
            let vc = RiwayatCutiController()
            vc.isFromAddLeaveRequest = true
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    private func getRequestBody(post_type: String) -> [String: String] {
        var body: [String: String] = [
            "leave_type_id": self.leave_type_id,
            "reason": self.fieldAlasan.text!,
            "delegation_emp_id": self.delegation_emp_id,
            "supervisor_emp_id": self.supervisor_emp_id,
            "post_type": post_type,
            "leave_id": "",
            "attachment_old": ""
        ]
        
        if isDay == "0" && isRange == "0" {
            body.updateValue(self.fieldPickTanggal.text!, forKey: "date")
            body.updateValue(self.fieldRentangWaktuAwal.text!, forKey: "time_start")
            body.updateValue(self.fieldRentangWaktuAkhir.text!, forKey: "time_end")
            print(body)
            return body
        }
        else if isDay == "1" && isRange == "0" {
            for (index, date) in self.listTanggalCuti.enumerated() {
                body.updateValue(date.tanggal!, forKey: "dates[\(index)]")
            }
            print(body)
            return body
        }
        else {
            body.updateValue(self.fieldRentangTanggalAwal.text!, forKey: "range_start")
            body.updateValue(self.fieldRentangTanggalAkhir.text!, forKey: "range_end")
            print(body)
            return body
        }
    }
    
    @objc func imageDelegasiClick() {
        delegation_emp_id = ""
        fieldDelegasi.text = ""
        imageDelegasi.image = UIImage(named: "icSearchWhite")
    }
    
    @objc func imageAtasanClick() {
        supervisor_emp_id = ""
        fieldAtasan.text = ""
        imageAtasan.image = UIImage(named: "icSearchWhite")
    }
    
    @objc func imageFileClick() {
        imagePicker.pickImage(self) { (image) in
            self.imageFile.image = image
        }
    }
    
    @objc func viewDelegasiClick() {
        let vc = SearchDelegasiOrAtasanController()
        vc.type = "Delegasi"
        vc.delegate = self
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func viewAtasanClick() {
        let vc = SearchDelegasiOrAtasanController()
        vc.type = "Atasan"
        vc.delegate = self
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func viewPickTanggalClick() { openDateTimePicker(.date, .date) }
    
    @objc func viewRentangTanggalAwalClick() { openDateTimePicker(.dateStart, .date) }
    
    @objc func viewRentangTanggalAkhirClick() { openDateTimePicker(.dateEnd, .date) }
    
    @objc func viewRentangWaktuAwalClick() { openDateTimePicker(.timeStart, .time) }
    
    @objc func viewRentangWaktuAkhirClick() { openDateTimePicker(.timeEnd, .time) }
    
    @IBAction func buttonRiwayatCutiClick(_ sender: Any) {
        navigationController?.pushViewController(RiwayatCutiController(), animated: true)
    }
    
    @IBAction func buttonSubmitClick(_ sender: Any) {
        if leave_type_id == "" {
            self.function.showUnderstandDialog(self, "Anda Belum Menentukan Tipe Cuti", "", "Mengerti") {
                self.scrollView.scrollTo(y: self.fieldJenisCuti.frame.origin.y)
            }
            return
        }
        
        addLeaveRequest(body: getRequestBody(post_type: "submit"))
    }
    
    @IBAction func buttonSimpanClick(_ sender: Any) {
        if leave_type_id == "" {
            self.function.showUnderstandDialog(self, "Anda Belum Menentukan Tipe Cuti", "", "Mengerti") {
                self.scrollView.scrollTo(y: self.fieldJenisCuti.frame.origin.y)
            }
            return
        }
        
        addLeaveRequest(body: getRequestBody(post_type: "save"))
    }
    
    @IBAction func buttonBackClick(_ sender: Any) { navigationController?.popViewController(animated: true) }
    
    @objc func deleteTanggalClick(sender: UITapGestureRecognizer) {
        guard let indexpath = tanggalCutiCollectionView.indexPathForItem(at: sender.location(in: tanggalCutiCollectionView)) else { return }
        
        listTanggalCuti.remove(at: indexpath.item)
        tanggalCutiCollectionView.reloadData()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            UIView.animate(withDuration: 0.2, animations: {
                if self.listTanggalCuti.count > 0 {
                    self.tanggalCutiCollectionHeight.constant = self.tanggalCutiCollectionView.contentSize.height
                    self.viewTanggalPickedHeight.constant = self.tanggalCutiCollectionHeight.constant
                } else {
                    self.viewTanggalPickedHeight.constant = 0
                }
                self.scrollView.resizeScrollViewContentSize()
            })
        }
    }
}

//collectionview
extension PengajuanCutiController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == jatahCutiCollectionView {
            return listJatahCuti.count
        } else {
            return listTanggalCuti.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == jatahCutiCollectionView {
            let jatahCutiCell = collectionView.dequeueReusableCell(withReuseIdentifier: "JatahCutiCell", for: indexPath) as! JatahCutiCell
            
            if !isCalculateJatahCutiHeight {
                self.isCalculateJatahCutiHeight = true
                DispatchQueue.main.async {
                    let jatahCutiLayout = self.jatahCutiCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
                    jatahCutiLayout.itemSize = CGSize(width: UIScreen.main.bounds.width - 28, height: jatahCutiCell.viewContainer.getHeight() + 12) // 12 is bottom constraint
                }
            }
            
            jatahCutiCell.data = listJatahCuti[indexPath.item]
            return jatahCutiCell
        } else {
            let tanggalCutiCell = collectionView.dequeueReusableCell(withReuseIdentifier: "TanggalCutiCell", for: indexPath) as! TanggalCutiCell
            
            if !isCalculateTanggalCutiHeight {
                self.isCalculateTanggalCutiHeight = true
                DispatchQueue.main.async {
                    let tanggalCutiHeight = ((UIScreen.main.bounds.width - 28) * 0.09) + 6.7
                    let tanggalCutiLayout = self.tanggalCutiCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
                    tanggalCutiLayout.itemSize = CGSize(width: UIScreen.main.bounds.width - 28, height: tanggalCutiHeight)
                }
            }
            
            tanggalCutiCell.data = listTanggalCuti[indexPath.item].tanggal
            tanggalCutiCell.buttonDeleteTanggal.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(deleteTanggalClick(sender:))))
            return tanggalCutiCell
        }
    }
}

extension PengajuanCutiController {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == fieldJenisCuti {
            return false
        }
        return true
    }
}
