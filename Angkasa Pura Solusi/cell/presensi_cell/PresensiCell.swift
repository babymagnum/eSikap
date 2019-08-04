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
        
        addShadow(CGSize(width: 1, height: 2), UIColor.lightGray, 2, 0.6)
    }
    
    private func waktuPresensi(_ date: String, _ label: UILabel) {
        if date == "" {
            label.isHidden = true
            label.text = function.getCurrentDate(pattern: "hh:mm:ss")
        } else {
            label.isHidden = false
            label.text = date.components(separatedBy: " ")[1]
        }
    }
    
    private func waktuShift(_ time: String, _ label: UILabel) {
        if time == "" {
            label.text = ""
        } else {
            label.text = String(time.prefix(5))
        }
    }
    
    var data: ItemPresensi? {
        didSet {
            if let data = data {
                self.labelDate.text = data.date
                self.waktuShift(data.shift_start!, self.labelJamMasuk)
                self.waktuShift(data.shift_end!, self.labelJamPulang)
                self.waktuPresensi(data.date_in ?? "", self.labelPresensiMasuk)
                self.waktuPresensi(data.date_out ?? "", self.labelPresensiPulang)
                buttonStatusPresensi.setTitle(data.presence_status, for: .normal)
                buttonStatusPresensi.backgroundColor = UIColor(hexString: data.presence_status_bg_color!)
            }
        }
    }

}
