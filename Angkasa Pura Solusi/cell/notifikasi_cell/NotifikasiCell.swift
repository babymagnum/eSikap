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
    
    lazy var function: PublicFunction = {
        let mFunction = PublicFunction()
        return mFunction
    }()
    
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
                
                labelTitle.font = UIFont(name: item.is_read ?? "" == "0" ? "Roboto-Bold" : "Roboto-Regular", size: labelContent.font.pointSize)
                labelTanggal.font = UIFont(name: item.is_read ?? "" == "0" ? "Roboto-Bold" : "Roboto-Medium", size: labelContent.font.pointSize)
                labelContent.font = UIFont(name: item.is_read ?? "" == "0" ? "Roboto-Bold" : "Roboto-Regular", size: labelContent.font.pointSize)
            }
        }
    }
}
