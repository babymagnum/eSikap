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
    
    var listMenuFavorit = [Menu]()
    var listMenuLainya = [Menu]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initView()
        
        initCollectionView()
        
        loadMenu()
    }
    
    private func loadMenu() {
        // TODO load menu
    }
    
    private func initView() {
        buttonUbah.layer.cornerRadius = buttonUbah.frame.height / 2
    }
    
    private func initCollectionView() {
        menuFavoritCollectionView.register(UINib(nibName: "MenuEditCell", bundle: nil), forCellWithReuseIdentifier: "MenuEditCell")
        menuLainyaCollectionView.register(UINib(nibName: "MenuEditCell", bundle: nil), forCellWithReuseIdentifier: "MenuEditCell")
        
        let menuFavoritCell = menuFavoritCollectionView.dequeueReusableCell(withReuseIdentifier: "MenuEditCell", for: IndexPath(item: 0, section: 0)) as! MenuEditCell
        let layoutMenuFavoritCollectionView = menuFavoritCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layoutMenuFavoritCollectionView.itemSize = CGSize(width: (UIScreen.main.bounds.width * 0.33) - 15, height: menuFavoritCell.viewRoot.frame.height)
        
        let layoutMenuLainyaCollectionView = menuLainyaCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layoutMenuLainyaCollectionView.itemSize = CGSize(width: (UIScreen.main.bounds.width * 0.33) - 15, height: menuFavoritCell.viewRoot.frame.height)
        
        menuFavoritCollectionView.delegate = self
        menuFavoritCollectionView.dataSource = self
        
        menuLainyaCollectionView.delegate = self
        menuLainyaCollectionView.dataSource = self
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
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MenuUtamaCell", for: indexPath) as! MenuUtamaCell
            cell.data = listMenuFavorit[indexPath.item]
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MenuUtamaCell", for: indexPath) as! MenuUtamaCell
            cell.data = listMenuLainya[indexPath.item]
            return cell
        }
    }
}
