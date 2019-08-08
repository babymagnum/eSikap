//
//  KaryawanCell.swift
//  Angkasa Pura Solusi
//
//  Created by Arief Zainuri on 05/08/19.
//  Copyright © 2019 Gama Techno. All rights reserved.
//

import UIKit

class KaryawanCell: UICollectionViewCell {

    @IBOutlet weak var viewContainer: UIView!
    @IBOutlet weak var imageAccount: UIImageView!
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var labelJabatan: UILabel!
    @IBOutlet weak var labelPosition: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        initView()
    }
    
    private func initView() {
        imageAccount.layer.cornerRadius = imageAccount.frame.height / 2
        
        viewContainer.clipsToBounds = true
        viewContainer.layer.cornerRadius = 5
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.addShadow(CGSize(width: 1, height: 2), UIColor.lightGray, 2, 0.6, 5)
    }
    
    var data: ItemKaryawan? {
        didSet {
            if let karyawan = data {
                self.imageAccount.loadUrl(karyawan.img!)
                self.labelName.text = karyawan.emp_name
                self.labelJabatan.text = karyawan.position
                self.labelPosition.text = karyawan.unit
            }
        }
    }

}
