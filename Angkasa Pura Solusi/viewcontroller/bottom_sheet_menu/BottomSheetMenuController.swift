//
//  BottomSheetMenuController.swift
//  Angkasa Pura Solusi
//
//  Created by Arief Zainuri on 02/08/19.
//  Copyright © 2019 Gama Techno. All rights reserved.
//

import UIKit
import SVProgressHUD

class BottomSheetMenuController: BaseViewController, UICollectionViewDelegate {
    
    @IBOutlet weak var buttonUbah: UIButton!
    @IBOutlet weak var menuFavoritCollectionView: UICollectionView!
    @IBOutlet weak var menuLainyaCollectionView: UICollectionView!
    @IBOutlet weak var menuFavoritCollectionViewHeight: NSLayoutConstraint!
    @IBOutlet weak var menuLainyaCollectionViewHeight: NSLayoutConstraint!
    @IBOutlet weak var favoritCollectionRightMargin: NSLayoutConstraint!
    @IBOutlet weak var lainyaCollectionRightMargin: NSLayoutConstraint!
    @IBOutlet weak var viewRootHeight: NSLayoutConstraint!
    
    var listMenuFavorit = [Menu]()
    var listMenuLainya = [Menu]()
    var isEdit = false
    var parentNavigationController: UINavigationController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initView()
        
        initCollectionView()
        
        loadMenu()
    }
    
    private func loadMenu() {
        // append list menu favorit
        listMenuFavorit.append(generateMenu(savedMenu: preference.getInt(key: staticLet.MENU_1), action: nil))
        listMenuFavorit.append(generateMenu(savedMenu: preference.getInt(key: staticLet.MENU_2), action: nil))
        listMenuFavorit.append(generateMenu(savedMenu: preference.getInt(key: staticLet.MENU_3), action: nil))
        listMenuFavorit.append(generateMenu(savedMenu: preference.getInt(key: staticLet.MENU_4), action: nil))
        listMenuFavorit.append(generateMenu(savedMenu: preference.getInt(key: staticLet.MENU_5), action: nil))
        listMenuFavorit.append(Menu(id: 99, image: UIImage(named: "menuLainya"), title: "Lihat Lainya", action: nil))
        
        // append list menu lainya
        listMenuLainya.append(generateMenu(savedMenu: preference.getInt(key: staticLet.MENU_6), action: nil))
        listMenuLainya.append(generateMenu(savedMenu: preference.getInt(key: staticLet.MENU_7), action: nil))
        listMenuLainya.append(generateMenu(savedMenu: preference.getInt(key: staticLet.MENU_8), action: nil))
        listMenuLainya.append(generateMenu(savedMenu: preference.getInt(key: staticLet.MENU_9), action: nil))
        listMenuLainya.append(generateMenu(savedMenu: preference.getInt(key: staticLet.MENU_10), action: nil))
        
        menuFavoritCollectionView.reloadData()
        menuLainyaCollectionView.reloadData()
        
        self.updateHeight()
    }
    
    private func updateHeight() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.menuFavoritCollectionViewHeight.constant = self.menuFavoritCollectionView.contentSize.height
            
            self.menuLainyaCollectionViewHeight.constant = self.menuLainyaCollectionView.contentSize.height
            
            self.viewRootHeight.constant = self.menuFavoritCollectionViewHeight.constant + self.menuLainyaCollectionViewHeight.constant + 136
        }
    }
    
    private func initView() {
        buttonUbah.layer.cornerRadius = 5
    }
    
    private func initCollectionView() {
        menuFavoritCollectionView.register(UINib(nibName: "MenuFavoritCell", bundle: nil), forCellWithReuseIdentifier: "MenuFavoritCell")
        menuLainyaCollectionView.register(UINib(nibName: "MenuLainyaCell", bundle: nil), forCellWithReuseIdentifier: "MenuLainyaCell")
        
        let menuSize = (UIScreen.main.bounds.width * 0.33) - 5
        
        let layoutMenuFavoritCollectionView = menuFavoritCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layoutMenuFavoritCollectionView.itemSize = CGSize(width: menuSize, height: menuSize)
        
        let layoutMenuLainyaCollectionView = menuLainyaCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layoutMenuLainyaCollectionView.itemSize = CGSize(width: menuSize, height: menuSize)
        
        menuFavoritCollectionView.delegate = self
        menuFavoritCollectionView.dataSource = self
        
        menuLainyaCollectionView.delegate = self
        menuLainyaCollectionView.dataSource = self
    }

    private func saveMenu() {
        for (index, menu) in listMenuFavorit.enumerated() {
            preference.saveInt(value: menu.id!, key: "MENU_\(index + 1)")
        }
        
        for (index, menu) in listMenuLainya.enumerated() {
            preference.saveInt(value: menu.id!, key: "MENU_\(index + 6)")
        }
    }
    
    private func updateMarginCollectionView(_ constraintView: NSLayoutConstraint, _ constant: CGFloat) {
        UIView.animate(withDuration: 0.2) {
            constraintView.constant = constant
            self.view.layoutIfNeeded()
        }
    }
    
    private func showActionInListMenuFavorit() {
        
        for (index, _) in listMenuFavorit.enumerated() {
            if index == listMenuFavorit.count - 1 { break }
            
            listMenuFavorit[index].action = UIImage(named: "minusSymbolInsideACircle")
            menuFavoritCollectionView.reloadItems(at: [IndexPath(item: index, section: 0)])
        }
    }
    
    private func showActionInListMenuLainya() {
        
        for (index, _) in listMenuLainya.enumerated() {
            listMenuLainya[index].action = UIImage(named: "addButtonInsideBlackCircle")
            menuLainyaCollectionView.reloadItems(at: [IndexPath(item: index, section: 0)])
        }
    }
    
    private func hideActionInListMenuFavorit() {
        updateMarginCollectionView(favoritCollectionRightMargin, 9)
        
        for (index, _) in listMenuFavorit.enumerated() {
            listMenuFavorit[index].action = nil
            menuFavoritCollectionView.reloadItems(at: [IndexPath(item: index, section: 0)])
        }
    }
    
    private func hideActionInListMenuLainya() {
        updateMarginCollectionView(lainyaCollectionRightMargin, 9)
        
        for (index, _) in listMenuLainya.enumerated() {
            listMenuLainya[index].action = nil
            menuLainyaCollectionView.reloadItems(at: [IndexPath(item: index, section: 0)])
        }
    }
    
    private func getPreparePresence() {
        SVProgressHUD.show()
        
        presenceNetworking.getPreparePresence { (error, preparePresence, isExpired) in
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
            
            self.dismiss(animated: true, completion: nil)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2, execute: {
                let vc = PresensiController()
                vc.preparePresence = preparePresence
                self.parentNavigationController?.pushViewController(vc, animated: true)
            })
        }
    }
    
    private func clickMenu(_ itemId: Int) {
        switch itemId {
        case 1:
            //pengajuan cuti
            self.showInDevelopmentDialog()
        case 2:
            //pengajuan lembur
            self.showInDevelopmentDialog()
        case 3:
            //persetujuan
            self.showInDevelopmentDialog()
        case 4:
            //presensi
            getPreparePresence()
        case 5:
            //presensi list item
            dismiss(animated: true, completion: nil)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                let vc = PresensiListController()
                vc.from = .standart
                self.parentNavigationController?.pushViewController(vc, animated: true)
            }
        case 6:
            //slip gaji
            self.showInDevelopmentDialog()
        case 7:
            //peminjaman ruangan
            self.showInDevelopmentDialog()
        case 8:
            //peminjaman mobil dinas
            self.showInDevelopmentDialog()
        case 9:
            //daftar karyawan
            dismiss(animated: true, completion: nil)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                self.parentNavigationController?.pushViewController(DaftarKaryawanController(), animated: true)
            }
        case 10:
            //link website aps
            self.showInDevelopmentDialog()
        default: break
        }
    }
}

