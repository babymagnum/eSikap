//
//  PresensiCell.swift
//  Angkasa Pura Solusi
//
//  Created by Arief Zainuri on 04/08/19.
//  Copyright © 2019 Gama Techno. All rights reserved.
//

import UIKit

class PresensiCell: UICollectionViewCell {
    
    lazy var function: PublicFunction = {
        let mFunction = PublicFunction()
        return mFunction
    }()

    @IBOutlet weak var labelPulang: CustomLabel!
    @IBOutlet weak var labelMasuk: CustomLabel!
    @IBOutlet weak var viewContainer: UIView!
    @IBOutlet weak var labelDate: UILabel!
    @IBOutlet weak var labelJamMasuk: UILabel!
    @IBOutlet weak var labelJamPulang: UILabel!
    @IBOutlet weak var labelPresensiMasuk: UILabel!
    @IBOutlet weak var labelPresensiPulang: UILabel!
    @IBOutlet weak var buttonStatusPresensi: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        viewContainer.layer.cornerRadius = 5
        
        self.buttonStatusPresensi.layer.cornerRadius = 5
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        addShadow(CGSize(width: 1, height: 2), UIColor.lightGray, 2, 0.6, 5)
    }
    
    var data: ItemPresensi? {
        didSet {
            if let data = data {
                self.labelDate.text = data.date
                
                if data.shift_start == "" {
                    self.labelJamMasuk.text = "-"
                } else {
                    if data.date_in == "" {
                        if (data.shift_start?.contains(" "))! {
                            self.labelJamMasuk.text = data.shift_start?.components(separatedBy: " ")[1]
                        } else {
                            self.labelJamMasuk.text = data.shift_start
                        }
                    } else {
                        if (data.shift_start?.contains(" "))! {
                            guard let arrayShiftStart = data.shift_start?.components(separatedBy: " ") else { return }
                            self.labelJamMasuk.text = "\(arrayShiftStart[0])     \(arrayShiftStart[1])"
                        } else {
                            self.labelJamMasuk.text = data.shift_start
                        }
                    }
                }
                
                if data.shift_end == "" {
                    self.labelJamPulang.text = "-"
                } else {
                    if data.date_in == "" {
                        if (data.shift_end?.contains(" "))! {
                            self.labelJamPulang.text = data.shift_end?.components(separatedBy: " ")[1]
                        } else {
                            self.labelJamPulang.text = data.shift_end
                        }
                    } else {
                        if (data.shift_end?.contains(" "))! {
                            guard let arrayShiftEnd = data.shift_end?.components(separatedBy: " ") else { return }
                            self.labelJamPulang.text = "\(arrayShiftEnd[0])     \(arrayShiftEnd[1])"
                        } else {
                            self.labelJamPulang.text = data.shift_end
                        }
                    }
                }
                
                if data.date_in == "" {
                    self.labelPresensiMasuk.text = "-"
                } else {
                    let fullString = (data.date_in?.contains(" "))! ? "\(data.date_in?.components(separatedBy: " ")[0] ?? "")      \(data.date_in?.components(separatedBy: " ")[1] ?? "")" : data.date_in
                    self.labelPresensiMasuk.attributedText = function.coloredString(color: "9ccc65", mainString: fullString!, stringNotColored: String((data.date_in?.prefix(9))!))
                }
                
                if data.date_out == "" {
                    self.labelPresensiPulang.text = "-"
                } else {
                    let fullString = (data.date_out?.contains(" "))! ? "\(data.date_out?.components(separatedBy: " ")[0] ?? "")      \(data.date_out?.components(separatedBy: " ")[1] ?? "")" : data.date_out
                    self.labelPresensiPulang.attributedText = function.coloredString(color: "ef5350", mainString: fullString!, stringNotColored: String((data.date_in?.prefix(9))!))
                }
                
                if data.presence_status == "" {
                    buttonStatusPresensi.alpha = 0
                } else {
                    buttonStatusPresensi.alpha = 1
                    buttonStatusPresensi.setTitle(data.presence_status, for: .normal)
                }
                
                buttonStatusPresensi.backgroundColor = UIColor(hexString: data.presence_status_bg_color!)
            }
        }
    }

}
