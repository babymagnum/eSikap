//
//  ExceptionCell.swift
//  Angkasa Pura Solusi
//
//  Created by Arief Zainuri on 01/09/19.
//  Copyright © 2019 Gama Techno. All rights reserved.
//

import UIKit

class ExceptionCell: UICollectionViewCell {

    @IBOutlet weak var labelException: CustomLabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    var data: String? {
        didSet {
            if let item = data {
                labelException.text = "- \(item)"
            }
        }
    }
}
