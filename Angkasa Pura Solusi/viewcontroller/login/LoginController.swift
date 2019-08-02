//
//  LoginController.swift
//  Angkasa Pura Solusi
//
//  Created by Arief Zainuri on 27/07/19.
//  Copyright © 2019 Gama Techno. All rights reserved.
//

import UIKit
import SVProgressHUD

class LoginController: BaseViewController {

    @IBOutlet weak var imageTopHeight: NSLayoutConstraint!
    @IBOutlet weak var viewTopHeight: NSLayoutConstraint!
    @IBOutlet weak var viewInputEmail: UIView!
    @IBOutlet weak var viewInputPassword: UIView!
    @IBOutlet weak var textFieldEmail: UITextField!
    @IBOutlet weak var textFieldPassword: UITextField!
    @IBOutlet weak var buttonMasuk: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initView()
    }

    private func initView() {
        buttonMasuk.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(buttonMasukClick)))
        textFieldEmail.delegate = self
        textFieldPassword.delegate = self
        buttonMasuk.layer.cornerRadius = buttonMasuk.frame.height / 2
        viewInputEmail.layer.cornerRadius = viewInputEmail.frame.height / 2
        viewInputPassword.layer.cornerRadius = viewInputPassword.frame.height / 2
        viewInputEmail.layer.borderWidth = 1
        viewInputPassword.layer.borderWidth = 1
        viewInputEmail.layer.borderColor = UIColor.init(rgb: 0xdedede).cgColor
        viewInputPassword.layer.borderColor = UIColor.init(rgb: 0xdedede).cgColor
        viewTopHeight.constant = UIScreen.main.bounds.height / 2
        imageTopHeight.constant = UIScreen.main.bounds.height * 0.7
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle { return .lightContent }
}

extension LoginController {
    @objc func buttonMasukClick() {
        if textFieldEmail.text?.trim() == "" {
            self.function.showUnderstandDialog(self, "Username/email Empty", "Please fill username/email first.", "Understand")
            return
        }
        
        if textFieldPassword.text?.trim() == "" {
            self.function.showUnderstandDialog(self, "Password Empty", "Please fill password first", "Understand")
            return
        }
        
        SVProgressHUD.show()
        
        authNetworking.login((textFieldEmail.text?.trim())!, (textFieldPassword.text?.trim())!) { (message) in
            
            SVProgressHUD.dismiss()
            
            if message != nil {
                self.function.showUnderstandDialog(self, "Login Error", message!, "Understand")
            } else {
                //login success
                self.preference.saveBool(value: true, key: self.staticLet.IS_LOGIN)
                self.present(HomeController(), animated: true)
            }
            
        }
    }
}

extension LoginController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == textFieldEmail {
            textFieldPassword.becomeFirstResponder()
        } else if textField == textFieldPassword {
            textFieldPassword.resignFirstResponder()
        }
        
        return true
    }
}
