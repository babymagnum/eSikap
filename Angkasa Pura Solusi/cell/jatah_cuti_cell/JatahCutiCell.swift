//
//  JatahCutiCell.swift
//  Angkasa Pura Solusi
//
//  Created by Arief Zainuri on 06/08/19.
//  Copyright © 2019 Gama Techno. All rights reserved.
//

import UIKit

class JatahCutiCell: UICollectionViewCell {

    @IBOutlet weak var viewContainer: UIView!
    @IBOutlet weak var labelPeriode: UILabel!
    @IBOutlet weak var labelSisaCuti: UILabel!
    @IBOutlet weak var labelKadaluarsa: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        giveBorder(3, 1, "dedede")
    }
    
    var data: ItemQuota? {
        didSet {
            if let item = data {
                labelPeriode.text = item.periode
                labelSisaCuti.text = item.quota
                labelKadaluarsa.text = item.expired
            }
        }
    }

}
