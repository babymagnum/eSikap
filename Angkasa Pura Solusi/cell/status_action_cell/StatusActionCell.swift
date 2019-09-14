//
//  StatusActionCell.swift
//  Angkasa Pura Solusi
//
//  Created by Arief Zainuri on 10/08/19.
//  Copyright © 2019 Gama Techno. All rights reserved.
//

import UIKit

protocol StatusActionCellProtocol {
    func switchChange(status: String, position: Int)
}

class StatusActionCell: UICollectionViewCell {

    lazy var function: PublicFunction = { return PublicFunction() }()
    
    @IBOutlet weak var switchStatusHeight: NSLayoutConstraint!
    @IBOutlet weak var viewContainer: UIView!
    @IBOutlet weak var labelDate: UILabel!
    @IBOutlet weak var labelStatus: UILabel!
    @IBOutlet weak var switchStatus: UISwitch!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        switchStatus.addTarget(self, action: #selector(switchStatusChange), for: UIControl.Event.valueChanged)
    }
    
    @objc func switchStatusChange(mySwitch: UISwitch) {
        guard let position = position else { return }
        if mySwitch.isOn {
            delegate.switchChange(status: "1", position: position)
        } else {
            delegate.switchChange(status: "0", position: position)
        }
    }
    
    var position: Int?
    var delegate: StatusActionCellProtocol!
    
    var data: StatusAction? {
        didSet {
            if let item = data {
                switchStatus.setOn(item.isApproved == "1" ? true : false, animated: true)
                labelDate.text = function.dateToString(function.stringToDate(item.date!, "yyyy-MM-dd"), "dd-MM-yyyy")
                if item.isApproved == "1" {
                    self.labelStatus.text = "APPROVED"
                } else {
                    self.labelStatus.text = "REJECTED"
                }
            }
        }
    }

}
