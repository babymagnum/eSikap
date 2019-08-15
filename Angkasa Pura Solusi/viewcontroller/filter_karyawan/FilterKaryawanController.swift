//
//  FilterKaryawanController.swift
//  Angkasa Pura Solusi
//
//  Created by Arief Zainuri on 05/08/19.
//  Copyright © 2019 Gama Techno. All rights reserved.
//

import UIKit
import iOSDropDown
import SVProgressHUD

protocol FilterKaryawanControllerProtocol {
    func reloadKaryawan(empName: String, unit_id: String, workarea_id: String, gender: String, order_id: String)
}

class FilterKaryawanController: BaseViewController {

    @IBOutlet weak var viewRootTopMargin: NSLayoutConstraint!
    @IBOutlet weak var viewNamaKaryawan: UIView!
    @IBOutlet weak var viewDivisi: UIView!
    @IBOutlet weak var viewLokasiKerja: UIView!
    @IBOutlet weak var viewGender: UIView!
    @IBOutlet weak var viewOrderBy: UIView!
    @IBOutlet weak var buttonReset: UIButton!
    @IBOutlet weak var buttonTerapkan: UIButton!
    @IBOutlet weak var fieldNamaKaryawan: UITextField!
    @IBOutlet weak var fieldDivisi: DropDown!
    @IBOutlet weak var fieldGender: DropDown!
    @IBOutlet weak var fieldOrderBy: DropDown!
    @IBOutlet weak var fieldLokasiKerja: DropDown!
    
    var selectedUnit = ""
    var selectedWorkarea = ""
    var selectedGender = ""
    var selectedOrder = ""
    var delegate: FilterKaryawanControllerProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        function.changeStatusBar(hexCode: 0x42a5f5, view: self.view, opacity: 1)
        
        initView()
        
        dropDownListener()
        
        getUnit()
        
        getWorkArea()
        
        getGender()
        
        getOrder()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle { return .lightContent }
    
    private func getUnit() {
        SVProgressHUD.show()
        informationNetworking.getUnit { (error, listUnit, isExpired) in
            SVProgressHUD.dismiss()
            
            if let _ = isExpired {
                self.forceLogout(self.navigationController!)
                return
            }
            
            if let _ = error {
                self.getUnit()
                return
            }
            
            guard let list = listUnit else { return }
            
            var nameList = [String]()
            var idList = [Int]()
            
            for unit in list {
                nameList.append(unit.unit_name!)
                
                if unit.unit_id == "" {
                    idList.append(123456789)
                } else { idList.append(Int(unit.unit_id!)!) }
            }
            
            DispatchQueue.main.async {
                self.fieldDivisi.optionArray = nameList
                self.fieldDivisi.optionIds = idList
            }
        }
    }
    
    private func getWorkArea() {
        SVProgressHUD.show()
        informationNetworking.getWorkarea { (error, listWorkarea, isExpired) in
            SVProgressHUD.dismiss()
            
            if let _ = isExpired {
                self.forceLogout(self.navigationController!)
                return
            }
            
            if let _ = error {
                self.getWorkArea()
                return
            }
            
            guard let list = listWorkarea else { return }
            
            var nameList = [String]()
            var idList = [Int]()
            
            for workarea in list {
                nameList.append(workarea.workarea_name!)
                
                if workarea.workarea_id == "" { idList.append(1234567890)}
                else { idList.append(Int(workarea.workarea_id!)!) }
            }
            
            DispatchQueue.main.async {
                self.fieldLokasiKerja.optionArray = nameList
                self.fieldLokasiKerja.optionIds = idList
            }
        }
    }
    
    private func getGender() {
        SVProgressHUD.show()
        informationNetworking.getGender { (error, listGender, isExpired) in
            SVProgressHUD.dismiss()
            
            if let _ = isExpired {
                self.forceLogout(self.navigationController!)
                return
            }
            
            if let _ = error {
                self.getGender()
                return
            }
            
            guard let list = listGender else { return }
            
            var nameList = [String]()
            
            for gender in list {
                nameList.append(gender.gender_name!)
            }
            
            DispatchQueue.main.async {
                self.fieldGender.optionArray = nameList
            }
        }
    }
    
