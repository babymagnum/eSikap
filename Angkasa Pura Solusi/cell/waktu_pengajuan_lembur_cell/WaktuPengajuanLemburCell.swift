//
//  WaktuPengajuanLemburCell.swift
//  Angkasa Pura Solusi
//
//  Created by Arief Zainuri on 26/01/20.
//  Copyright © 2020 Gama Techno. All rights reserved.
//

import UIKit

class WaktuPengajuanLemburCell: UICollectionViewCell {

    @IBOutlet weak var buttonSelesai: CustomButton!
    @IBOutlet weak var buttonMulai: CustomButton!
    @IBOutlet weak var labelMulai: CustomLabel!
    @IBOutlet weak var imageDelete: UIImageView!
    @IBOutlet weak var labelSelesai: CustomLabel!
    @IBOutlet weak var viewContainer: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        buttonMulai.giveBorder(buttonMulai.frame.size.height / 2, 0, "fff")
        buttonSelesai.giveBorder(buttonSelesai.frame.size.height / 2, 0, "fff")
        viewContainer.giveBorder(3, 1, "dedede")
    }

}
