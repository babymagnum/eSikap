//
//  ChangePasswordController.swift
//  Angkasa Pura Solusi
//
//  Created by Arief Zainuri on 04/08/19.
//  Copyright © 2019 Gama Techno. All rights reserved.
//

import UIKit
import SVProgressHUD

class ChangePasswordController: BaseViewController {

    @IBOutlet weak var viewRootTopMargin: NSLayoutConstraint!
    @IBOutlet weak var viewKataSandiLama: UIView!
    @IBOutlet weak var viewKataSandiBaru: UIView!
    @IBOutlet weak var viewUlangiKataSandiBaru: UIView!
    @IBOutlet weak var fieldKataSandiLama: UITextField!
    @IBOutlet weak var fieldKataSandiBaru: UITextField!
    @IBOutlet weak var fieldUlangiKataSandiBaru: UITextField!
    @IBOutlet weak var labelPasswordTidakSama: UILabel!
    @IBOutlet weak var buttonGantiKataSandi: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        function.changeStatusBar(hexCode: 0x42a5f5, view: self.view, opacity: 1)
        
        initView()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle { return .lightContent }
    
    private func initView() {
        checkTopMargin(viewRootTopMargin: viewRootTopMargin)
        viewKataSandiLama.layer.borderWidth = 1
        viewKataSandiLama.layer.borderColor = UIColor.init(rgb: 0xdedede).cgColor
        viewKataSandiLama.layer.cornerRadius = 3
        
        viewKataSandiBaru.layer.borderWidth = 1
        viewKataSandiBaru.layer.borderColor = UIColor.init(rgb: 0xdedede).cgColor
        viewKataSandiBaru.layer.cornerRadius = 3
        
        viewUlangiKataSandiBaru.layer.borderWidth = 1
        viewUlangiKataSandiBaru.layer.borderColor = UIColor.init(rgb: 0xdedede).cgColor
        viewUlangiKataSandiBaru.layer.cornerRadius = 3
        
        buttonGantiKataSandi.layer.cornerRadius = 5
        fieldUlangiKataSandiBaru.addTarget(self, action: #selector(confirmNewPasswordChange(textField:)), for: .editingChanged)
    }
    
    private func changePassword() {
        if fieldKataSandiLama.trim() == "" {
            self.function.showUnderstandDialog(self, "Ooopss", "Kata sandi lama tidak boleh kosong", "Understand")
            return
        }
        
        if fieldKataSandiBaru.trim() == "" {
            self.function.showUnderstandDialog(self, "Ooopss", "Kata sandi baru tidak boleh kosong", "Understand")
            return
        }
        
        if fieldUlangiKataSandiBaru.trim() == "" {
            self.function.showUnderstandDialog(self, "Ooopss", "Ulangi kata sandi baru tidak boleh kosong", "Understand")
            return
        }
        
        SVProgressHUD.show()
        
        authNetworking.changePassword(request: (new_password: fieldKataSandiBaru.trim(), old_password: fieldKataSandiLama.trim())) { (error, isExpired) in
            DispatchQueue.main.async {
                SVProgressHUD.dismiss()
                
                if let _ = isExpired {
                    self.forceLogout(self.navigationController!)
                    return
                }
                
                if let error = error {
                    let vc = DialogPreparePresenceController()
                    vc.stringDescription = error
                    self.showCustomDialog(vc)
                    return
                }
                
                self.function.showUnderstandDialog(self, "Sukses Ganti Password", "", "Understand")
                
                self.fieldKataSandiLama.text = ""
                self.fieldKataSandiBaru.text = ""
                self.fieldUlangiKataSandiBaru.text = ""
            }
        }
    }
}

extension ChangePasswordController {
    @objc func confirmNewPasswordChange(textField: UITextField){
        if fieldKataSandiBaru.text != textField.text {
            labelPasswordTidakSama.isHidden = false
        } else {
            labelPasswordTidakSama.isHidden = true
        }
    }
    
    @IBAction func buttonGantiKataSandi(_ sender: Any) { changePassword() }
    
    @IBAction func backButtonClick(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
}
