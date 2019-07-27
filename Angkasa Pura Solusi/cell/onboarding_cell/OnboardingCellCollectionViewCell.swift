//
//  OnboardingCellCollectionViewCell.swift
//  Angkasa Pura Solusi
//
//  Created by Arief Zainuri on 27/07/19.
//  Copyright © 2019 Gama Techno. All rights reserved.
//

import UIKit

class OnboardingCellCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var imageHeight: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        imageHeight.constant = UIScreen.main.bounds.height * 0.4
    }
    
    var onboarding: Onboarding? {
        didSet{
            if let data = onboarding {
                image.image = data.image
                titleLabel.text = data.title
                descriptionLabel.text = data.description
            }
        }
    }

}
