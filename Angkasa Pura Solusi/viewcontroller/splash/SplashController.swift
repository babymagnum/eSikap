//
//  SplashController.swift
//  Angkasa Pura Solusi
//
//  Created by Arief Zainuri on 27/07/19.
//  Copyright © 2019 Gama Techno. All rights reserved.
//

import UIKit

class SplashController: BaseViewController {

    @IBOutlet weak var viewBotHeight: NSLayoutConstraint!
    @IBOutlet weak var imageBotHeight: NSLayoutConstraint!
    @IBOutlet weak var imageBotWidth: NSLayoutConstraint!
    @IBOutlet weak var imageTopHeight: NSLayoutConstraint!
    @IBOutlet weak var imageTopWidth: NSLayoutConstraint!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        preference.saveBool(value: false, key: staticLet.IS_RELEASE)
        
        preference.saveBool(value: false, key: staticLet.IS_SHOW_FIRST_DIALOG)
        
        initView()
        
        checkVersion()
    }
    
    private func checkVersion() {
        informationNetworking.checkVersion { (error, checkVersion, _) in
            if let _ = error {
                self.function.showUnderstandDialog(self, "eSIKAP", "Gagal mendapatkan versi aplikasi terbaru.", "Reload") {
                    self.checkVersion()
                }
                return
            }
            
            guard let _data = checkVersion?.data else { return }
            
            print("message \(_data.current_version ?? "")")
            
            if (_data.must_update ?? false) {
                let vc = DialogCheckUpdate()
                self.showCustomDialog(vc, UIScreen.main.bounds.height, cancelable: false)
            } else {
                self.changeScreen()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle { return .lightContent }
    
    private func changeScreen() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            if !self.preference.getBool(key: self.staticLet.IS_FIRST_TIME_OPEN) {
                self.navigationController?.pushViewController(OnboardingController(), animated: true)
            } else if !self.preference.getBool(key: self.staticLet.IS_LOGIN) {
                self.navigationController?.pushViewController(LoginController(), animated: true)
            } else {
                self.navigationController?.pushViewController(HomeController(), animated: true)
            }
        }
    }
    
    private func initView() {
        let widthScreen = UIScreen.main.bounds.width
        let heightScreen = UIScreen.main.bounds.height
        
        imageTopWidth.constant = widthScreen
        imageTopHeight.constant = heightScreen * 0.7
        imageBotHeight.constant = heightScreen * 0.7
        imageBotWidth.constant = widthScreen
        viewBotHeight.constant = heightScreen / 2
    }

}
