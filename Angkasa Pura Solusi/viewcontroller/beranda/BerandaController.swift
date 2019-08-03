//
//  BerandaController.swift
//  Angkasa Pura Solusi
//
//  Created by Arief Zainuri on 28/07/19.
//  Copyright © 2019 Gama Techno. All rights reserved.
//

import UIKit
import SVProgressHUD
import EzPopup
import FittedSheets

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
    @IBOutlet weak var labelPresenceStatus: UILabel!
    @IBOutlet weak var iconPresenceStatus: UIImageView!
    
    // properties
    private var listMenu = [Menu]()
    private var listBerita = [News]()
    var seconds = 0
    var minutes = 0
    var hours = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("token \(preference.getString(key: staticLet.TOKEN))")
        
        function.changeStatusBar(hexCode: 0x42A5F5, view: self.view, opacity: 1)
        
        checkShowFirstDialog()
        
        initView()
        
        initCollection()
        
        getDashboard()
        
        getLatestNews()
    }
    
    private func checkShowFirstDialog() {
        DispatchQueue.main.async {
            if !self.preference.getBool(key: self.staticLet.IS_SHOW_FIRST_DIALOG) {
                self.preference.saveBool(value: true, key: self.staticLet.IS_SHOW_FIRST_DIALOG)
                
                let vc = DialogFirstController()
                self.showCustomDialog(vc)
            }
        }
    }
    
    private func initCollection() {
        menuCollectionView.register(UINib(nibName: "MenuUtamaCell", bundle: nil), forCellWithReuseIdentifier: "MenuUtamaCell")
        
        beritaCollectionView.register(UINib(nibName: "BeritaCell", bundle: nil), forCellWithReuseIdentifier: "BeritaCell")
        
        let menuUtamaCell = menuCollectionView.dequeueReusableCell(withReuseIdentifier: "MenuUtamaCell", for: IndexPath(item: 0, section: 0)) as! MenuUtamaCell
        let layoutMenuCollectionView = menuCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layoutMenuCollectionView.itemSize = CGSize(width: (UIScreen.main.bounds.width * 0.33) - 20, height: menuUtamaCell.viewContainer.frame.height)
        
        let beritaCell = beritaCollectionView.dequeueReusableCell(withReuseIdentifier: "BeritaCell", for: IndexPath(item: 0, section: 0)) as! BeritaCell
        let layoutBeritaCollectionView = beritaCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layoutBeritaCollectionView.itemSize = CGSize(width: UIScreen.main.bounds.width * 0.7, height: beritaCell.viewContainer.frame.height)
        
        menuCollectionView.delegate = self
        menuCollectionView.dataSource = self
        beritaCollectionView.delegate = self
        beritaCollectionView.dataSource = self
        
        // populate menu utama item
        listMenu.append(generateMenu(savedMenu: preference.getInt(key: staticLet.MENU_1), action: nil))
        listMenu.append(generateMenu(savedMenu: preference.getInt(key: staticLet.MENU_2), action: nil))
        listMenu.append(generateMenu(savedMenu: preference.getInt(key: staticLet.MENU_3), action: nil))
        listMenu.append(generateMenu(savedMenu: preference.getInt(key: staticLet.MENU_4), action: nil))
        listMenu.append(generateMenu(savedMenu: preference.getInt(key: staticLet.MENU_5), action: nil))
        listMenu.append(Menu(id: 99, image: UIImage(named: "menuLainya"), title: "Lihat Lainya", action: nil))
        
        menuCollectionView.reloadData()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.menuCollectionViewHeight.constant = self.menuCollectionView.contentSize.height
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
            case 99:
                print("menu lainya clicked")
                openBottomSheet()
            default: break
            }
        }
    }
    
    private func openBottomSheet() {
        let sheetController = SheetViewController(controller: BottomSheetMenuController())
        
        self.present(sheetController, animated: false, completion: nil)
    }
    
    private func getDashboard() {
        SVProgressHUD.show()
        
        informationNetworking.getDashboard { (error, itemDashboard) in
            
            SVProgressHUD.dismiss()
            
            if let error = error {
                self.function.showUnderstandDialog(self, "Error Getting Dashboard", error, "Understand")
                return
            }
            
            guard let item = itemDashboard else { return }
            
            self.setDashboardView(item)
            
            self.checkShowFirstDialog()
        }
    }
    
    private func setDashboardView(_ item: ItemDashboard) {
        DispatchQueue.main.async {
            self.labelCuti.text = item.total_leave_quota
            self.labelCapaian.text = "\(item.total_work?.total_work_achievement ?? "") / 120"
            let currentTime = self.function.getCurrentDate(pattern: "hh:mm:ss")
            let timeArray = currentTime.components(separatedBy: ":")
            if item.presence_today?.icon == "sad" {
                self.iconPresenceStatus.image = UIImage(named: "sad")?.tinted(with: UIColor.white)
            }
            self.labelPresenceStatus.text = item.presence_today?.status
            self.seconds = Int(timeArray[2])!
            self.minutes = Int(timeArray[1])!
            self.hours = Int(timeArray[0])!
            
            Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { (timer) in
                
                self.seconds += 1
                
                if self.seconds == 60 {
                    self.minutes += 1
                    self.seconds = 0
                }
                
                if self.minutes == 60 {
                    self.hours += 1
                    self.minutes = 0
                }
                
                self.labelClock.text = "\(String(self.hours).count == 1 ? "0\(self.hours)" : "\(self.hours)"):\(String(self.minutes).count == 1 ? "0\(self.minutes)" : "\(self.minutes)"):\(String(self.seconds).count == 1 ? "0\(self.seconds)" : "\(self.seconds)")"
            }
        }
    }
    
    private func getLatestNews() {
        informationNetworking.getLatestNews { (error, news) in
            if let error = error {
                self.function.showUnderstandDialog(self, "Error getting news list", error, "Understand")
                return
            }
            
            guard let news = news else { return }
            
            self.listBerita = news
            DispatchQueue.main.async {
                self.beritaCollectionView.reloadData()
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2, execute: {
                self.beritaCollectionViewHeight.constant = self.beritaCollectionView.contentSize.height + 40
            })
        }
    }
    
    private func getPreparePresence() {
        SVProgressHUD.show()
        
        presenceNetworking.getPreparePresence { (error, preparePresence) in
            SVProgressHUD.dismiss()
            
            if let error = error {
                let vc = DialogPreparePresenceController()
                vc.stringDescription = error
                self.showCustomDialog(vc)
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
