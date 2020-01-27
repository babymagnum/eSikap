//
//  TanggalLemburCell.swift
//  Angkasa Pura Solusi
//
//  Created by Arief Zainuri on 27/01/20.
//  Copyright © 2020 Gama Techno. All rights reserved.
//

import UIKit

class TanggalLemburCell: UICollectionViewCell {

    @IBOutlet weak var viewContainer: UIView!
    @IBOutlet weak var labelTanggalMulai: CustomLabel!
    @IBOutlet weak var labelStatus: CustomLabel!
    @IBOutlet weak var imageStatus: UIImageView!
    @IBOutlet weak var labelTanggalSelesai: CustomLabel!
    @IBOutlet weak var buttonMulai: CustomButton!
    @IBOutlet weak var buttonSelesai: CustomButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        viewContainer.giveBorder(3, 1, "dedede")
        buttonMulai.giveBorder(25 / 2, 0, "fff")
        buttonSelesai.giveBorder(25 / 2, 0, "fff")
    }
}
