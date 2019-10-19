//
//  BottomSheetDatePicker.swift
//  Angkasa Pura Solusi
//
//  Created by Arief Zainuri on 17/08/19.
//  Copyright © 2019 Gama Techno. All rights reserved.
//

import UIKit

protocol BottomSheetDatePickerProtocol {
    func pickDate(formatedDate: String, originalDate: String)
    func pickTime(pickedTime: String)
}

enum PickerTypeEnum {
    case date
    case time
    case year
}

class BottomSheetDatePicker: BaseViewController {

    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var buttonPilih: UIButton!
    @IBOutlet weak var viewContainer: UIView!
    
    var pickedDate = ""
    var pickedTime = ""
    var delegate: BottomSheetDatePickerProtocol?
    var picker: PickerTypeEnum!
    var isBackDate: Bool!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pickedDate = function.getCurrentDate(pattern: "yyyy-MM-dd")
        
        initView()
    }
    
    private func initView() {
        buttonPilih.layer.cornerRadius = 5
        
        switch picker {
            case .date?: datePicker.datePickerMode = .date
            default: datePicker.datePickerMode = .time
        }
        
        if !isBackDate {
            datePicker.minimumDate = function.stringToDate(function.getCurrentDate(pattern: "yyyy-MM-dd"), "yyyy-MM-dd")
        }
    }
    
}

extension BottomSheetDatePicker {
    @IBAction func buttonPilihClick(_ sender: Any) {
        switch picker {
            case .date?: delegate?.pickDate(formatedDate: function.dateToString(datePicker.date, "dd-MM-yyyy"), originalDate: pickedDate)
            case .time?: delegate?.pickTime(pickedTime: pickedTime)
            default: break
        }
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func datePickerChange(_ sender: Any) {
        switch picker {
        case .date?:
            self.pickedDate = function.dateToString(datePicker.date, "yyyy-MM-dd")
        case .time?:
            self.pickedTime = function.dateToString(datePicker.date, "hh:mm")
        default: break
        }
    }
}
