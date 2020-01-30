//
//  TanggalLemburPersetujuanCell.swift
//  Angkasa Pura Solusi
//
//  Created by Arief Zainuri on 30/01/20.
//  Copyright © 2020 Gama Techno. All rights reserved.
//

import UIKit

class TanggalLemburPersetujuanCell: UICollectionViewCell {

    @IBOutlet weak var viewContainer: UIView!
    @IBOutlet weak var labelTanggalMulai: CustomLabel!
    @IBOutlet weak var labelStatus: CustomLabel!
    @IBOutlet weak var switchStatus: UISwitch!
    @IBOutlet weak var labelTanggalSelesai: CustomLabel!
    @IBOutlet weak var viewMulai: UIView!
    @IBOutlet weak var viewSelesai: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        viewContainer.giveBorder(3, 1, "dedede")
        viewMulai.giveBorder(25 / 2, 0, "fff")
        viewSelesai.giveBorder(25 / 2, 0, "fff")
    }

}
