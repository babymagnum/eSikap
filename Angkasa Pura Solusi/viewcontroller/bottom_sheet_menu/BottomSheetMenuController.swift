//
//  BottomSheetMenuController.swift
//  Angkasa Pura Solusi
//
//  Created by Arief Zainuri on 02/08/19.
//  Copyright © 2019 Gama Techno. All rights reserved.
//

import UIKit
import SVProgressHUD
import SafariServices

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
        for index in 0...preference.getInt(key: staticLet.JUMLAH_MENU) - 1 {
            if index < 5 {
                listMenuFavorit.append(generateMenu(savedMenu: preference.getString(key: "MENU_\(index + 1)"), action: nil))
            } else if index == 5 {
                listMenuFavorit.append(Menu(id: "menuAll", image: UIImage(named: "menuLainya"), title: "Lihat Lainya", action: nil))
            } else if index > 5 {
                listMenuLainya.append(generateMenu(savedMenu: preference.getString(key: "MENU_\(index)"), action: nil))
            }
        }
        
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
        menuFavoritCollectionView.register(UINib(nibName: "MenuLainyaCell", bundle: nil), forCellWithReuseIdentifier: "MenuLainyaCell")
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
            preference.saveString(value: menu.id!, key: "MENU_\(index + 1)")
        }
        
        for (index, menu) in listMenuLainya.enumerated() {
            preference.saveString(value: menu.id!, key: "MENU_\(index + 6)")
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
        for (index, _) in listMenuFavorit.enumerated() {
            listMenuFavorit[index].action = nil
            menuFavoritCollectionView.reloadItems(at: [IndexPath(item: index, section: 0)])
        }
    }
    
    private func hideActionInListMenuLainya() {
        
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
    
    private func clickMenu(_ itemId: String) {
        switch itemId {
        case "menuCuti":
            //pengajuan cuti
            dismiss(animated: true, completion: nil)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                self.parentNavigationController?.pushViewController(PengajuanCutiController(), animated: true)
            }
        case "menuLembur":
            //pengajuan lembur
            self.showInDevelopmentDialog()
        case "menuPersetujuan":
            //persetujuan
            dismiss(animated: true, completion: nil)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                self.parentNavigationController?.pushViewController(TabPersetujuanController(), animated: true)
            }
        case "menuPresensi":
            //presensi
            getPreparePresence()
        case "menuDaftarPresensi":
            //presensi list item
            dismiss(animated: true, completion: nil)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                let vc = PresensiListController()
                vc.from = .standart
                self.parentNavigationController?.pushViewController(vc, animated: true)
            }
        case "menuUpah":
            //slip gaji
            dismiss(animated: true, completion: nil)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                self.parentNavigationController?.pushViewController(TabUpahController(), animated: true)
            }
        case "menuRuang":
            //peminjaman ruangan
            dismiss(animated: true, completion: nil)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                self.parentNavigationController?.pushViewController(DaftarPeminjamanRuanganController(), animated: true)
            }
        case "menuMobil":
            //peminjaman mobil dinas
            dismiss(animated: true, completion: nil)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                self.parentNavigationController?.pushViewController(PeminjamanMobilDinasController(), animated: true)
            }
        case "menuKaryawan":
            //daftar karyawan
            dismiss(animated: true, completion: nil)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                self.parentNavigationController?.pushViewController(DaftarKaryawanController(), animated: true)
            }
        case "menuLink":
            //link website aps
            let safariVc = SFSafariViewController(url: URL(string: "https://angkasapurasolusi.co.id")!)
            self.present(safariVc, animated: true)
        case "menuKebijakan":
            //link kebijakan & peraturan
            dismiss(animated: true, completion: nil)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                self.parentNavigationController?.pushViewController(KebijakanPeraturanController(), animated: true)
            }
        case "menuDaftarCuti":
            //link daftar cuti
            dismiss(animated: true, completion: nil)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                
            }
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
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MenuLainyaCell", for: indexPath) as! MenuLainyaCell
            
            DispatchQueue.main.async {
                cell.viewContainerInsideHeight.constant = cell.iconMenu.frame.height + 7.2 + cell.labelTitle.getHeight(width: cell.labelTitle.frame.width)
            }
            
            let item = listMenuFavorit[indexPath.item]
            
            cell.data = item
            cell.viewRoot.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(actionMenuFavoritClick(sender:))))
            
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MenuLainyaCell", for: indexPath) as! MenuLainyaCell
            
            DispatchQueue.main.async {
                cell.viewContainerInsideHeight.constant = cell.iconMenu.frame.height + 7.2 + cell.labelTitle.getHeight(width: cell.labelTitle.frame.width)
            }
            
            let item = listMenuLainya[indexPath.item]
            
            cell.data = item
            cell.viewRoot.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(actionMenuLainyaClick(sender:))))
            
            return cell
        }
    }
}
