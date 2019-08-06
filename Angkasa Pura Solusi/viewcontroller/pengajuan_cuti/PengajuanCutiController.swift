//
//  PengajuanCutiController.swift
//  Angkasa Pura Solusi
//
//  Created by Arief Zainuri on 05/08/19.
//  Copyright © 2019 Gama Techno. All rights reserved.
//

import UIKit
import iOSDropDown

class PengajuanCutiController: BaseViewController {

    //outlet root
    @IBOutlet weak var labelNama: UILabel!
    @IBOutlet weak var labelUnit: UIButton!
    @IBOutlet weak var fieldJenisCuti: DropDown!
    @IBOutlet weak var viewJenisCuti: UIView!
    @IBOutlet weak var viewAlasan: UIView!
    @IBOutlet weak var fieldAlasan: UITextField!
    @IBOutlet weak var viewDelegasi: UIView!
    @IBOutlet weak var fieldDelegasi: UITextField!
    @IBOutlet weak var viewAtasan: UIView!
    @IBOutlet weak var fieldAtasan: UITextField!
    @IBOutlet weak var buttonSimpan: UIButton!
    @IBOutlet weak var buttonSubmit: UIButton!
    @IBOutlet weak var viewRootHeight: NSLayoutConstraint!
    
    //outlet view cuti tahunan
    @IBOutlet weak var viewCutiTahunanHeight: NSLayoutConstraint!
    @IBOutlet weak var viewCutiTahunanTanggal: UIView!
    @IBOutlet weak var viewCutiTahunan: UIView!
    
    //outlet view cuti akademik
    @IBOutlet weak var viewCutiAkademik: UIView!
    @IBOutlet weak var viewCutiAkademikHeight: NSLayoutConstraint!
    @IBOutlet weak var viewTanggalCutiAkademik: UIView!
    
    var defaultViewCutiTahunanHeight: CGFloat = 0
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        defaultViewCutiTahunanHeight = viewCutiTahunanHeight.constant
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        function.changeStatusBar(hexCode: 0x42a5f5, view: self.view, opacity: 1.0)
        
        initView()
        
        dropdownListener()
    }
    
    private func dropdownListener() {
        fieldJenisCuti.optionArray = ["Cuti Sakit", "Cuti Tahunan", "Cuti Akademik"]
        
        fieldJenisCuti.didSelect { (text, index, id) in
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2, execute: {
                if text == "Cuti Tahunan" {
                    self.hideViewCutiAkademik()
                    self.showViewCutiTahunan()
                } else if text == "Cuti Akademik" {
                    self.showViewCutiAkademik()
                    self.hideViewCutiTahunan()
                }
            })
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle { return .lightContent }
    
    private func initView() {
        
        labelUnit.layer.cornerRadius = 5
        
        viewJenisCuti.giveBorder(3, 1, "dedede")
        viewAlasan.giveBorder(3, 1, "dedede")
        viewDelegasi.giveBorder(3, 1, "dedede")
        viewAtasan.giveBorder(3, 1, "dedede")
        
        buttonSimpan.layer.cornerRadius = 5
        buttonSubmit.layer.cornerRadius = 5
        
        //outlet cuti tahunan
        viewCutiTahunanTanggal.giveBorder(3, 1, "dedede")
        viewCutiTahunanHeight.constant = 0
        viewCutiTahunan.isHidden = true
        
        //outlet cuti akademik
        viewTanggalCutiAkademik.giveBorder(3, 1, "dedede")
        viewCutiAkademikHeight.constant = 0
        viewCutiAkademik.isHidden = true
        
        //outlet cuti sakit
        
        //outlet cuti sementara
    }

}

//function for view cuti tahunan
extension PengajuanCutiController {
    private func showViewCutiTahunan() {
        UIView.animate(withDuration: 0.2, animations: {
            self.viewRootHeight.constant += 282
            self.viewCutiTahunanHeight.constant = 282
            self.viewCutiTahunan.isHidden = false
            self.view.layoutIfNeeded()
        })
    }
    
    private func getViewCutiTahunanHeight() {
        
    }
    
    private func hideViewCutiTahunan() {
        UIView.animate(withDuration: 0.2, animations: {
            self.viewRootHeight.constant -= 282
            self.viewCutiTahunanHeight.constant = 0
            self.viewCutiTahunan.isHidden = true
            self.view.layoutIfNeeded()
        })
    }
}

//function for view cuti akademik
extension PengajuanCutiController {
    private func showViewCutiAkademik() {
        UIView.animate(withDuration: 0.2) {
            self.viewRootHeight.constant += 66
            self.viewCutiAkademikHeight.constant = 66
            self.viewCutiAkademik.isHidden = false
            self.view.layoutIfNeeded()
        }
    }
    
    private func hideViewCutiAkademik() {
        UIView.animate(withDuration: 0.2) {
            self.viewRootHeight.constant -= 66
            self.viewCutiAkademikHeight.constant = 0
            self.viewCutiAkademik.isHidden = true
            self.view.layoutIfNeeded()
        }
    }
}

//click event
extension PengajuanCutiController {
    @IBAction func buttonSubmitClick(_ sender: Any) {
    }
    @IBAction func buttonSimpanClick(_ sender: Any) {
    }
    @IBAction func buttonBackClick(_ sender: Any) {
    }
}
