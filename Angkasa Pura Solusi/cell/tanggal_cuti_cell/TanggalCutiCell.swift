//
//  TanggalCutiCell.swift
//  Angkasa Pura Solusi
//
//  Created by Arief Zainuri on 06/08/19.
//  Copyright © 2019 Gama Techno. All rights reserved.
//

import UIKit

class TanggalCutiCell: UICollectionViewCell {

    @IBOutlet weak var labelTanggal: UILabel!
    @IBOutlet weak var buttonDeleteTanggal: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    var data: String? {
        didSet {
            if let item = data {
                labelTanggal.text = item
            }
        }
    }
}
