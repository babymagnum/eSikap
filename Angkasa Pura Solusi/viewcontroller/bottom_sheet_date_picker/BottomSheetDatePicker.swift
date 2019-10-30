//
//  BottomSheetDatePicker.swift
//  Angkasa Pura Solusi
//
//  Created by Arief Zainuri on 17/08/19.
//  Copyright © 2019 Gama Techno. All rights reserved.
//

import UIKit

protocol BottomSheetDatePickerProtocol {
    func pickDate(formatedDate: String)
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
    
    var delegate: BottomSheetDatePickerProtocol?
    var picker: PickerTypeEnum!
    var isBackDate: Bool!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
            case .date?: delegate?.pickDate(formatedDate: function.dateToString(datePicker.date, "dd-MM-yyyy"))
        case .time?: delegate?.pickTime(pickedTime: function.dateToString(datePicker.date, "kk:mm"))
            default: break
        }
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func datePickerChange(_ sender: Any) {
        switch picker {
        case .date?:
            print("")
        case .time?:
            print("")
        default: break
        }
    }
}
