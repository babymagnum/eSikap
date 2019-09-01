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
                
        viewContainer.layer.cornerRadius = 3
        
        DispatchQueue.main.async {
            self.labelIndex.layer.cornerRadius = ((UIScreen.main.bounds.width - 28) * 0.055) / 2
        }
    }
    
    var data: ItemApproval? {
        didSet {
            if let item = data {
                labelIndex.setTitle(item.no, for: .normal)
                labelNama.text = item.emp_name
                labelType.text = item.status_notes
                labelStatus.text = item.status_name
                setIcon(item.status!)
            }
        }
    }
    
    private func setIcon(_ status: String) {
        switch status {
        case "0": imageStatus.image = UIImage(named: "onProgress")
        case "1": imageStatus.image = UIImage(named: "approved")
        default: imageStatus.image = UIImage(named: "rejected")
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.addShadow(CGSize(width: 2, height: 3), UIColor.lightGray, 3, 0.3, 3)
    }
}
