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

protocol BerandaControllerProtocol {
    func buttonSelengkapnyaClick()
}

class BerandaController: BaseViewController, UICollectionViewDelegate {
    
    @IBOutlet weak var buttonSelengkapnya: UIButton!
    @IBOutlet weak var labelBeritaPengumuman: UILabel!
    @IBOutlet weak var labelMenuUtama: UILabel!
    @IBOutlet weak var labelOverview: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
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
    var delegate : BerandaControllerProtocol?
    var isWasLoaded = false
    
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(handleRefresh(_:)),for: UIControl.Event.valueChanged)
        refreshControl.tintColor = UIColor(hexString: "42a5f5")
        
        return refreshControl
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        loadMenuItem()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("token \(preference.getString(key: staticLet.TOKEN))")
        
        function.changeStatusBar(hexCode: 0x42A5F5, view: self.view, opacity: 1)
        
        checkShowFirstDialog()
        
        initView()
        
        clickEvent()
        
        initCollection()
        
        getDashboard()
        
        getLatestNews()
    }
    
    private func clickEvent() {
        viewContainerPresensi.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(viewContainerPresensiClick)))
    }
    
    private func loadMenuItem() {
        listMenu.removeAll()
        
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
    
    private func checkShowFirstDialog() {
        if !self.preference.getBool(key: self.staticLet.IS_SHOW_FIRST_DIALOG) {
            self.getAnnouncement()
        }
    }
    
    private func getAnnouncement() {
        informationNetworking.getAnnouncement { (error, itemAnnouncement) in
            if let _ = error {
                return
            }
            
            guard let item = itemAnnouncement else { return }
            
            self.preference.saveBool(value: true, key: self.staticLet.IS_SHOW_FIRST_DIALOG)
            
            let cleanContent = item.content?.replacingOccurrences(of: "<p>", with: "").replacingOccurrences(of: "</p>", with: "")
            
            let vc = DialogFirstController()
            vc.resources = (image: item.img, title: item.title, description: cleanContent) as? (image: String, title: String, description: String)
            self.showCustomDialog(vc)
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
    }
    
    private func initView() {
        scrollView.addSubview(refreshControl)
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
    @objc func viewContainerPresensiClick() {
        getPreparePresence()
    }
    
    @IBAction func buttonSelengkapnyaClick(_ sender: Any) {
        delegate?.buttonSelengkapnyaClick()
    }
    
    @objc func menuClick(sender: UITapGestureRecognizer) {
        if let indexpath = menuCollectionView.indexPathForItem(at: sender.location(in: menuCollectionView)) {
            switch listMenu[indexpath.item].id {
            case 1:
                //pengajuan cuti
                self.showInDevelopmentDialog()
                //self.navigationController?.pushViewController(PengajuanCutiController(), animated: true)
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
                let vc = PresensiListController()
                vc.from = .standart
                self.navigationController?.pushViewController(vc, animated: true)
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
                self.navigationController?.pushViewController(DaftarKaryawanController(), animated: true)
            case 10:
                //link website aps
                self.showInDevelopmentDialog()
            case 99:
                //menu lainya item
                openBottomSheet()
            default: break
            }
        }
    }
    
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        refreshControl.endRefreshing()
        listBerita.removeAll()
        getDashboard()
        getLatestNews()
    }
    
    @objc func beritaContainerClick(sender: UITapGestureRecognizer) {
        guard let indexpath = beritaCollectionView.indexPathForItem(at: sender.location(in: beritaCollectionView)) else { return }
        
        let vc = DetailBeritaController()
        vc.news = listBerita[indexpath.item]
        navigationController?.pushViewController(vc, animated: true)
    }
    
    private func openBottomSheet() {
        let vc = BottomSheetMenuController()
        vc.parentNavigationController = self.navigationController
        let sheetController = SheetViewController(controller: vc, sizes: [SheetSize.fullScreen])
        sheetController.didDismiss = { _ in
            self.loadMenuItem()
        }
        
        self.present(sheetController, animated: false, completion: nil)
    }
    
    private func getDashboard() {
        SVProgressHUD.show()
        
        informationNetworking.getDashboard { (error, itemDashboard, isExpired) in
            
            SVProgressHUD.dismiss()
            
            if let _ = isExpired {
                self.forceLogout(self.navigationController!)
                return
            }
            
            if let error = error {
                self.function.showUnderstandDialog(self, "Dashboard Error", error, "Reload", "Cancel", completionHandler: {
                    self.getDashboard()
                })
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
            if item.presence_today?.icon == "sad" {
                self.iconPresenceStatus.image = UIImage(named: "sad")?.tinted(with: UIColor.white)
            }
            self.labelPresenceStatus.text = item.presence_today?.status
            self.labelClock.text = item.presence_today?.time
        }
    }
    
    private func getLatestNews() {
        informationNetworking.getLatestNews { (error, news, isExpired) in
            if let _ = isExpired {
                self.forceLogout(self.navigationController!)
                return
            }
            
            if let error = error {
                self.function.showUnderstandDialog(self, "Error Mendapatkan Berita Terbaru", error, "Reload", "Cancel", completionHandler: {
                    self.getLatestNews()
                })
                return
            }
            
            guard let news = news else { return }
            
            self.listBerita = news
            DispatchQueue.main.async {
                self.beritaCollectionView.reloadData()
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2, execute: {
                if !self.isWasLoaded {
                    self.isWasLoaded = true
                    self.beritaCollectionViewHeight.constant = self.beritaCollectionView.contentSize.height + 40
                }
            })
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
            cell.viewContainer.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(beritaContainerClick(sender:))))
            return cell
        }
        
    }
}
