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
    
    override func viewDidLoad() {
        //do something
    }
    
    func showCustomDialog(_ vc: UIViewController) {
        let popupVc = PopupViewController(contentController: vc, popupWidth: UIScreen.main.bounds.width - 21)
        self.present(popupVc, animated: true)
    }
    
    func showInDevelopmentDialog() {
        let vc = DialogPreparePresenceController()
        vc.stringDescription = "Segera Hadir"
        showCustomDialog(vc)
    }
    
    func generateMenu(savedMenu: Int, action: UIImage?) -> Menu {
        switch savedMenu {
        case 1:
            return Menu(id: 1, image: UIImage(named: "briefcase"), title: "Pengajuan Cuti", action: action)
        case 2:
            return Menu(id: 2, image: UIImage(named: "employee"), title: "Pengajuan Lembur", action: action)
        case 3:
            return Menu(id: 3, image: UIImage(named: "test"), title: "Persetujuan", action: action)
        case 4:
            return Menu(id: 4, image: UIImage(named: "circularClock"), title: "Presensi", action: action)
        case 5:
            return Menu(id: 5, image: UIImage(named: "form"), title: "Presensi List", action: action)
        case 6:
            return Menu(id: 6, image: UIImage(named: "salary"), title: "Slip Gaji", action: action)
        case 7:
            return Menu(id: 7, image: UIImage(named: "seat"), title: "Peminjaman Ruangan", action: action)
        case 8:
            return Menu(id: 8, image: UIImage(named: "group436"), title: "Peminjaman Mobil Dinas", action: action)
        case 9:
            return Menu(id: 9, image: UIImage(named: "group537"), title: "Daftar Karyawan", action: action)
        default:
            return Menu(id: 10, image: UIImage(named: "coporate"), title: "Link Website APS", action: action)
        }
    }
}
