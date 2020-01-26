//
//  BaseViewController.swift
//  Angkasa Pura Solusi
//
//  Created by Arief Zainuri on 27/07/19.
//  Copyright © 2019 Gama Techno. All rights reserved.
//

import Foundation
import UIKit
import EzPopup

class BaseViewController: UIViewController {
    
    lazy var imagePicker: ImagePickerManager = { return ImagePickerManager() }()
    
    lazy var preference: Preference = {
        let mPreference = Preference()
        return mPreference
    }()
    
    lazy var staticLet: StaticLet = {
        let mStaticLet = StaticLet()
        return mStaticLet
    }()
    
    lazy var function: PublicFunction = {
        let mFunction = PublicFunction()
        return mFunction
    }()
    
    lazy var authNetworking: AuthenticationNetworking = {
        let mAuthNetworking = AuthenticationNetworking()
        return mAuthNetworking
    }()
    
    lazy var presenceNetworking: PresenceNetworking = {
        let mPresenceNetworking = PresenceNetworking()
        return mPresenceNetworking
    }()
    
    lazy var informationNetworking: InformationNetworking = {
        let mInformationNetworking = InformationNetworking()
        return mInformationNetworking
    }()
    
    lazy var perizinanNetworking: PerizinanNetworking = {
        let mPerizinanNetworking = PerizinanNetworking()
        return mPerizinanNetworking
    }()
    
    override func viewDidLoad() {
        //do something
    }
    
    func checkTopMargin(viewRootTopMargin: NSLayoutConstraint) {
        if #available(iOS 11, *) {
            viewRootTopMargin.constant += 0
        } else {
            viewRootTopMargin.constant += UIApplication.shared.statusBarFrame.height
        }
    }
    
    func checkRootHeight(viewRootHeight: NSLayoutConstraint, _ additionHeight: CGFloat, addHeightFor11Above: Bool, addHeightFor11Below: Bool) {
        if #available(iOS 11, *) {
            viewRootHeight.constant += addHeightFor11Above ? additionHeight : 0
        } else {
            viewRootHeight.constant += addHeightFor11Below ? 45 + additionHeight : additionHeight
        }
    }
    
    func addMoreRootHeight(viewRootHeight: NSLayoutConstraint, _ additionHeight: CGFloat) {
        if (UIScreen.main.bounds.width == 320) {
            viewRootHeight.constant += additionHeight + 5
        } else if (UIScreen.main.bounds.width == 375) {
            viewRootHeight.constant += additionHeight + 6
        } else if (UIScreen.main.bounds.width == 414) {
            viewRootHeight.constant += additionHeight + 7
        } else {
            viewRootHeight.constant += additionHeight + 8
        }
    }
    
    func showCustomDialog(_ vc: UIViewController) {
        let popupVc = PopupViewController(contentController: vc, popupWidth: UIScreen.main.bounds.width)
        popupVc.shadowEnabled = false
        self.present(popupVc, animated: true)
    }
    
    func showCustomDialog(_ vc: UIViewController, _ height: CGFloat) {
        let popupVc = PopupViewController(contentController: vc, popupWidth: UIScreen.main.bounds.width, popupHeight: height)
        self.present(popupVc, animated: true)
    }
    
    func forceLogout(_ navigationController: UINavigationController) {
        DispatchQueue.main.async {
            let vc = DialogPreparePresenceController()
            vc.stringDescription = "Session anda berakhir, silahkan login kembali untuk melanjutkan."
            self.showCustomDialog(vc)
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
            self.resetData()
            navigationController.popToRootViewController(animated: true)
        })
    }
    
    func showInDevelopmentDialog() {
        let vc = DialogPreparePresenceController()
        vc.stringDescription = "Segera Hadir"
        vc.image = "exception"
        showCustomDialog(vc)
    }
    
    func resetData() {
        preference.saveBool(value: false, key: staticLet.IS_LOGIN)
        preference.saveBool(value: false, key: staticLet.IS_SHOW_FIRST_DIALOG)
        preference.saveString(value: "", key: staticLet.TOKEN)
    }
    
    func generateMenu(savedMenu: String, action: UIImage?) -> Menu {
        switch savedMenu {
        case "menuCuti":
            return Menu(id: "menuCuti", image: UIImage(named: "briefcase"), title: "Pengajuan Cuti", action: action)
        case "menuLembur":
            return Menu(id: "menuLembur", image: UIImage(named: "employee"), title: "Pengajuan Lembur", action: action)
        case "menuPersetujuan":
            return Menu(id: "menuPersetujuan", image: UIImage(named: "test"), title: "Persetujuan", action: action)
        case "menuPresensi":
            return Menu(id: "menuPresensi", image: UIImage(named: "circularClock"), title: "Presensi", action: action)
        case "menuDaftarPresensi":
            return Menu(id: "menuDaftarPresensi", image: UIImage(named: "form"), title: "Daftar Presensi", action: action)
        case "menuUpah":
            return Menu(id: "menuUpah", image: UIImage(named: "salary"), title: "Upah", action: action)
        case "menuRuang":
            return Menu(id: "menuRuang", image: UIImage(named: "seat"), title: "Peminjaman Ruangan", action: action)
        case "menuMobil":
            return Menu(id: "menuMobil", image: UIImage(named: "group436"), title: "Peminjaman Mobil Dinas", action: action)
        case "menuKaryawan":
            return Menu(id: "menuKaryawan", image: UIImage(named: "group537"), title: "Daftar Karyawan", action: action)
        case "menuLink":
            return Menu(id: "menuLink", image: UIImage(named: "coporate"), title: "Link Website APS", action: action)
        case "menuKebijakan":
            return Menu(id: "menuKebijakan", image: UIImage(named: "group_632"), title: "Kebijakan & Peraturan", action: action)
        case "menuDaftarCuti":
            return Menu(id: "menuDaftarCuti", image: UIImage(named: "delivery_1"), title: "Daftar Cuti", action: action)
        default:
            return Menu()
        }
    }
}
