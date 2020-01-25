//
//  FilterHistoryPeminjamanMobilController.swift
//  Angkasa Pura Solusi
//
//  Created by Arief Zainuri on 16/01/20.
//  Copyright © 2020 Gama Techno. All rights reserved.
//

import UIKit
import SVProgressHUD

protocol FilterHistoryPeminjamanMobilProtocol {
    func terapkan(years: String, status: String)
}

class FilterHistoryPeminjamanMobilController: BaseViewController {

    @IBOutlet weak var viewTahun: UIView!
    @IBOutlet weak var fieldTahun: CustomDropDownField!
    @IBOutlet weak var viewStatus: UIView!
    @IBOutlet weak var fieldStatus: CustomDropDownField!
    @IBOutlet weak var constraintViewRoot: NSLayoutConstraint!
    @IBOutlet weak var buttonTerapkan: CustomButton!
    @IBOutlet weak var buttonReset: CustomButton!
    @IBOutlet weak var labelStatus: CustomLabel!
    
    var delegate: FilterHistoryPeminjamanMobilProtocol?
    var isFromPeminjamanRuangan: Bool?
    
    private var selectedYears = "2019"
    private var selectedStatus = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initView()
        
        getYearsFilter()
        
        getStatusFilter()
    }
    
    private func getStatusFilter() {
        SVProgressHUD.show()
        
        informationNetworking.getRequestCarStatusFilter { (error, request, isExpired) in
            SVProgressHUD.dismiss()
            
            if let _ = isExpired {
                self.forceLogout(self.navigationController!)
                return
            }
            
            if let _ = error {
                self.getStatusFilter()
                return
            }
            
            guard let _request = request else { return }
            
            _request.data.forEach { (item) in
                self.fieldStatus.optionArray.append(item.opercarstat_name)
                self.fieldStatus.optionIds?.append(Int(item.opercarstat_id == "" ? "-1" : item.opercarstat_id) ?? -1)
            }
            
            self.fieldStatus.didSelect { (text, index, id) in
                self.selectedStatus = "\(id)"
            }
        }
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
    
    private func initView() {
        if let _ = isFromPeminjamanRuangan {
            labelStatus.isHidden = true
            viewStatus.isHidden = true
        }
        
        selectedYears = function.getCurrentDate(pattern: "yyyy")
        fieldTahun.text = selectedYears
        checkTopMargin(viewRootTopMargin: constraintViewRoot)
        function.changeStatusBar(hexCode: 0x42a5f5, view: self.view, opacity: 1)
        viewTahun.giveBorder(3, 1, "dedede")
        viewStatus.giveBorder(3, 1, "dedede")
        buttonTerapkan.giveBorder(38 / 2, 0, "dedede")
        buttonReset.giveBorder(38 / 2, 1, "42a5f5")
    }

}

extension FilterHistoryPeminjamanMobilController {
    @IBAction func buttonTerapkanClick(_ sender: Any) {
        guard let _delegate = delegate else { return }
        
        _delegate.terapkan(years: selectedYears, status: selectedStatus)
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func buttonResetClick(_ sender: Any) {
        guard let _delegate = delegate else { return }
        
        selectedYears = function.getCurrentDate(pattern: "yyyy")
        selectedStatus = ""
        _delegate.terapkan(years: selectedYears, status: selectedStatus)
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func buttonBackClick(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}
