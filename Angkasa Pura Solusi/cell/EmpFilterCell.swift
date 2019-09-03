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
    @IBOutlet weak var labelNama: UILabel!
    @IBOutlet weak var labelUnitName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    var data: ItemEmp? {
        didSet {
            if let item = data {
                labelNama.text = item.emp_name
                labelUnitName.text = item.unit_name
            }
        }
    }
}
