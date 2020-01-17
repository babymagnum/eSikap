//
//  HomeController.swift
//  Angkasa Pura Solusi
//
//  Created by Arief Zainuri on 27/07/19.
//  Copyright © 2019 Gama Techno. All rights reserved.
//

import UIKit
import EzPopup

class HomeController: UITabBarController {

    @IBOutlet weak var bottomNavigationBar: UITabBar!
    
    lazy var informationNetworking: InformationNetworking = { return InformationNetworking() }()
    lazy var preference: Preference = { return Preference() }()
    lazy var staticLet: StaticLet = { return StaticLet() }()
    
    // properties
    private var currentPage = 0
    private var totalPage = 0
    private var timer: Timer?
    private var hasNotif = false
    
    // public
    var redirect: String?
    var leave_id: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        checkRedirect()
        
        initBottomNavigation()
        
        getNotificationList()
        
        checkingNotifForeground()
    }
    
    private func checkRedirect() {
        print("check redirect")
        if let redirect = redirect {
            print("redirect not null")
            
            if redirect == "leave_approval" {
//                let vc = DetailPersetujuanCutiController()
//                vc.leave_id = leave_id
                self.navigationController?.pushViewController(PengajuanCutiController(), animated: true)
            } else if redirect == "leave_detail" {
                let vc = DetailCutiController()
                vc.leave_id = leave_id
                vc.title_content = "Detail Cuti"
                self.navigationController?.pushViewController(vc, animated: true)
            } else if redirect == "delegation_leave_detail" {
                let vc = DetailCutiController()
                vc.leave_id = leave_id
                vc.title_content = "Detail Delegasi Cuti"
                self.navigationController?.pushViewController(vc, animated: true)
            } else {
                let vc = DialogPreparePresenceController()
                vc.stringDescription = "Tidak ada detail untuk notifikasi ini"
                self.showCustomDialog(vc)
            }
            return
        }
    }
    
    private func showCustomDialog(_ vc: UIViewController) {
        let popupVc = PopupViewController(contentController: vc, popupWidth: UIScreen.main.bounds.width)
        popupVc.shadowEnabled = false
        self.present(popupVc, animated: true)
    }
    
    private func checkingNotifForeground() {
        timer = Timer.scheduledTimer(withTimeInterval: 60.0, repeats: true) { (timer) in
            self.currentPage = 0
            self.getNotificationList()
        }
    }
    
    func forceLogout() {
        let vc = DialogPreparePresenceController()
        vc.stringDescription = "Session anda berakhir, silahkan login kembali untuk melanjutkan."
        present(PopupViewController(contentController: vc, popupWidth: UIScreen.main.bounds.width), animated: true)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
            self.resetData()
            self.navigationController?.popToRootViewController(animated: true)
        })
    }
    
    func resetData() {
        preference.saveBool(value: false, key: staticLet.IS_LOGIN)
        preference.saveBool(value: false, key: staticLet.IS_SHOW_FIRST_DIALOG)
        preference.saveString(value: "", key: staticLet.TOKEN)
    }
    
    private func getNotificationList() {
        informationNetworking.getNotificationList(page: currentPage) { (error, listNotification, isExpired) in
            if let _ = isExpired {
                self.forceLogout()
                return
            }
            
            if let _ = error {
                self.getNotificationList()
                return
            }
            
            guard let listNotification = listNotification else { return }
            self.totalPage = (listNotification.data?.total_page)!
            
            for (index, notification) in (listNotification.data?.notification.enumerated())! {
                if notification.is_read == "0" {
                    self.hasNotif = true
                    self.setTabbarItem()
                    break
                } else {
                    self.hasNotif = false
                }
                
                if index == (listNotification.data?.notification.count)! - 1 {
                    self.setTabbarItem()
                    
                    if self.currentPage + 1 <= self.totalPage {
                        self.currentPage += 1
                        self.getNotificationList()
                    }
                }
            }
        }
    }
    
    private func checkNotifIcon(isSelected: Bool) -> UIImage {
        if hasNotif {
            if isSelected {
                return UIImage(named: "icHasNotifikasiActive")!
            } else {
                return UIImage(named: "icHasNotifikasiNonActive")!
            }
        } else {
            if isSelected {
                return UIImage(named: "icNotifikasiActive")!
            } else {
                return UIImage(named: "icNotifikasiNonActive")!
            }
        }
    }
    
    private func setTabbarItem() {
        let berandaController = BerandaController()
        berandaController.delegate = self
        let profilController = ProfilController()
        profilController.open = .myProfile
        let beritaController = BeritaController()
        let notifikasiController = NotifikasiController()
        viewControllers = [berandaController, beritaController, notifikasiController, profilController]
        
        berandaController.tabBarItem = UITabBarItem(title: "Beranda", image: UIImage(named: "icHomeNonActive"), selectedImage: UIImage(named: "icHomeActive"))
        beritaController.tabBarItem = UITabBarItem(title: "Berita", image: UIImage(named: "icBeritaNonActive"), selectedImage: UIImage(named: "icBeritaActive"))
        notifikasiController.tabBarItem = UITabBarItem(title: "Notifikasi", image: checkNotifIcon(isSelected: false), selectedImage: checkNotifIcon(isSelected: true))
        profilController.tabBarItem = UITabBarItem(title: "Profil", image: UIImage(named: "icProfileNonActive"), selectedImage: UIImage(named: "icProfileActive"))
        
        setViewControllers(viewControllers, animated: true)
    }
    
    private func initBottomNavigation() {
        UITabBar.appearance().tintColor = UIColor.init(rgb: 0x42a5f5).withAlphaComponent(1)
        UITabBar.appearance().backgroundColor = UIColor.init(rgb: 0xffffff)
        tabBar.unselectedItemTintColor = UIColor.lightGray
        
        self.delegate = self
        
        setTabbarItem()
    }

}

// protocol init
extension HomeController: BerandaControllerProtocol {
    func buttonSelengkapnyaClick() {
        self.selectedIndex = 1
    }
}

extension HomeController: UITabBarControllerDelegate {
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        if item == (tabBar.items)![0] {
        } else if item == (tabBar.items)![1] {
            self.selectedIndex = 1
        } else if item == (tabBar.items)![2] {
            self.selectedIndex = 2
        } else if item == (tabBar.items)![3] {
            self.selectedIndex = 3
        }
    }
}
