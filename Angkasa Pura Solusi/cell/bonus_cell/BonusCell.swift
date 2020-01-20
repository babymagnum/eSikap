//
//  BonusCell.swift
//  Angkasa Pura Solusi
//
//  Created by Arief Zainuri on 20/01/20.
//  Copyright © 2020 Gama Techno. All rights reserved.
//

import UIKit

class BonusCell: UICollectionViewCell {

    @IBOutlet weak var labelTitle: CustomLabel!
    @IBOutlet weak var labelDate: CustomLabel!
    @IBOutlet weak var viewKirimEmail: UIView!
    @IBOutlet weak var viewContainer: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        viewContainer.clipsToBounds = true
        viewContainer.layer.cornerRadius = 5
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.addShadow(CGSize(width: 2, height: 3), UIColor.lightGray, 3, 0.4, 5)
    }
    
    var data: BonusItem? {
        didSet {
            if let _data = data {
                labelTitle.text = _data.name == "" ? "-" : _data.name
                labelDate.text = _data.month
            }
        }
    }
}
