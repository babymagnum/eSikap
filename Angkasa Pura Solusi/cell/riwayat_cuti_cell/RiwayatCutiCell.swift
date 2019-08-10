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
    @IBOutlet weak var labelDate: UILabel!
    @IBOutlet weak var viewInformation: UIView!
    @IBOutlet weak var imageStatus: UIImageView!
    @IBOutlet weak var labelStatus: UILabel!
    @IBOutlet weak var labelKodeCuti: UILabel!
    @IBOutlet weak var labelTypeIjin: UILabel!
    @IBOutlet weak var labelTanggalIjin: UILabel!
    @IBOutlet weak var labelTimeSubmited: UILabel!
    @IBOutlet weak var viewContainerHeight: NSLayoutConstraint!
    @IBOutlet weak var labelDateHeight: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        viewInformation.addShadow(CGSize(width: 1, height: 2), UIColor.lightGray, 2, 0.6, 3)
    }
    
    var data: RiwayatCuti? {
        didSet {
            if let item = data {
                labelStatus.text = item.status
                labelKodeCuti.text = item.kode
                labelTypeIjin.text = item.type
                labelTanggalIjin.text = item.tanggal
                labelDate.text = item.date
                labelTimeSubmited.text = item.time
                self.checkIsSameDate(item.isSameDate!)
            }
        }
    }
    
    private func checkIsSameDate(_ isSameDate: Bool) {
        
        let originalHeight = labelDate.frame.height + 7 + viewInformation.frame.height
        let withoutDateHeight = viewInformation.frame.height
        
        if isSameDate {
            self.labelDateHeight.constant = 0
            self.labelDate.isHidden = true
            self.viewContainerHeight.constant = withoutDateHeight
        } else {
            self.labelDateHeight.constant = 13
            self.labelDate.isHidden = false
            self.viewContainerHeight.constant = originalHeight
        }
    }

}
