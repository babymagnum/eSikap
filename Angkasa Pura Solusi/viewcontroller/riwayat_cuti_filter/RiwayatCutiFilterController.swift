//
//  RiwayatCutiController.swift
//  Angkasa Pura Solusi
//
//  Created by Arief Zainuri on 03/09/19.
//  Copyright © 2019 Gama Techno. All rights reserved.
//

import UIKit
import iOSDropDown
import SVProgressHUD

protocol RiwayatCutiFilterProtocol {
    func filter(tahun: String, jenisCuti: String, status: String)
}

class RiwayatCutiFilterController: BaseViewController, UITextFieldDelegate {

    @IBOutlet weak var viewRootTopMargin: NSLayoutConstraint!
    @IBOutlet weak var viewTahun: UIView!
    @IBOutlet weak var viewJenisCuti: UIView!
    @IBOutlet weak var viewStatus: UIView!
    @IBOutlet weak var buttonTerapkan: CustomButton!
    @IBOutlet weak var buttonReset: CustomButton!
    @IBOutlet weak var fieldTahun: CustomDropDownField!
    @IBOutlet weak var fieldJenisCuti: CustomDropDownField!
    @IBOutlet weak var fieldStatus: CustomDropDownField!
    
    private var selectedTahun = ""
    private var selectedJenisCuti = ""
    private var selectedStatus = ""
    private let defaultIds = 128718927
    
    var delegate: RiwayatCutiFilterProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initView()
        
        getLeaveTypeFilter()
        
        getYearsFilter()
        
        getLeaveStatusFilter()
    }
    
    private func getLeaveStatusFilter() {
        SVProgressHUD.show()
        
        informationNetworking.getLeaveStatusFilter { (error, leaveStatusFilter, isExpired) in
            DispatchQueue.main.async {
                SVProgressHUD.dismiss()
                
                if let _ = isExpired {
                    self.forceLogout(self.navigationController!)
                    return
                }
                
                if let error = error {
                    self.function.showUnderstandDialog(self, "Gagal Mendapatkan Data Filter", error, "Reload", "Cancel", completionHandler: {
                        self.getYearsFilter()
                        self.getLeaveTypeFilter()
                        self.getLeaveStatusFilter()
                    })
                    return
                }
                
                guard let leaveStatusFilter = leaveStatusFilter else { return }
                
                var nameArray = [String]()
                var idArray = [Int]()
                
                for (index, leaveStatus) in leaveStatusFilter.data.enumerated() {
                    nameArray.append(leaveStatus.leavestatus_name!)
                    
                    if index == 0 {
                        idArray.append(self.defaultIds)
                    } else {
                        idArray.append(Int(leaveStatus.leavestatus_id!)!)
                    }
                }
                
                self.fieldStatus.optionArray = nameArray
                self.fieldStatus.optionIds = idArray
                
                self.fieldStatus.didSelect(completion: { (text, index, id) in
                    self.selectedStatus = "\(id)"
                    self.fieldStatus.text = text
                })
            }
        }
    }
    
    private func getYearsFilter() {
        SVProgressHUD.show()
        
        informationNetworking.getYearsFilter { (error, yearsFilter, isExpired) in
            DispatchQueue.main.async {
                SVProgressHUD.dismiss()
                
                if let _ = isExpired {
                    self.forceLogout(self.navigationController!)
                    return
                }
                
                if let error = error {
                    self.function.showUnderstandDialog(self, "Gagal Mendapatkan Data Filter", error, "Reload", "Cancel", completionHandler: {
                        self.getYearsFilter()
                        self.getLeaveTypeFilter()
                        self.getLeaveStatusFilter()
                    })
                    return
                }
                
                guard let yearsFilter = yearsFilter else { return }
                
                var nameArray = [String]()
                var idArray = [Int]()
                
                for year in yearsFilter.data {
                    nameArray.append("\(year.year_name ?? 0)")
                    idArray.append(year.year!)
                }
                
                self.fieldTahun.optionArray = nameArray
                self.fieldTahun.optionIds = idArray
                
                self.fieldTahun.didSelect(completion: { (text, index, id) in
                    self.selectedTahun = "\(id)"
                    self.fieldTahun.text = text
                })
            }
        }
    }
    
    private func getLeaveTypeFilter() {
        SVProgressHUD.show()
        
        informationNetworking.getLeaveTypeFilter { (error, leaveTypeFilters, isExpired) in
            DispatchQueue.main.async {
                SVProgressHUD.dismiss()
                
                if let _ = isExpired {
                    self.forceLogout(self.navigationController!)
                    return
                }
                
                if let error = error {
                    self.function.showUnderstandDialog(self, "Gagal Mendapatkan Data Filter", error, "Reload", "Cancel", completionHandler: {
                        self.getYearsFilter()
                        self.getLeaveTypeFilter()
                        self.getLeaveStatusFilter()
                    })
                    return
                }
                
                guard let leaveTypeFilters = leaveTypeFilters else { return }
                
                var nameArray = [String]()
                var idArray = [Int]()
                
                for (index, leaveType) in leaveTypeFilters.data.enumerated() {
                    nameArray.append(leaveType.name!)
                    
                    if index == 0 {
                        idArray.append(self.defaultIds)
                    } else {
                        idArray.append(Int(leaveType.id!)!)
                    }
                }
                
                self.fieldJenisCuti.optionArray = nameArray
                self.fieldJenisCuti.optionIds = idArray
                
                self.fieldJenisCuti.didSelect(completion: { (text, index, id) in
                    self.selectedJenisCuti = "\(id)"
                    self.fieldJenisCuti.text = text
                })
            }
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle { return .lightContent }
    
    private func initView() {
        function.changeStatusBar(hexCode: 0x42a5f5, view: self.view, opacity: 1)
        checkTopMargin(viewRootTopMargin: viewRootTopMargin)
        fieldTahun.delegate = self
        fieldJenisCuti.delegate = self
        fieldStatus.delegate = self
        
        viewTahun.giveBorder(5, 1, "dedede")
        viewJenisCuti.giveBorder(5, 1, "dedede")
        viewStatus.giveBorder(5, 1, "dedede")
        buttonReset.giveBorder(buttonReset.frame.height / 2, 1, "42a5f5")
        buttonTerapkan.layer.cornerRadius = buttonTerapkan.frame.height / 2
        
        selectedTahun = function.getCurrentDate(pattern: "yyyy")
        fieldTahun.text = selectedTahun
    }
    
}

extension RiwayatCutiFilterController {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == fieldStatus {
            return false
        } else if textField == fieldTahun {
            return false
        } else if textField == fieldJenisCuti {
            return false
        }
        
        return true
    }
    
    @IBAction func buttonResetClick(_ sender: Any) {
        delegate.filter(tahun: "", jenisCuti: "", status: "")
        navigationController?.popViewController(animated: true)
    }
    @IBAction func buttonTerapkanClick(_ sender: Any) {
        delegate.filter(tahun: selectedTahun, jenisCuti: selectedJenisCuti, status: selectedStatus)
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func buttonBackClick(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
}
