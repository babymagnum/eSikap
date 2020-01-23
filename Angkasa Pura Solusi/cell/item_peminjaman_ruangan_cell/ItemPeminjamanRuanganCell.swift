//
//  ItemPeminjamanRuanganCell.swift
//  Angkasa Pura Solusi
//
//  Created by Arief Zainuri on 22/01/20.
//  Copyright © 2020 Gama Techno. All rights reserved.
//

import UIKit

class ItemPeminjamanRuanganCell: UICollectionViewCell {

    @IBOutlet weak var viewContainer: UIView!
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var imageRefresh: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        viewContainer.giveBorder(3, 0, "fff")
        imageRefresh.isHidden = true
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.addShadow(CGSize(width: 1, height: 2), UIColor.lightGray, 2, 0.6, 5)
    }
    
    var data: SchedulesRoomDataAgenda? {
        didSet {
            if let _data = data {
                labelTitle.text = _data.title_agenda
            }
        }
    }
}
