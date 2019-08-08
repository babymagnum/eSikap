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
        
        buttonStatusPresensi.layer.cornerRadius = buttonStatusPresensi.frame.height / 2
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
                    self.labelJamMasuk.text = data.shift_start
                }
                
                if data.shift_end == "" {
                    self.labelJamPulang.text = "-"
                } else {
                    self.labelJamPulang.text = data.shift_end
                }
                
                if data.date_in == "" {
                    self.labelPresensiMasuk.text = "-" // only for make the text not empty
                } else {
                    let fullString = (data.date_in?.contains(" "))! ? "\(data.date_in?.components(separatedBy: " ")[0] ?? "")      \(data.date_in?.components(separatedBy: " ")[1] ?? "")" : data.date_in
                    self.labelPresensiMasuk.attributedText = function.coloredString(color: "9ccc65", mainString: fullString!, stringNotColored: String((data.date_in?.prefix(9))!))
                }
                
                if data.date_out == "" {
                    self.labelPresensiPulang.text = "-" // only for make the text not empty
                } else {
                    let fullString = (data.date_out?.contains(" "))! ? "\(data.date_out?.components(separatedBy: " ")[0] ?? "")      \(data.date_out?.components(separatedBy: " ")[1] ?? "")" : data.date_out
                    self.labelPresensiPulang.attributedText = function.coloredString(color: "ef5350", mainString: fullString!, stringNotColored: String((data.date_in?.prefix(9))!))
                }
                
                buttonStatusPresensi.setTitle(data.presence_status, for: .normal)
                buttonStatusPresensi.backgroundColor = UIColor(hexString: data.presence_status_bg_color!)
            }
        }
    }

}