extension BottomSheetMenuController {
    @IBAction func buttonUbahClicked(_ sender: Any) {
        if isEdit {
            isEdit = !isEdit
            buttonUbah.setTitle("Ubah", for: .normal)
            saveMenu()
            hideActionInListMenuLainya()
            hideActionInListMenuFavorit()
        } else {
            isEdit = !isEdit
            buttonUbah.setTitle("Simpan", for: .normal)
            showActionInListMenuFavorit()
        }
    }
    
    @objc func actionMenuFavoritClick(sender: UITapGestureRecognizer) {
        if let indexpath = menuFavoritCollectionView.indexPathForItem(at: sender.location(in: menuFavoritCollectionView)) {
            
            // click item if action is null (not editable)
            guard let _ = listMenuFavorit[indexpath.item].action else {
                clickMenu(listMenuFavorit[indexpath.item].id!)
                return
            }
            
            // add deleted item from menu favorit, and append it to menu lainya
            var item = listMenuFavorit[indexpath.item]
            item.action = UIImage(named: "addButtonInsideBlackCircle")
            listMenuLainya.insert(item, at: listMenuLainya.count - 1)
            menuLainyaCollectionView.insertItems(at: [IndexPath(item: listMenuLainya.count - 1, section: 0)])
            
            listMenuFavorit.remove(at: indexpath.item)
            menuFavoritCollectionView.deleteItems(at: [indexpath])
            
            updateHeight()
            
            self.buttonUbah.isHidden = true
            
            self.showActionInListMenuLainya()
        }
    }
    
    @objc func actionMenuLainyaClick(sender: UITapGestureRecognizer) {
        if let indexpath = menuLainyaCollectionView.indexPathForItem(at: sender.location(in: menuLainyaCollectionView)) {
            
            // click item if action is null (not editable)
            guard let _ = listMenuLainya[indexpath.item].action else {
                clickMenu(listMenuLainya[indexpath.item].id!)
                return
            }
            
            // add deleted item from menu lainya, and append it to menu favorit
            var item = listMenuLainya[indexpath.item]
            item.action = UIImage(named: "minusSymbolInsideACircle")
            listMenuFavorit.insert(item, at: listMenuFavorit.count - 1)
            menuFavoritCollectionView.insertItems(at: [IndexPath(item: listMenuFavorit.count - 2, section: 0)])
            
            listMenuLainya.remove(at: indexpath.item)
            menuLainyaCollectionView.deleteItems(at: [indexpath])
            
            updateHeight()
            
            if listMenuFavorit.count == 6 {
                hideActionInListMenuLainya()
                self.buttonUbah.isHidden = false
            }
        }
    }
}

extension BottomSheetMenuController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == menuFavoritCollectionView {
            return listMenuFavorit.count
        } else {
            return listMenuLainya.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == menuFavoritCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MenuFavoritCell", for: indexPath) as! MenuFavoritCell
            let item = listMenuFavorit[indexPath.item]
            
            cell.data = item
            cell.viewRoot.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(actionMenuFavoritClick(sender:))))
            
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MenuLainyaCell", for: indexPath) as! MenuLainyaCell
            let item = listMenuLainya[indexPath.item]
            
            cell.data = item
            cell.viewRoot.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(actionMenuLainyaClick(sender:))))
            
            return cell
        }
    }
}
