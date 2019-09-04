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
    
    private var currentPage = 0
    private var totalPage = 0
    private var timer: Timer?
    
    lazy var informationNetworking: InformationNetworking = { return InformationNetworking() }()
    lazy var preference: Preference = { return Preference() }()
    lazy var staticLet: StaticLet = { return StaticLet() }()
    
    // properties
    private var hasNotif = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initBottomNavigation()
        
        checkingNotifForeground()
    }
    
    private func checkingNotifForeground() {
        timer = Timer.scheduledTimer(withTimeInterval: 60.0, repeats: true) { (timer) in
            print("mengulangi mendapatkan data kembali")
            self.currentPage = 0
            self.getNotificationList()
        }
    }
    
    func forceLogout(_ navigationController: UINavigationController) {
        let vc = DialogPreparePresenceController()
        vc.stringDescription = "Session anda berakhir, silahkan login kembali untuk melanjutkan."
        present(PopupViewController(contentController: vc, popupWidth: UIScreen.main.bounds.width), animated: true)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
            self.resetData()
            navigationController.popToRootViewController(animated: true)
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
                self.forceLogout(self.navigationController!)
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
                    if self.selectedIndex == 2 {
                        self.checkHasNotifActive()
                    } else {
                        self.checkHasNotifNonActive()
                    }
                    break
                } else {
                    self.hasNotif = false
                    if self.selectedIndex == 2 {
                        self.checkHasNotifActive()
                    } else {
                        self.checkHasNotifNonActive()
                    }
                }
                
                if index == (listNotification.data?.notification.count)! - 1 {
                    if self.currentPage + 1 < self.totalPage {
                        self.currentPage += 1
                        self.getNotificationList()
                    }
                }
            }
        }
    }
    
    private func checkHasNotifNonActive() {
        if hasNotif {
            setImage("icHasNotifikasiActive", 2)
            setImage("icHasNotifikasiNonActive", 2)
        } else {
            setImage("icNotifikasiActive", 2)
            setImage("icNotifikasiNonActive", 2)
        }
    }
    
    private func checkHasNotifActive() {
        if hasNotif {
            setImage("icNotifikasiNonActive", 2)
            setImage("icHasNotifikasiActive", 2)
        } else {
            setImage("icNotifikasiNonActive", 2)
            setImage("icNotifikasiActive", 2)
        }
    }
    
    private func initBottomNavigation() {
        UITabBar.appearance().tintColor = UIColor.init(rgb: 0x42a5f5).withAlphaComponent(1)
        UITabBar.appearance().backgroundColor = UIColor.init(rgb: 0xffffff)
        tabBar.unselectedItemTintColor = UIColor.lightGray
        
        self.delegate = self
        
        let berandaController = BerandaController()
        berandaController.delegate = self
        let profilController = ProfilController()
        profilController.open = .myProfile
        viewControllers = [berandaController, BeritaController(), NotifikasiController(), profilController]
        
        tabBar.items![0].title = "Beranda"
        setImage("icHomeActive", 0)
        
        tabBar.items![1].title = "Berita"
        //pemanggilan harus 2x agar terlihat efek nya, pemanggilan kedua adalah pemanggilan final
        setImage("icBeritaActive", 1)
        setImage("icBeritaNonActive", 1)
        
        tabBar.items![2].title = "Notifikasi"
        checkHasNotifNonActive()
        
        tabBar.items![3].title = "Profil"
        setImage("icProfileActive", 3)
        setImage("icProfileNonActive", 3)
    }
    
    private func setImage(_ image: String, _ index: Int) {
        tabBar.items![index].image = UIImage(named: image)
    }

}

// protocol init
extension HomeController: BerandaControllerProtocol {
    func buttonSelengkapnyaClick() {
        setImage("icHomeNonActive", 0)
        setImage("icBeritaActive", 1)
        if hasNotif {
            setImage("icHasNotifikasiNonActive", 2)
        } else {
            setImage("icNotifikasiNonActive", 2)
        }
        setImage("icProfileNonActive", 3)
        self.selectedIndex = 1
    }
}

extension HomeController: UITabBarControllerDelegate {
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        if item == (tabBar.items)![0] {
            print("beranda")
            self.selectedIndex = 0
            setImage("icHomeActive", 0)
            setImage("icBeritaNonActive", 1)
            checkHasNotifNonActive()
            setImage("icProfileNonActive", 3)
        } else if item == (tabBar.items)![1] {
            print("berita")
            self.selectedIndex = 1
            setImage("icHomeNonActive", 0)
            setImage("icBeritaActive", 1)
            checkHasNotifNonActive()
            setImage("icProfileNonActive", 3)
        } else if item == (tabBar.items)![2] {
            print("notifikasi")
            self.selectedIndex = 2
            setImage("icHomeNonActive", 0)
            setImage("icBeritaNonActive", 1)
            checkHasNotifActive()
            setImage("icProfileNonActive", 3)
        } else if item == (tabBar.items)![3] {
            print("profil")
            self.selectedIndex = 3
            setImage("icHomeNonActive", 0)
            setImage("icBeritaNonActive", 1)
            checkHasNotifNonActive()
            setImage("icProfileActive", 3)
        }
    }
}
