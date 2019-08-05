//
//  ProfilController.swift
//  Angkasa Pura Solusi
//
//  Created by Arief Zainuri on 28/07/19.
//  Copyright © 2019 Gama Techno. All rights reserved.
//

import UIKit
import SVProgressHUD

enum WhichKaryawan {
    case myProfile
    case otherProfile
}

class ProfilController: BaseViewController {

    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var imageAccount: UIImageView!
    @IBOutlet weak var labelNama: UILabel!
    @IBOutlet weak var labelJabatan: UILabel!
    @IBOutlet weak var labelDivisi: UILabel!
    @IBOutlet weak var labelNIKValue: UILabel!
    @IBOutlet weak var labelLokasiKerja: UILabel!
    @IBOutlet weak var labelEmail: UILabel!
    @IBOutlet weak var labelTelepon: UILabel!
    @IBOutlet weak var viewContainerInformation: UIView!
    @IBOutlet weak var viewContainerAction: UIView!
    @IBOutlet weak var viewUbahKataSandi: UIView!
    @IBOutlet weak var viewKeluar: UIView!
    @IBOutlet weak var viewRootAction: UIView!
    @IBOutlet weak var viewRootInformation: UIView!
    @IBOutlet weak var buttonBackWidth: NSLayoutConstraint!
    @IBOutlet weak var labelTitleMarginStart: NSLayoutConstraint!
    
    var open: WhichKaryawan?
    var empId: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        function.changeStatusBar(hexCode: 0x42a5f5, view: self.view, opacity: 1)
        
        initView()
        
        clickEvent()
        
        if open == .myProfile {
            buttonBackWidth.constant = 0
            labelTitleMarginStart.constant = 14
            labelTitle.text = "Profil"
            getProfile()
        } else {
            viewRootAction.isHidden = true
            labelTitleMarginStart.constant = -12
            labelTitle.text = "Karyawan"
            getKaryawanProfil()
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle { return .lightContent }
    
    private func clickEvent() {
        viewUbahKataSandi.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(viewUbahKataSandiClick)))
        
        viewKeluar.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(viewKeluarClick)))
    }
    
    private func initView() {
        imageAccount.clipsToBounds = true
        imageAccount.layer.cornerRadius = imageAccount.frame.height / 2
        
        viewContainerInformation.clipsToBounds = true
        viewContainerInformation.layer.cornerRadius = 5
        
        viewContainerAction.clipsToBounds = true
        viewContainerAction.layer.cornerRadius = 5
        
        viewRootInformation.addShadow(CGSize(width: 1, height: 2), UIColor.lightGray, 2, 1)
        viewRootAction.addShadow(CGSize(width: 1, height: 2), UIColor.lightGray, 2, 1)
    }
    
    private func setView(_ item: ItemProfile) {
        imageAccount.loadUrl(item.img!)
        labelNama.text = item.emp_name
        labelJabatan.text = item.position
        labelDivisi.text = item.unit
        labelNIKValue.text = item.nik
        labelLokasiKerja.text = item.workarea
        labelEmail.text = item.email
        labelTelepon.text = item.phone
    }
    
    private func setKaryawanView(_ item: ItemDetailKaryawan) {
        imageAccount.loadUrl(item.img!)
        labelNama.text = item.emp_name
        labelJabatan.text = item.position
        labelDivisi.text = item.unit
        labelNIKValue.text = item.nik
        labelLokasiKerja.text = item.workarea
        labelEmail.text = item.email
        labelTelepon.text = item.phone
    }
    
    private func getKaryawanProfil() {
        SVProgressHUD.show()
        informationNetworking.getProfileByEmpId(empId: empId ?? "") { (error, itemDetailKaryawan) in
            
            SVProgressHUD.dismiss()
            
            if let error = error {
                self.function.showUnderstandDialog(self, "Gagal Mendapatkan Data Karyawan", error, "Reload", "Cancel", completionHandler: {
                    self.getKaryawanProfil()
                })
            }
            
            guard let item = itemDetailKaryawan else { return }
            
            self.setKaryawanView(item)
        }
    }
    
    private func getProfile() {
        SVProgressHUD.show()
        informationNetworking.getProfile { (error, itemProfile) in
            SVProgressHUD.dismiss()
            if let error = error {
                self.function.showUnderstandDialog(self, "Error Geting Profile Data", error, "Retry", completionHandler: {
                    self.getProfile()
                })
                return
            }
            
            guard let item = itemProfile else { return }
            
            self.setView(item)
        }
    }

}

extension ProfilController {
    @IBAction func buttonBackClick(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func viewKeluarClick() {
        
    }
    
    @objc func viewUbahKataSandiClick() {
        navigationController?.pushViewController(ChangePasswordController(), animated: true)
    }
}
