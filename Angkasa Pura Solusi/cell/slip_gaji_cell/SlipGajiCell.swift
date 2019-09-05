//
//  SlipGajiCell.swift
//  Angkasa Pura Solusi
//
//  Created by Arief Zainuri on 05/09/19.
//  Copyright © 2019 Gama Techno. All rights reserved.
//

import UIKit

class SlipGajiCell: UICollectionViewCell {

    @IBOutlet weak var viewContainer: UIView!
    @IBOutlet weak var labelBulan: UILabel!
    @IBOutlet weak var labelDates: UILabel!
    @IBOutlet weak var viewKirimEmail: UIView!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.addShadow(CGSize(width: 2, height: 3), UIColor.lightGray, 3, 0.4, 5)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        viewContainer.clipsToBounds = true
        viewContainer.layer.cornerRadius = 5
    }
    
    var data: ItemSlipGaji? {
        didSet {
            if let item = data {
                labelBulan.text = item.month
                labelDates.text = item.date_range
            }
        }
    }

}
