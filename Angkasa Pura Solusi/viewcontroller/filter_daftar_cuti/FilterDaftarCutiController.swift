//
//  FilterDaftarCutiController.swift
//  Angkasa Pura Solusi
//
//  Created by Arief Zainuri on 01/02/20.
//  Copyright © 2020 Gama Techno. All rights reserved.
//

import UIKit
import SVProgressHUD
import FittedSheets

protocol FilterDaftarCutiProtocol {
    func updateData(nama: String, startDate: String, endDate: String, typeCuti: String, status: String)
}

class FilterDaftarCutiController: BaseViewController {

    @IBOutlet weak var constraintViewRoot: NSLayoutConstraint!
    @IBOutlet weak var viewNama: UIView!
    @IBOutlet weak var fieldNama: CustomTextField!
    @IBOutlet weak var viewTanggalMulai: UIView!
    @IBOutlet weak var fieldTanggalMulai: CustomTextField!
    @IBOutlet weak var viewTanggalSelesai: UIView!
    @IBOutlet weak var fieldTanggalSelesai: CustomTextField!
    @IBOutlet weak var viewJenisCuti: UIView!
    @IBOutlet weak var fieldJenisCuti: CustomDropDownField!
    @IBOutlet weak var viewStatus: UIView!
    @IBOutlet weak var fieldStatus: CustomDropDownField!
    @IBOutlet weak var buttonReset: CustomButton!
    @IBOutlet weak var buttonTerapkan: CustomButton!
    
    private var listStatus = [ItemLeaveStatusFilter]()
    private var listType = [ItemLeaveTypeFilter]()
    private var startDate = ""
    private var endDate = ""
    private var type = ""
    private var status = ""
    private var isPickTanggalMulai = false
    
    var delegate: FilterDaftarCutiProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initView()
        
        getLeaveType()
        
        getLeaveStatus()
        
        initEvent()
    }
    
    private func getLeaveType() {
        SVProgressHUD.show()
        
        informationNetworking.getLeaveTypeFilter { (error, leaveType, isExpired) in
            SVProgressHUD.dismiss()
            
            if let _ = isExpired {
                self.forceLogout(self.navigationController!)
                return
            }
            
            if let _ = error {
                self.getLeaveType()
                return
            }
            
            guard let _leaveType = leaveType else { return }
            
            self.listType = _leaveType.data
            
            self.listType.forEach { (item) in
                self.fieldJenisCuti.optionArray.append(item.name ?? "")
            }
            
            self.fieldJenisCuti.text = self.listType[0].name
            
            self.fieldJenisCuti.didSelect { (text, index, _) in
                self.type = self.listType[index].id ?? ""
            }
        }
    }
    
    private func getLeaveStatus() {
        SVProgressHUD.show()
        
        informationNetworking.getLeaveStatusFilter { (error, leaveStatus, isExpired) in
            SVProgressHUD.dismiss()
            
            if let _ = isExpired {
                self.forceLogout(self.navigationController!)
                return
            }
            
            if let _ = error {
                self.getLeaveType()
                return
            }
            
            guard let _leaveStatus = leaveStatus else { return }
            
            self.listStatus = _leaveStatus.data
            
            self.listStatus.forEach { (item) in
                self.fieldStatus.optionArray.append(item.leavestatus_name ?? "")
            }
            
            self.fieldStatus.text = self.listStatus[0].leavestatus_name
            
            self.fieldStatus.didSelect { (text, index, _) in
                self.status = self.listStatus[index].leavestatus_id ?? ""
            }
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle { return .lightContent }
    
    private func initEvent() {
        viewTanggalMulai.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(viewTanggalMulaiClick)))
        
        viewTanggalSelesai.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(viewTanggalSelesaiClick)))
    }
    
    private func initView() {
        function.changeStatusBar(hexCode: 0x42a5f5, view: self.view, opacity: 1.0)
        checkTopMargin(viewRootTopMargin: constraintViewRoot)
        viewNama.giveBorder(3, 1, "dedede")
        viewTanggalMulai.giveBorder(3, 1, "dedede")
        viewTanggalSelesai.giveBorder(3, 1, "dedede")
        viewJenisCuti.giveBorder(3, 1, "dedede")
        viewStatus.giveBorder(3, 1, "dedede")
        buttonReset.giveBorder(38 / 2, 1, "42a5f5")
        buttonTerapkan.giveBorder(38 / 2, 0, "dedede")
    }

}

extension FilterDaftarCutiController: BottomSheetDatePickerProtocol {
    func pickDate(formatedDate: String) {
        if isPickTanggalMulai {
            fieldTanggalMulai.text = formatedDate
            startDate = function.dateStringTo(date: formatedDate, original: "dd-MM-yyyy", toFormat: "yyyy-MM-dd")
        } else {
            fieldTanggalSelesai.text = formatedDate
            endDate = function.dateStringTo(date: formatedDate, original: "dd-MM-yyyy", toFormat: "yyyy-MM-dd")
        }
    }
    
    func pickTime(pickedTime: String) {
        // do nothing
    }
    
    @IBAction func buttonBackClick(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func buttonTerapkanClick(_ sender: Any) {
        guard let _delegate = delegate else { return }
        
        _delegate.updateData(nama: fieldNama.text?.trim() ?? "", startDate: startDate, endDate: endDate, typeCuti: type, status: status)
        
        print("\(fieldNama.text?.trim() ?? ""), \(startDate), \(endDate), \(type), \(status)")
        
        self.navigationController?.popViewController(animated: true)
    }
    
    private func openDateTimePicker(_ picker: PickerTypeEnum) {
        let vc = BottomSheetDatePicker()
        vc.delegate = self
        vc.picker = picker
        vc.isBackDate = true
        present(SheetViewController(controller: vc), animated: false, completion: nil)
    }
    
    @IBAction func buttonResetClick(_ sender: Any) {
        guard let _delegate = delegate else { return }
        
        _delegate.updateData(nama: "", startDate: "", endDate: "", typeCuti: "", status: "")
        
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func viewTanggalMulaiClick() {
        isPickTanggalMulai = true
        openDateTimePicker(PickerTypeEnum.date)
    }
    
    @objc func viewTanggalSelesaiClick() {
        isPickTanggalMulai = false
        openDateTimePicker(PickerTypeEnum.date)
    }
}
