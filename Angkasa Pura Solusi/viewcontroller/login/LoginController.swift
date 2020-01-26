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
    
    private var counter = 0;
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initView()
        
        initEvent()
    }
    
    private func initEvent() {
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(viewClick)))
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
    
    override var preferredStatusBarStyle: UIStatusBarStyle { return .default }
}

extension LoginController {
    @objc func viewClick() {
        counter += 1
        
        if counter == 20 {
            counter = 0
            
            if preference.getBool(key: staticLet.IS_RELEASE) {
                preference.saveBool(value: false, key: staticLet.IS_RELEASE)
                function.showUnderstandDialog(self, "APS ESS", "You're in development mode", "Understand")
            } else {
                preference.saveBool(value: true, key: staticLet.IS_RELEASE)
                function.showUnderstandDialog(self, "APS ESS", "You're in production mode", "Understand")
            }
                        
        }
    }
    
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
                self.preference.saveInt(value: 0, key: self.staticLet.JUMLAH_MENU)
                let vc = HomeController()
                
                DispatchQueue.main.async {
                    self.navigationController?.pushViewController(vc, animated: true)
                }
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
