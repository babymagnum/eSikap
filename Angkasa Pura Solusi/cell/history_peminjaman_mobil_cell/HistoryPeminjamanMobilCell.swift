//
//  HistoryPeminjamanMobilCell.swift
//  Angkasa Pura Solusi
//
//  Created by Arief Zainuri on 15/01/20.
//  Copyright © 2020 Gama Techno. All rights reserved.
//

import UIKit

class HistoryPeminjamanMobilCell: UICollectionViewCell {

    @IBOutlet weak var viewRoot: UIView!
    @IBOutlet weak var labelTitle: CustomLabel!
    @IBOutlet weak var labelDate: CustomLabel!
    
    lazy var function: PublicFunction = { return PublicFunction() }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        viewRoot.giveBorder(4, 0, "ffffff")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.addShadow(CGSize(width: 1, height: 2), UIColor.lightGray, 2, 0.6, 5)
    }
    
    var data: RequestCarHistoryItem? {
        didSet {
            if let _data = data {
                labelTitle.text = _data.purpose
                labelDate.text = "\(_data.time_use.dropLast(12))"
            }
        }
    }
}
