//
//  BottomSheetFilterPresensi.swift
//  Angkasa Pura Solusi
//
//  Created by Arief Zainuri on 07/08/19.
//  Copyright © 2019 Gama Techno. All rights reserved.
//

import UIKit

protocol BottomSheetFilterPresensiProtocol {
    func filterPicked(_ month: String, _ year: String)
}

class BottomSheetFilterPresensi: UIViewController, UIPickerViewDelegate {

    @IBOutlet weak var pickerViewBulan: UIPickerView!
    @IBOutlet weak var pickerViewTahun: UIPickerView!
    @IBOutlet weak var buttonKembali: UIButton!
    @IBOutlet weak var buttonTerapkan: UIButton!
    
    var listBulan = [Bulan]()
    var listTahun = [String]()
    
    var pickedBulan = "01"
    var pickedTahun = "2000"
    
    var delegate: BottomSheetFilterPresensiProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initView()
        
        initPickerView()
    }
    
    private func initView() {
        buttonTerapkan.layer.cornerRadius = 5
        buttonKembali.giveBorder(5, 1, "42a5f5")
    }
    
    private func initPickerView() {
        pickerViewBulan.delegate = self
        pickerViewTahun.delegate = self
        pickerViewBulan.dataSource = self
        pickerViewTahun.dataSource = self
        
        // populate data
        listBulan.append(Bulan(id: "01", name: "Januari"))
        listBulan.append(Bulan(id: "02", name: "Februari"))
        listBulan.append(Bulan(id: "03", name: "Maret"))
        listBulan.append(Bulan(id: "04", name: "April"))
        listBulan.append(Bulan(id: "05", name: "Mei"))
        listBulan.append(Bulan(id: "06", name: "Juni"))
        listBulan.append(Bulan(id: "07", name: "Juli"))
        listBulan.append(Bulan(id: "08", name: "Agustus"))
        listBulan.append(Bulan(id: "09", name: "September"))
        listBulan.append(Bulan(id: "10", name: "Oktober"))
        listBulan.append(Bulan(id: "11", name: "November"))
        listBulan.append(Bulan(id: "12", name: "Desember"))
        
        // populate tahun
        for year in 2000...2019 {
            listTahun.append("\(year)")
        }
    }

}

extension BottomSheetFilterPresensi: UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == pickerViewBulan {
            return listBulan.count
        } else {
            return listTahun.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == pickerViewBulan {
            return listBulan[row].name
        } else {
            return listTahun[row]
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == pickerViewBulan {
            self.pickedBulan = listBulan[row].id!
            print("picked bulan \(self.pickedBulan)")
        } else {
            self.pickedTahun = listTahun[row]
            print("picked tahun \(self.pickedTahun)")
        }
    }
}

extension BottomSheetFilterPresensi {
    @IBAction func buttonTerapkanClick(_ sender: Any) {
        dismiss(animated: true, completion: nil)
        delegate?.filterPicked(pickedBulan, pickedTahun)
    }
    @IBAction func buttonKembaliClick(_ sender: Any) { dismiss(animated: true, completion: nil) }
}
