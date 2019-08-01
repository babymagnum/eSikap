//
//  BerandaController.swift
//  Angkasa Pura Solusi
//
//  Created by Arief Zainuri on 28/07/19.
//  Copyright © 2019 Gama Techno. All rights reserved.
//

import UIKit
import SVProgressHUD

class BerandaController: BaseViewController, UICollectionViewDelegate {

    @IBOutlet weak var imageAccount: UIImageView!
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var viewContainerClock: UIView!
    @IBOutlet weak var labelClock: UILabel!
    @IBOutlet weak var viewContainerCapaian: UIView!
    @IBOutlet weak var labelCapaian: UILabel!
    @IBOutlet weak var viewContainerCuti: UIView!
    @IBOutlet weak var labelCuti: UILabel!
    @IBOutlet weak var viewContainerPresensi: UIView!
    @IBOutlet weak var menuCollectionView: UICollectionView!
    @IBOutlet weak var menuCollectionViewHeight: NSLayoutConstraint!
    @IBOutlet weak var beritaCollectionView: UICollectionView!
    @IBOutlet weak var beritaCollectionViewHeight: NSLayoutConstraint!
    @IBOutlet weak var viewRootHeight: NSLayoutConstraint!
    
    // properties
    private var listMenu = [Menu]()
    private var listBerita = [Berita]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("token \(preference.getString(key: staticLet.TOKEN))")
        
        function.changeStatusBar(hexCode: 0x42A5F5, view: self.view, opacity: 1)
        
        initView()
        
        initCollection()
        
        loadBerita()
    }
    
    private func initCollection() {
        menuCollectionView.register(UINib(nibName: "MenuUtamaCell", bundle: nil), forCellWithReuseIdentifier: "MenuUtamaCell")
        
        beritaCollectionView.register(UINib(nibName: "BeritaCell", bundle: nil), forCellWithReuseIdentifier: "BeritaCell")
        
        let menuUtamaCell = menuCollectionView.dequeueReusableCell(withReuseIdentifier: "MenuUtamaCell", for: IndexPath(item: 0, section: 0)) as! MenuUtamaCell
        let layoutMenuCollectionView = menuCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layoutMenuCollectionView.itemSize = CGSize(width: (UIScreen.main.bounds.width / 3) - 20, height: menuUtamaCell.viewContainer.frame.height)
        
        let beritaCell = beritaCollectionView.dequeueReusableCell(withReuseIdentifier: "BeritaCell", for: IndexPath(item: 0, section: 0)) as! BeritaCell
        let layoutBeritaCollectionView = beritaCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layoutBeritaCollectionView.itemSize = CGSize(width: UIScreen.main.bounds.width * 0.7, height: beritaCell.viewContainer.frame.height)
        
        menuCollectionView.delegate = self
        menuCollectionView.dataSource = self
        beritaCollectionView.delegate = self
        beritaCollectionView.dataSource = self
        
        // populate menu utama item
        listMenu.append(Menu(id: 1, image: UIImage(named: "briefcase"), title: "Pengajuan Cuti"))
        listMenu.append(Menu(id: 2, image: UIImage(named: "employee"), title: "Pengajuan Lembur"))
        listMenu.append(Menu(id: 3, image: UIImage(named: "test"), title: "Persetujuan"))
        listMenu.append(Menu(id: 4, image: UIImage(named: "circularClock"), title: "Presensi"))
        listMenu.append(Menu(id: 5, image: UIImage(named: "form"), title: "Presensi List"))
        listMenu.append(Menu(id: 6, image: UIImage(named: "menuLainya"), title: "Lihat Lainya"))
        
        menuCollectionView.reloadData()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.menuCollectionViewHeight.constant = self.menuCollectionView.contentSize.height
        }
    }
    
    private func loadBerita() {
        listBerita.append(Berita(id: "1", title: "Informasi Penggajian Bulan Desember", description: "Lorem ipsum dolor sit amet consectuer bla bla bla", createdAt: function.getCurrentDate(pattern: "dd MMMM yyyy kk:mm:ss"), image: "https://www.incimages.com/uploaded_files/image/970x450/getty_509107562_2000133320009280346_351827.jpg"))
        
        listBerita.append(Berita(id: "2", title: "Pembukaan Bandara YIA", description: "Lorem ipsum dolor sit amet bla bla bla", createdAt: function.getCurrentDate(pattern: "dd MMMM yyyy kk:mm:ss"), image: "https://cdn2.tstatic.net/wartakota/foto/bank/images/bandara-yogyakarta.jpg"))
        beritaCollectionView.reloadData()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.beritaCollectionViewHeight.constant = self.beritaCollectionView.contentSize.height + 40
        }
    }
    
    private func initView() {
        viewContainerCapaian.layer.cornerRadius = 6
        viewContainerClock.layer.cornerRadius = 6
        viewContainerCuti.layer.cornerRadius = 6
        viewContainerPresensi.layer.cornerRadius = 6
        imageAccount.layer.cornerRadius = imageAccount.frame.height / 2
        
        labelName.text = preference.getString(key: staticLet.EMP_NAME)
        imageAccount.loadUrl(preference.getString(key: staticLet.EMP_PHOTO))
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

}

//click event
extension BerandaController {
    @objc func menuClick(sender: UITapGestureRecognizer) {
        if let indexpath = menuCollectionView.indexPathForItem(at: sender.location(in: menuCollectionView)) {
            switch listMenu[indexpath.item].id {
            case 1:
                print("pengajuan cuti")
            case 2:
                print("pengajuan lembur")
            case 3:
                print("persetujuan")
            case 4:
                getPreparePresence()
            case 5:
                print("presensi list")
            case 6:
                print("lihat lainya")
            default: break
            }
        }
    }
    
    private func getPreparePresence() {
        SVProgressHUD.show()
        
        networking.getPreparePresence { (error, preparePresence) in
            SVProgressHUD.dismiss()
            
            if let error = error {
                self.function.showUnderstandDialog(self, "Failed get Prepare Presence", error, "Understand")
                return
            }
            
            let vc = PresensiController()
            vc.preparePresence = preparePresence
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
    }
}

extension BerandaController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == menuCollectionView {
            return listMenu.count
        } else {
            return listBerita.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == menuCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MenuUtamaCell", for: indexPath) as! MenuUtamaCell
            cell.data = listMenu[indexPath.item]
            cell.viewContainer.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(menuClick(sender:))))
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BeritaCell", for: indexPath) as! BeritaCell
            cell.data = listBerita[indexPath.item]
            return cell
        }
        
    }
}
