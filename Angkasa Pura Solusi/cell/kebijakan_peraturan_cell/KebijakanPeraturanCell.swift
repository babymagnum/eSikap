//
//  KebijakanPeraturanCell.swift
//  Angkasa Pura Solusi
//
//  Created by Arief Zainuri on 16/01/20.
//  Copyright © 2020 Gama Techno. All rights reserved.
//

import UIKit

class KebijakanPeraturanCell: UICollectionViewCell {

    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var viewRoot: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        viewRoot.giveBorder(4, 0, "ffffff")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.addShadow(CGSize(width: 1, height: 2), UIColor.lightGray, 2, 0.6, 5)
    }

    var data: PolicyCategoryDataItem? {
        didSet {
            if let _data = data {
                labelTitle.text = _data.name
            }
        }
    }
}
