//
//  DaftarCutiCell.swift
//  Angkasa Pura Solusi
//
//  Created by Arief Zainuri on 01/02/20.
//  Copyright © 2020 Gama Techno. All rights reserved.
//

import UIKit

class DaftarCutiCell: UICollectionViewCell {

    @IBOutlet weak var viewContainer: UIView!
    @IBOutlet weak var imageProfile: UIImageView!
    @IBOutlet weak var buttonStatus: UIButton!
    @IBOutlet weak var labelNumber: CustomLabel!
    @IBOutlet weak var labelNama: CustomLabel!
    @IBOutlet weak var labelTypeCuti: CustomLabel!
    @IBOutlet weak var labelDate: CustomLabel!
    @IBOutlet weak var labelTime: CustomLabel!
    @IBOutlet weak var viewImageHeight: NSLayoutConstraint!
    @IBOutlet weak var viewImage: UIView!
    @IBOutlet weak var viewImageWidth: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        imageProfile.giveBorder((UIScreen.main.bounds.width - 32) * 0.135 / 2, 0, "fff")
        buttonStatus.giveBorder(3, 0, "fff")
        viewImageHeight.constant = ((UIScreen.main.bounds.width - 32) * 0.135) + 23
        viewImageWidth.constant = "Submitted".getWidth(fontSize: 9, fontName: "Roboto-Regular.ttf") + 20
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.addShadow(CGSize(width: 1, height: 2), UIColor.lightGray, 2, 0.6, 5)
    }
}
