//
//  EmpFilterCell.swift
//  Angkasa Pura Solusi
//
//  Created by Arief Zainuri on 03/09/19.
//  Copyright © 2019 Gama Techno. All rights reserved.
//

import UIKit

class EmpFilterCell: UICollectionViewCell {

    @IBOutlet weak var viewContainer: UIView!
    @IBOutlet weak var labelNIK: UILabel!
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var labelUnitName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        viewContainer.clipsToBounds = true
        viewContainer.layer.cornerRadius = 5
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.addShadow(CGSize(width: 2, height: 3), UIColor.lightGray, 3, 0.4, 5)
    }

    var data: ItemEmp? {
        didSet {
            if let item = data {
                labelName.text = item.emp_name
                labelUnitName.text = item.unit_name
                labelNIK.text = item.emp_nik
            }
        }
    }
}
