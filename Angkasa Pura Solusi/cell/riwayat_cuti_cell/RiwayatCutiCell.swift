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
    @IBOutlet weak var viewInformationHeight: NSLayoutConstraint!
    
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
        let informationHeight = labelKodeCuti.getHeight(width: labelKodeCuti.frame.width) + labelTypeIjin.getHeight(width: labelTypeIjin.frame.width) + labelTanggalIjin.getHeight(width: labelTanggalIjin.frame.width) + 6.2 + 7.8 + 1.6 + 7.8
        let originalHeight = 22 + informationHeight
        
        viewInformationHeight.constant = informationHeight
        
        if isSameDate {
            self.labelDateHeight.constant = 0
            self.labelDate.isHidden = true
            self.viewContainerHeight.constant = informationHeight
        } else {
            self.labelDateHeight.constant = 15
            self.labelDate.isHidden = false
            self.viewContainerHeight.constant = originalHeight
        }
    }

}
