//
//  HomeController.swift
//  Angkasa Pura Solusi
//
//  Created by Arief Zainuri on 27/07/19.
//  Copyright © 2019 Gama Techno. All rights reserved.
//

import UIKit

class HomeController: UITabBarController {

    @IBOutlet weak var bottomNavigationBar: UITabBar!
    
    // properties
    private var hasNotif = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initBottomNavigation()
    }
    
    private func initBottomNavigation() {
        UITabBar.appearance().tintColor = UIColor.init(rgb: 0x42a5f5).withAlphaComponent(1)
        UITabBar.appearance().backgroundColor = UIColor.init(rgb: 0xffffff)
        tabBar.unselectedItemTintColor = UIColor.lightGray
        
        self.delegate = self
        
        self.selectedIndex = 0
        
        let berandaController = BerandaController()
        berandaController.delegate = self
        let profilController = ProfilController()
        profilController.open = .myProfile
        viewControllers = [berandaController, BeritaController(), NotifikasiController(), profilController]
        
        tabBar.items![0].title = "Beranda"
        setImage("icHomeActive", 0)
        
        tabBar.items![1].title = "Berita"
        setImage("icBeritaActive", 1)
        setImage("icBeritaNonActive", 1)
        
        tabBar.items![2].title = "Notifikasi"
        if hasNotif {
            setImage("icHasNotifikasiActive", 2)
            setImage("icHasNotifikasiNonActive", 2)
        } else {
            setImage("icNotifikasiActive", 2)
            setImage("icNotifikasiNonActive", 2)
        }
        
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
            setImage("icHomeActive", 0)
            setImage("icBeritaNonActive", 1)
            if hasNotif {
                setImage("icHasNotifikasiNonActive", 2)
            } else {
                setImage("icNotifikasiNonActive", 2)
            }
            setImage("icProfileNonActive", 3)
        } else if item == (tabBar.items)![1] {
            print("berita")
            setImage("icHomeNonActive", 0)
            setImage("icBeritaActive", 1)
            if hasNotif {
                setImage("icHasNotifikasiNonActive", 2)
            } else {
                setImage("icNotifikasiNonActive", 2)
            }
            setImage("icProfileNonActive", 3)
        } else if item == (tabBar.items)![2] {
            print("notifikasi")
            setImage("icHomeNonActive", 0)
            setImage("icBeritaNonActive", 1)
            if hasNotif {
                setImage("icHasNotifikasiActive", 2)
            } else {
                setImage("icNotifikasiActive", 2)
            }
            setImage("icProfileNonActive", 3)
        } else if item == (tabBar.items)![3] {
            print("profil")
            setImage("icHomeNonActive", 0)
            setImage("icBeritaNonActive", 1)
            if hasNotif {
                setImage("icHasNotifikasiNonActive", 2)
            } else {
                setImage("icNotifikasiNonActive", 2)
            }
            setImage("icProfileActive", 3)
        }
    }
}
