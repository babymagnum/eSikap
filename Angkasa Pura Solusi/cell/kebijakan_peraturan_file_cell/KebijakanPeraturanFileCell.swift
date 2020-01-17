//
//  KebijakanPeraturanFileCell.swift
//  Angkasa Pura Solusi
//
//  Created by Arief Zainuri on 17/01/20.
//  Copyright © 2020 Gama Techno. All rights reserved.
//

import UIKit

class KebijakanPeraturanFileCell: UICollectionViewCell {

    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var viewRoot: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    var data: PolicyDataFilesItem? {
        didSet {
            if let _data = data {
                labelTitle.text = _data.file_name
            }
        }
    }
}
