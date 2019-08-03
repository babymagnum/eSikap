//
//  BottomSheetMenuController.swift
//  Angkasa Pura Solusi
//
//  Created by Arief Zainuri on 02/08/19.
//  Copyright © 2019 Gama Techno. All rights reserved.
//

import UIKit

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
        buttonUbah.layer.cornerRadius = buttonUbah.frame.height / 2
    }
    
    private func initCollectionView() {
        menuFavoritCollectionView.register(UINib(nibName: "MenuFavoritCell", bundle: nil), forCellWithReuseIdentifier: "MenuFavoritCell")
        menuLainyaCollectionView.register(UINib(nibName: "MenuLainyaCell", bundle: nil), forCellWithReuseIdentifier: "MenuLainyaCell")
        
        let menuFavoritCell = menuFavoritCollectionView.dequeueReusableCell(withReuseIdentifier: "MenuFavoritCell", for: IndexPath(item: 0, section: 0)) as! MenuFavoritCell
        let layoutMenuFavoritCollectionView = menuFavoritCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layoutMenuFavoritCollectionView.itemSize = CGSize(width: (UIScreen.main.bounds.width * 0.33) - 15, height: menuFavoritCell.viewRoot.frame.height)
        
        let menuLainyaCell = menuLainyaCollectionView.dequeueReusableCell(withReuseIdentifier: "MenuLainyaCell", for: IndexPath(item: 0, section: 0)) as! MenuLainyaCell
        let layoutMenuLainyaCollectionView = menuLainyaCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layoutMenuLainyaCollectionView.itemSize = CGSize(width: (UIScreen.main.bounds.width * 0.33) - 15, height: menuLainyaCell.viewRoot.frame.height)
        
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
        updateMarginCollectionView(favoritCollectionRightMargin, 19)
        
        for (index, _) in listMenuFavorit.enumerated() {
            if index == listMenuFavorit.count - 1 { break }
            
            listMenuFavorit[index].action = UIImage(named: "minus-circular")?.tinted(with: UIColor.red.withAlphaComponent(0.6))
            menuFavoritCollectionView.reloadItems(at: [IndexPath(item: index, section: 0)])
        }
    }
    
    private func showActionInListMenuLainya() {
        updateMarginCollectionView(lainyaCollectionRightMargin, 19)
        
        for (index, _) in listMenuLainya.enumerated() {
            listMenuLainya[index].action = UIImage(named: "plus-circular")?.tinted(with: UIColor.green.withAlphaComponent(0.6))
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
}

extension BottomSheetMenuController {
    @IBAction func buttonUbahClicked(_ sender: Any) {
        if isEdit {
            isEdit = !isEdit
            buttonUbah.setTitle("Ubah", for: .normal)
            saveMenu()
            updateMarginCollectionView(favoritCollectionRightMargin, 9)
            updateMarginCollectionView(lainyaCollectionRightMargin, 9)
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
            // add deleted item from menu favorit, and append it to menu lainya
            var item = listMenuFavorit[indexpath.item]
            item.action = UIImage(named: "plus-circular")?.tinted(with: UIColor.green)
            listMenuLainya.insert(item, at: listMenuLainya.count - 1)
            menuLainyaCollectionView.insertItems(at: [IndexPath(item: listMenuLainya.count - 1, section: 0)])
            
            listMenuFavorit.remove(at: indexpath.item)
            menuFavoritCollectionView.deleteItems(at: [indexpath])
            
            updateHeight()
            
            self.showActionInListMenuLainya()
        }
    }
    
    @objc func actionMenuLainyaClick(sender: UITapGestureRecognizer) {
        if let indexpath = menuLainyaCollectionView.indexPathForItem(at: sender.location(in: menuLainyaCollectionView)) {
            
            // add deleted item from menu lainya, and append it to menu favorit
            var item = listMenuLainya[indexpath.item]
            item.action = UIImage(named: "minus-circular")?.tinted(with: UIColor.red)
            listMenuFavorit.insert(item, at: listMenuFavorit.count - 1)
            menuFavoritCollectionView.insertItems(at: [IndexPath(item: listMenuFavorit.count - 2, section: 0)])
            
            listMenuLainya.remove(at: indexpath.item)
            menuLainyaCollectionView.deleteItems(at: [indexpath])
            
            updateHeight()
            
            if listMenuFavorit.count == 6 { hideActionInListMenuLainya() }
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
