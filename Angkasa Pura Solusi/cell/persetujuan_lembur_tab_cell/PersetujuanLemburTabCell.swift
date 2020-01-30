//
//  PersetujuanLemburTabCell.swift
//  Angkasa Pura Solusi
//
//  Created by Arief Zainuri on 30/01/20.
//  Copyright © 2020 Gama Techno. All rights reserved.
//

import UIKit

class PersetujuanLemburTabCell: UICollectionViewCell {

    @IBOutlet weak var viewContainer: UIView!
    @IBOutlet weak var imageProfile: UIImageView!
    @IBOutlet weak var labelNumber: CustomLabel!
    @IBOutlet weak var labelDate: CustomLabel!
    @IBOutlet weak var labelTime: CustomLabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        viewContainer.clipsToBounds = true
        viewContainer.layer.cornerRadius = 5
        imageProfile.giveBorder((UIScreen.main.bounds.width - 32) * 0.13 / 2, 0, "fff")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.addShadow(CGSize(width: 1, height: 2), UIColor.lightGray, 2, 0.6, 5)
    }

}
