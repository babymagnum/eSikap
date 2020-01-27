//
//  DetailPengajuanRealisasiLembur.swift
//  Angkasa Pura Solusi
//
//  Created by Arief Zainuri on 28/01/20.
//  Copyright © 2020 Gama Techno. All rights reserved.
//

import UIKit

class DetailPengajuanRealisasiLembur: BaseViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var constraintViewRoot: NSLayoutConstraint!
    @IBOutlet weak var constraintTopLabelFilePendukung: NSLayoutConstraint!
    @IBOutlet weak var labelFilePendukung: CustomLabel!
    @IBOutlet weak var labelNumber: CustomLabel!
    @IBOutlet weak var imageProfile: UIImageView!
    @IBOutlet weak var labelDate: CustomLabel!
    @IBOutlet weak var labelNama: CustomLabel!
    @IBOutlet weak var labelUnitKerja: CustomLabel!
    @IBOutlet weak var labelKeterangan: CustomLabel!
    @IBOutlet weak var collectionTanggalLembur: UICollectionView!
    @IBOutlet weak var collectionTanggalLemburHeight: NSLayoutConstraint!
    @IBOutlet weak var viewKeteranganRealisasi: UIView!
    @IBOutlet weak var textviewKeteranganRealisasi: CustomTextView!
    @IBOutlet weak var viewFilePendukung: UIView!
    @IBOutlet weak var buttonSubmit: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initView()
        
        initEvent()
    }
    
    private func initEvent() {
        
    }

    private func initView() {
        checkTopMargin(viewRootTopMargin: constraintViewRoot)
        function.changeStatusBar(hexCode: 0x42a5f5, view: self.view, opacity: 1)
        
        labelFilePendukung.text = ""
        scrollView.resizeScrollViewContentSize()
        self.view.layoutIfNeeded()
        
        viewFilePendukung.giveBorder(3, 1, "dedede")
        viewKeteranganRealisasi.giveBorder(3, 1, "dedede")
        
        scrollView.alpha = 0
        imageProfile.clipsToBounds = true
        imageProfile.layer.cornerRadius = (UIScreen.main.bounds.width * 0.15) / 2
    }
}

extension DetailPengajuanRealisasiLembur {
    @IBAction func buttonSubmitClick(_ sender: Any) {
    }
    
    @IBAction func buttonBackClick(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}
