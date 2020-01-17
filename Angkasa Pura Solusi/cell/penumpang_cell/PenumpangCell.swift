//
//  PenumpangCell.swift
//  Angkasa Pura Solusi
//
//  Created by Arief Zainuri on 14/01/20.
//  Copyright © 2020 Gama Techno. All rights reserved.
//

import UIKit

class PenumpangCell: UICollectionViewCell {

    @IBOutlet weak var labelPenumpang: CustomLabel!
    @IBOutlet weak var buttonDelete: UIButton!
    @IBOutlet weak var viewDivider: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    var isLast: Bool?
    
    var data: PenumpangItem? {
        didSet {
            if let data = data {
                labelPenumpang.text = data.emp_name
                if let _isLast = isLast {
                    viewDivider.isHidden = _isLast
                }
            }
        }
    }
}
