//
//  DateCell.swift
//  Angkasa Pura Solusi
//
//  Created by Arief Zainuri on 22/01/20.
//  Copyright © 2020 Gama Techno. All rights reserved.
//

import UIKit
import JTAppleCalendar

class DateCell: JTAppleCell {

    @IBOutlet weak var viewContainer: UIView!
    @IBOutlet weak var dateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        viewContainer.giveBorder(viewContainer.frame.size.height / 2, 0, "fff")
    }
}
