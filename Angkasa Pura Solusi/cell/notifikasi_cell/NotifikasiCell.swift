//
//  NotifikasiCell.swift
//  Angkasa Pura Solusi
//
//  Created by Arief Zainuri on 03/09/19.
//  Copyright © 2019 Gama Techno. All rights reserved.
//

import UIKit

class NotifikasiCell: UICollectionViewCell {

    @IBOutlet weak var viewContainer: UIView!
    @IBOutlet weak var labelTitle: CustomLabel!
    @IBOutlet weak var labelTanggal: CustomLabel!
    @IBOutlet weak var labelContent: CustomLabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        viewContainer.clipsToBounds = true
        viewContainer.layer.cornerRadius = 5
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.addShadow(CGSize(width: 2, height: 3), UIColor.lightGray, 3, 0.4, 5)
    }

    var data: ItemListNotification? {
        didSet {
            if let item = data {
                labelTitle.text = item.title
                labelTanggal.text = item.date
                labelContent.text = item.content
                
                if item.is_read == "0" {
                    labelTitle.textColor = UIColor(hexString: "004CFF")
                    labelTanggal.textColor = UIColor(hexString: "6C6C6C")
                    labelContent.textColor = UIColor(hexString: "262626")
                }
            }
        }
    }
}
