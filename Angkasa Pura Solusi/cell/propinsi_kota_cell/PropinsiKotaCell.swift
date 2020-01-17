//
//  PropinsiKotaCell.swift
//  Angkasa Pura Solusi
//
//  Created by Arief Zainuri on 15/01/20.
//  Copyright © 2020 Gama Techno. All rights reserved.
//

import UIKit

class PropinsiKotaCell: UICollectionViewCell {

    @IBOutlet weak var viewRoot: UIView!
    @IBOutlet weak var labelPropinsiKota: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        viewRoot.giveBorder(4, 0, "ffffff")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.addShadow(CGSize(width: 1, height: 2), UIColor.lightGray, 2, 0.6, 5)
    }
    
    var data: PropinsiCityDataItem? {
        didSet {
            if let _data = data {
                labelPropinsiKota.text = _data.name
            }
        }
    }
}
