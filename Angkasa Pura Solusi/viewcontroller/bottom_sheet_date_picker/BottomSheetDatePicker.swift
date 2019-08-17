//
//  BottomSheetDatePicker.swift
//  Angkasa Pura Solusi
//
//  Created by Arief Zainuri on 17/08/19.
//  Copyright © 2019 Gama Techno. All rights reserved.
//

import UIKit

protocol BottomSheetDatePickerProtocol {
    func pickDate(pickedDate: String)
}

class BottomSheetDatePicker: BaseViewController {

    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var buttonPilih: UIButton!
    
    var pickedDate = ""
    var delegate: BottomSheetDatePickerProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pickedDate = function.getCurrentDate(pattern: "dd/MM/yyyy")
        
        initEvent()
    }
    
    private func initEvent() {
        datePicker.addTarget(self, action: #selector(dateChanged(_:)), for: .valueChanged)
    }
    
}

extension BottomSheetDatePicker {
    @IBAction func buttonPilihClick(_ sender: Any) {
        delegate?.pickDate(pickedDate: pickedDate)
        dismiss(animated: true, completion: nil)
    }
    
    @objc func dateChanged(_ sender: UIDatePicker) {
        let components = Calendar.current.dateComponents([.year, .month, .day], from: sender.date)
        if let day = components.day, let month = components.month, let year = components.year {
            self.pickedDate = "\(day)/\(month)/\(year)"
        }
    }
}
