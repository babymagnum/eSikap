//
//  StatusActionCell.swift
//  Angkasa Pura Solusi
//
//  Created by Arief Zainuri on 10/08/19.
//  Copyright © 2019 Gama Techno. All rights reserved.
//

import UIKit

class StatusActionCell: UICollectionViewCell {

    @IBOutlet weak var switchStatusHeight: NSLayoutConstraint!
    @IBOutlet weak var viewContainer: UIView!
    @IBOutlet weak var labelDate: UILabel!
    @IBOutlet weak var labelStatus: UILabel!
    @IBOutlet weak var switchStatus: UISwitch!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    var data: StatusAction? {
        didSet {
            if let item = data {
                switchStatus.setOn(item.isApproved!, animated: true)
                labelDate.text = item.date
                if item.isApproved! {
                    self.labelStatus.text = "APPROVED"
                } else {
                    self.labelStatus.text = "REJECTED"
                }
            }
        }
    }

}
