//
//  LampiranPeminjamanRuangCell.swift
//  Angkasa Pura Solusi
//
//  Created by Arief Zainuri on 24/01/20.
//  Copyright © 2020 Gama Techno. All rights reserved.
//

import UIKit

class LampiranPeminjamanRuangCell: UICollectionViewCell {

    @IBOutlet weak var labelJudul: CustomLabel!
    @IBOutlet weak var buttonJudul: CustomButton!
    @IBOutlet weak var buttonFile: CustomButton!
    @IBOutlet weak var labelFile: CustomLabel!
    @IBOutlet weak var imageDelete: UIImageView!
    @IBOutlet weak var viewContainer: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        buttonJudul.giveBorder(buttonJudul.frame.size.height / 2, 0, "fff")
        buttonFile.giveBorder(buttonJudul.frame.size.height / 2, 0, "fff")
        viewContainer.giveBorder(3, 1, "dedede")
    }

    var data: LampiranModel? {
        didSet {
            if let _data = data {
                labelJudul.text = _data.title
                labelFile.text = _data.file
            }
        }
    }
}
