//
//  RiwayatCutiCell.swift
//  Angkasa Pura Solusi
//
//  Created by Arief Zainuri on 10/08/19.
//  Copyright © 2019 Gama Techno. All rights reserved.
//

import UIKit

class RiwayatCutiCell: UICollectionViewCell {

    @IBOutlet weak var viewContainer: UIView!
    @IBOutlet weak var imageStatus: UIImageView!
    @IBOutlet weak var labelStatus: UILabel!
    @IBOutlet weak var labelKodeCuti: UILabel!
    @IBOutlet weak var labelTypeIjin: UILabel!
    @IBOutlet weak var imageStatusTopMargin: NSLayoutConstraint!
    @IBOutlet weak var labelTanggalIjin: UILabel!
    @IBOutlet weak var labelTimeSubmited: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        viewContainer.clipsToBounds = true
        viewContainer.layer.cornerRadius = 5
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.addShadow(CGSize(width: 2, height: 3), UIColor.lightGray, 3, 0.3, 5)
    }
    
    var data: ItemRiwayatCuti? {
        didSet {
            if let item = data {
                labelStatus.text = item.status
                labelKodeCuti.text = item.number
                labelTypeIjin.text = item.type_name
                imageStatus.image = UIImage(named: item.status_icon!)
                labelTanggalIjin.text = item.dates
            }
        }
    }

}
