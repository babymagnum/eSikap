//
//  HistoryPeminjamanRuanganCell.swift
//  Angkasa Pura Solusi
//
//  Created by Arief Zainuri on 25/01/20.
//  Copyright © 2020 Gama Techno. All rights reserved.
//

import UIKit

class HistoryPeminjamanRuanganCell: UICollectionViewCell {

    @IBOutlet weak var labelTitle: CustomLabel!
    @IBOutlet weak var labelDate: CustomLabel!
    @IBOutlet weak var viewContainer: UIView!
    @IBOutlet weak var labelTime: CustomLabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        viewContainer.clipsToBounds = true
        viewContainer.layer.cornerRadius = 5
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.addShadow(CGSize(width: 1, height: 2), UIColor.lightGray, 2, 0.6, 5)
    }

}
