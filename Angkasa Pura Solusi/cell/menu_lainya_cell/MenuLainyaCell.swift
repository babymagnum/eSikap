//
//  MenuLainyaCell.swift
//  Angkasa Pura Solusi
//
//  Created by Arief Zainuri on 03/08/19.
//  Copyright © 2019 Gama Techno. All rights reserved.
//

import UIKit

class MenuLainyaCell: UICollectionViewCell {

    @IBOutlet weak var viewRoot: UIView!
    @IBOutlet weak var viewContainer: UIView!
    @IBOutlet weak var iconMenu: UIImageView!
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var iconAction: UIImageView!
    @IBOutlet weak var viewContainerInsideHeight: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        viewContainer.giveBorder(6, 1, "e9e9e9")                
    }
    
    var data: Menu? {
        didSet {
            if let mData = data {
                iconMenu.image = mData.image
                labelTitle.text = mData.title
                if let action = mData.action {
                    self.iconAction.isHidden = false
                    self.iconAction.image = action
                } else {
                    self.iconAction.isHidden = true
                    self.iconAction.image = UIImage(named: "plus-circular")
                }
            }
        }
    }

}