    private func getOrder() {
        SVProgressHUD.show()
        informationNetworking.getOrder { (error, listOrder, isExpired) in
            SVProgressHUD.dismiss()
            
            if let _ = isExpired {
                self.forceLogout(self.navigationController!)
                return
            }
            
            if let _ = error {
                self.getOrder()
                return
            }
            
            guard let list = listOrder else { return }
            
            var nameList = [String]()
            
            for order in list {
                nameList.append(order.order_name!)
            }
            
            DispatchQueue.main.async {
                self.fieldOrderBy.optionArray = nameList
            }
        }
    }
    
    private func getSelectedGender(gender: String) -> String {
        switch gender {
        case "Laki-laki": return "m"
        case "Perempuan": return "f"
        default: return ""
        }
    }
    
    private func getSelectedOrder(order: String) -> String {
        switch order {
        case "Karyawan Baru": return "baru"
        case "Karyawan Lama": return "lama"
        case "A to Z": return "a_to_z"
        case "Z to A": return "z_to_a"
        default: return ""
        }
    }
    
    private func dropDownListener() {
        fieldDivisi.didSelect { (text, index, id) in
            if text == "-- Semua --" {
                self.selectedUnit = ""
                return
            }
            
            self.selectedUnit = "\(id)"
            print("selected unit \(self.selectedUnit)")
            self.fieldDivisi.text = text
        }
        
        fieldGender.didSelect { (text, index, id) in
            if text == "-- Semua --" {
                self.selectedUnit = ""
                return
            }
            
            self.selectedGender = self.getSelectedGender(gender: text)
            self.fieldGender.text = text
        }
        
        fieldLokasiKerja.didSelect { (text, index, id) in
            if text == "-- Semua --" {
                self.selectedUnit = ""
                return
            }
            
            self.selectedWorkarea = "\(id)"
            self.fieldLokasiKerja.text = text
            print("selected workarea \(self.selectedWorkarea)")
        }
        
        fieldOrderBy.didSelect { (text, index, id) in
            if text == "-- Semua --" {
                self.selectedUnit = ""
                return
            }
            
            self.selectedOrder = self.getSelectedOrder(order: text)
            self.fieldOrderBy.text = text
        }
    }
    
    private func initView() {
        checkTopMargin(viewRootTopMargin: viewRootTopMargin)
        viewNamaKaryawan.giveBorder(3, 1, "dedede")
        viewDivisi.giveBorder(3, 1, "dedede")
        viewLokasiKerja.giveBorder(3, 1, "dedede")
        viewGender.giveBorder(3, 1, "dedede")
        viewOrderBy.giveBorder(3, 1, "dedede")
        buttonReset.layer.cornerRadius = buttonReset.frame.height / 2
        buttonReset.layer.borderWidth = 1
        buttonReset.layer.borderColor = UIColor.init(rgb: 0x42a5f5).cgColor
        buttonTerapkan.layer.cornerRadius = buttonTerapkan.frame.height / 2
    }

}

//click event
extension FilterKaryawanController {
    @IBAction func buttonTerapkanClick(_ sender: Any) {
        navigationController?.popViewController(animated: true)
        
        delegate?.reloadKaryawan(empName: fieldNamaKaryawan.trim(), unit_id: selectedUnit, workarea_id: selectedWorkarea, gender: selectedGender, order_id: selectedOrder)
    }
    
    @IBAction func buttonResetClick(_ sender: Any) {
        navigationController?.popViewController(animated: true)
        
        delegate?.reloadKaryawan(empName: "", unit_id: "", workarea_id: "", gender: "", order_id: "")
    }
    
    @IBAction func buttonBackClick(_ sender: Any) { navigationController?.popViewController(animated: true) }
}
