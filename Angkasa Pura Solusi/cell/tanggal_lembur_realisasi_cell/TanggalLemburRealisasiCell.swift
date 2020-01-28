//
//  TanggalLemburRealisasiCell.swift
//  Angkasa Pura Solusi
//
//  Created by Arief Zainuri on 28/01/20.
//  Copyright © 2020 Gama Techno. All rights reserved.
//

import UIKit

class TanggalLemburRealisasiCell: UICollectionViewCell {

    @IBOutlet weak var viewContainer: UIView!
    @IBOutlet weak var buttonMulaiPermintaan: CustomButton!
    @IBOutlet weak var labelMulaiPermintaan: CustomLabel!
    @IBOutlet weak var buttonSelesaiPermintaan: CustomButton!
    @IBOutlet weak var labelSelesaiPermintaan: CustomLabel!
    @IBOutlet weak var buttonMulaiRealisasi: CustomButton!
    @IBOutlet weak var viewTanggalMulai: UIView!
    @IBOutlet weak var fieldTanggalMulai: CustomTextField!
    @IBOutlet weak var viewWaktuMulai: UIView!
    @IBOutlet weak var fieldWaktuMulai: CustomTextField!
    @IBOutlet weak var buttonSelesaiRealisasi: CustomButton!
    @IBOutlet weak var viewTanggalSelesai: UIView!
    @IBOutlet weak var fieldTanggalSelesai: CustomTextField!
    @IBOutlet weak var viewWaktuSelesai: UIView!
    @IBOutlet weak var fieldWaktuSelesai: CustomTextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        viewContainer.giveBorder(3, 1, "dedede")
        viewTanggalMulai.giveBorder(3, 1, "dedede")
        viewWaktuMulai.giveBorder(3, 1, "dedede")
        viewTanggalSelesai.giveBorder(3, 1, "dedede")
        viewWaktuSelesai.giveBorder(3, 1, "dedede")
        buttonMulaiPermintaan.giveBorder(25 / 2, 0, "fff")
        buttonSelesaiPermintaan.giveBorder(25 / 2, 0, "fff")
        buttonMulaiRealisasi.giveBorder(25 / 2, 0, "fff")
        buttonSelesaiRealisasi.giveBorder(25 / 2, 0, "fff")
    }

}
