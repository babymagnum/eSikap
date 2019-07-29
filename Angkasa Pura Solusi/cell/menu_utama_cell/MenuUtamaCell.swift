//
//  MenuUtamaCell.swift
//  Angkasa Pura Solusi
//
//  Created by Arief Zainuri on 28/07/19.
//  Copyright © 2019 Gama Techno. All rights reserved.
//

import UIKit

class MenuUtamaCell: UICollectionViewCell {

    @IBOutlet weak var viewContainer: UIView!
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var labelTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        viewContainer.layer.cornerRadius = 6
        viewContainer.layer.borderWidth = 1
        viewContainer.layer.borderColor = UIColor.init(rgb: 0xe9e9e9).cgColor
    }
    
    var data: Menu? {
        didSet {
            if let mData = data {
                icon.image = mData.image
                labelTitle.text = mData.title
            }
        }
    }

}
