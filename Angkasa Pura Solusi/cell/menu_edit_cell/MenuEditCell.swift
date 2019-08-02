//
//  MenuEditCell.swift
//  Angkasa Pura Solusi
//
//  Created by Arief Zainuri on 02/08/19.
//  Copyright © 2019 Gama Techno. All rights reserved.
//

import UIKit

class MenuEditCell: UICollectionViewCell {

    @IBOutlet weak var viewRoot: UIView!
    @IBOutlet weak var viewContainer: UIView!
    @IBOutlet weak var iconMenu: UIImageView!
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var iconAction: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        viewContainer.layer.cornerRadius = 6
        viewContainer.layer.borderWidth = 1
        viewContainer.layer.borderColor = UIColor.init(rgb: 0xe9e9e9).cgColor
    }

    var data: Menu? {
        didSet {
            if let mData = data {
                iconMenu.image = mData.image
                labelTitle.text = mData.title
            }
        }
    }
}
