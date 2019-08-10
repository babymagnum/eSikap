//
//  StatusPersetujuanCell.swift
//  Angkasa Pura Solusi
//
//  Created by Arief Zainuri on 10/08/19.
//  Copyright © 2019 Gama Techno. All rights reserved.
//

import UIKit

class StatusPersetujuanCell: UICollectionViewCell {

    @IBOutlet weak var viewContainer: UIView!
    @IBOutlet weak var labelIndex: UIButton!
    @IBOutlet weak var labelNama: UILabel!
    @IBOutlet weak var labelType: UILabel!
    @IBOutlet weak var imageStatus: UIImageView!
    @IBOutlet weak var labelStatus: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        labelIndex.layer.cornerRadius = labelIndex.frame.height / 2
        viewContainer.layer.cornerRadius = 3
    }
    
    var data: StatusPersetujuan? {
        didSet {
            if let item = data {
                labelIndex.setTitle(item.index, for: .normal)
                labelNama.text = item.nama
                labelType.text = item.type
                labelStatus.text = item.status
            }
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.addShadow(CGSize(width: 1, height: 2), UIColor.lightGray, 2, 0.6, 3)
    }
}
