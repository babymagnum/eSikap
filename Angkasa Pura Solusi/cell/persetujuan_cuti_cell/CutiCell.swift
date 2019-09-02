//
//  CutiCell.swift
//  Angkasa Pura Solusi
//
//  Created by Arief Zainuri on 10/08/19.
//  Copyright © 2019 Gama Techno. All rights reserved.
//

import UIKit

class CutiCell: UICollectionViewCell {

    @IBOutlet weak var viewContainer: UIView!
    @IBOutlet weak var imageAccount: UIImageView!
    @IBOutlet weak var labelNama: UILabel!
    @IBOutlet weak var labelKodeCuti: UILabel!
    @IBOutlet weak var labelTypeCuti: UILabel!
    @IBOutlet weak var labelTanggalCuti: UILabel!
    @IBOutlet weak var labelSubmitted: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        imageAccount.layer.cornerRadius = imageAccount.frame.height / 2
        
        viewContainer.clipsToBounds = true
        viewContainer.layer.cornerRadius = 3
    }
    
    var data: ItemDelegation? {
        didSet {
            if let item = data {
                imageAccount.loadUrl(item.photo!)
                labelNama.text = item.emp_name
                labelKodeCuti.text = item.number
                labelTypeCuti.text = item.type_name
                labelTanggalCuti.text = item.dates
            }
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.addShadow(CGSize(width: 1, height: 2), UIColor.lightGray, 2, 0.4, 3)
    }
}
