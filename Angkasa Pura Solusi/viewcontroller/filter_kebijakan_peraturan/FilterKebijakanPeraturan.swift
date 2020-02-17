//
//  FilterKebijakanPeraturan.swift
//  Angkasa Pura Solusi
//
//  Created by Arief Zainuri on 20/01/20.
//  Copyright © 2020 Gama Techno. All rights reserved.
//

import UIKit
import SVProgressHUD

protocol FilterKebijakanPeraturanProtocol {
    func yearsPick(year: String)
}

class FilterKebijakanPeraturan: BaseViewController {

    @IBOutlet weak var constraintViewRoot: NSLayoutConstraint!
    @IBOutlet weak var viewTahun: UIView!
    @IBOutlet weak var fieldTahun: CustomDropDownField!
    @IBOutlet weak var buttonReset: CustomButton!
    @IBOutlet weak var buttonTerapkan: CustomButton!
    
    var delegate: FilterKebijakanPeraturanProtocol?
    
    private var selectedYears = "2019"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initView()
        
        getYearsFilter()
    }

    private func getYearsFilter() {
        SVProgressHUD.show()
        
        informationNetworking.getYearsFilter { (error, years, isExpired) in
            DispatchQueue.main.async {
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
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle { return .lightContent }
    
    private func initView() {
        selectedYears = function.getCurrentDate(pattern: "yyyy")
        fieldTahun.text = selectedYears
        checkTopMargin(viewRootTopMargin: constraintViewRoot)
        function.changeStatusBar(hexCode: 0x42a5f5, view: self.view, opacity: 1)
        viewTahun.giveBorder(3, 1, "dedede")
        buttonTerapkan.giveBorder(38 / 2, 0, "dedede")
        buttonReset.giveBorder(38 / 2, 1, "42a5f5")
    }
    
    @IBAction func buttonTerapkanClick(_ sender: Any) {
        guard let _delegate = delegate else { return }
        
        _delegate.yearsPick(year: selectedYears)
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func buttonResetClick(_ sender: Any) {
        guard let _delegate = delegate else { return }
        
        selectedYears = function.getCurrentDate(pattern: "yyyy")
        _delegate.yearsPick(year: selectedYears)
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func buttonBackClick(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}

extension FilterKebijakanPeraturan {
    
}
