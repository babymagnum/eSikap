//
//  InformasiPersetujuanCell.swift
//  Angkasa Pura Solusi
//
//  Created by Arief Zainuri on 16/01/20.
//  Copyright © 2020 Gama Techno. All rights reserved.
//

import UIKit

class InformasiPersetujuanCell: UICollectionViewCell {

    @IBOutlet weak var labelNama: UILabel!
    @IBOutlet weak var labelStatus: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    var data: DetailRequestCarApprovalItem? {
        didSet {
            if let _data = data {
                labelNama.text = _data.emp_name
                labelStatus.text = data?.status
                labelStatus.textColor = UIColor(hexString: "\(data?.status_color.dropFirst() ?? "9ccc65")")
            }
        }
    }
}
