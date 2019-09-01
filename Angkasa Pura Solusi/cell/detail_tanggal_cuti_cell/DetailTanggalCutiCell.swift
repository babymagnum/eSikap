//
//  DetailTanggalCutiCell.swift
//  Angkasa Pura Solusi
//
//  Created by Arief Zainuri on 01/09/19.
//  Copyright © 2019 Gama Techno. All rights reserved.
//

import UIKit

class DetailTanggalCutiCell: UICollectionViewCell {

    @IBOutlet weak var viewContainer: UIView!
    @IBOutlet weak var labelTanggal: CustomLabel!
    @IBOutlet weak var labelStatus: CustomLabel!
    @IBOutlet weak var imageStatus: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    var data: ItemDateShow? {
        didSet {
            if let item = data {
                labelTanggal.text = item.date
                labelStatus.text = item.status?.uppercased()
                imageStatus.image = UIImage(named: (item.status?.lowercased())!)
            }
        }
    }
}
