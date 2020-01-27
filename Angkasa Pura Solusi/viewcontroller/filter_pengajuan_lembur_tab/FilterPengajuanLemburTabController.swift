//
//  FilterPengajuanLemburTabController.swift
//  Angkasa Pura Solusi
//
//  Created by Arief Zainuri on 27/01/20.
//  Copyright © 2020 Gama Techno. All rights reserved.
//

import UIKit
import SVProgressHUD

protocol FilterPengajuanLemburTabProtocol {
    func filterApply(year: String, status: String)
}

class FilterPengajuanLemburTabController: BaseViewController {

    @IBOutlet weak var constraintViewRoot: NSLayoutConstraint!
    @IBOutlet weak var viewTahun: UIView!
    @IBOutlet weak var fieldTahun: CustomDropDownField!
    @IBOutlet weak var viewStatus: UIView!
    @IBOutlet weak var fieldStatus: CustomDropDownField!
    @IBOutlet weak var buttonReset: CustomButton!
    @IBOutlet weak var buttonTerapkan: CustomButton!
    
    var delegate: FilterPengajuanLemburTabProtocol?
    
    private var listStatus = [OvertimeStatusFilterItem]()
    
    private var selectedYears = ""
    private var selectedStatus = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initView()
        
        getYearsFilter()
        
        getStatusFilter()
    }
    
    private func getStatusFilter() {
        SVProgressHUD.show()
        
        informationNetworking.getOvertimeStatusFilter { (error, overtimeStatus, isExpired) in
            SVProgressHUD.dismiss()
            
            if let _ = isExpired {
                self.forceLogout(self.navigationController!)
                return
            }
            
            if let _ = error {
                self.getYearsFilter()
                return
            }
            
            guard let _overtimeStatus = overtimeStatus else { return }
            
            self.listStatus = _overtimeStatus.data
            
            _overtimeStatus.data.forEach { (item) in
                self.fieldStatus.optionArray.append(item.overtimestat_name ?? "")
            }
            
            self.fieldStatus.didSelect { (text, index, _) in
                self.selectedStatus = self.listStatus[index].overtimestat_id ?? ""
            }
        }
    }

    private func initView() {
        selectedYears = function.getCurrentDate(pattern: "yyyy")
        fieldTahun.text = selectedYears
        function.changeStatusBar(hexCode: 0x42a5f5, view: self.view, opacity: 1)
        checkTopMargin(viewRootTopMargin: constraintViewRoot)
        buttonReset.giveBorder(38 / 2, 1, "42a5f5")
        buttonTerapkan.giveBorder(38 / 2, 0, "fff")
        viewTahun.giveBorder(3, 1, "dedede")
        viewStatus.giveBorder(3, 1, "dedede")
    }
    
    private func getYearsFilter() {
        SVProgressHUD.show()
        
        informationNetworking.getYearsFilter { (error, years, isExpired) in
            SVProgressHUD.dismiss()
            
            if let _ = isExpired {
                self.forceLogout(self.navigationController!)
                return
            }
            
            if let _ = error {
                self.getYearsFilter()
                return
            }
            
            guard let _years = years else { return }
            
            _years.data.forEach { (item) in
                self.fieldTahun.optionArray.append("\(item.year_name ?? 0)")
            }
            
            self.fieldTahun.didSelect { (text, index, _) in
                self.selectedYears = text
            }
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle { return .lightContent }
}

extension FilterPengajuanLemburTabController {
    @IBAction func buttonTerapkanClick(_ sender: Any) {
        guard let _delegate = delegate else { return }
        
        _delegate.filterApply(year: selectedYears, status: selectedStatus)
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func buttonResetClick(_ sender: Any) {
        guard let _delegate = delegate else { return }
        
        selectedYears = function.getCurrentDate(pattern: "yyyy")
        selectedStatus = ""
        _delegate.filterApply(year: selectedYears, status: selectedStatus)
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func buttonBackClick(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}
