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
import SafariServices

protocol BerandaControllerProtocol {
    func buttonSelengkapnyaClick()
}

class BerandaController: BaseViewController, UICollectionViewDelegate {
    
    @IBOutlet weak var buttonSelengkapnyaTop: NSLayoutConstraint!
    @IBOutlet weak var labelBeritaTop: NSLayoutConstraint!
    @IBOutlet weak var labelMenuEmptyTop: NSLayoutConstraint!
    @IBOutlet weak var labelMenuEmptyHeight: NSLayoutConstraint!
    @IBOutlet weak var labelMenuEmpty: CustomLabel!
    @IBOutlet weak var dividerBot: UIView!
    @IBOutlet weak var dividerTop: UIView!
    @IBOutlet weak var collectionBeritaBottomMargin: NSLayoutConstraint!
    @IBOutlet weak var viewRootTopMargin: NSLayoutConstraint!
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
    @IBOutlet weak var labelPresenceStatus: UILabel!
    @IBOutlet weak var iconPresenceStatus: UIImageView!
    @IBOutlet weak var stackTopHeight: NSLayoutConstraint!
    @IBOutlet weak var stackBottomHeight: NSLayoutConstraint!
    @IBOutlet weak var imagePlaceholder: UIImageView!
    
    // properties
    private var listMenu = [Menu]()
    private var listBerita = [News]()
    private var isAlreadyCalculateBeritaHeight = false
    private var isGetMenuItem = false
    
    var delegate : BerandaControllerProtocol?
    
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(handleRefresh(_:)),for: UIControl.Event.valueChanged)
        refreshControl.tintColor = UIColor(hexString: "42a5f5")
        
        return refreshControl
    }()
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        menuCollectionView.collectionViewLayout.invalidateLayout()
        beritaCollectionView.collectionViewLayout.invalidateLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        if isGetMenuItem {
            loadMenuItem()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initView()
        
        clickEvent()
        
        initCollection()
        
        checkShowFirstDialog()
        
        getDashboard()
        
        getLatestNews()
        
        getMenu()
        
        checkVersion()
    }
    
    private func getMenu() {
        SVProgressHUD.show()
        
        informationNetworking.getMenu { (error, menu, isExpired) in
            SVProgressHUD.dismiss()
            
            if let _ = error {
                self.getMenu()
                return
            }
            
            guard let _menu = menu else { return }
            
            self.isGetMenuItem = true
            self.labelMenuEmpty.isHidden = _menu.data.count > 0
            self.dividerTop.isHidden = _menu.data.count == 0
            self.dividerBot.isHidden = _menu.data.count == 0
            self.labelMenuEmpty.text = _menu.message
            
            if _menu.data.count != self.preference.getInt(key: self.staticLet.JUMLAH_MENU) {
                self.preference.saveInt(value: _menu.data.count, key: self.staticLet.JUMLAH_MENU)
                
                for (index, item) in _menu.data.enumerated() {
                    if index < 5 {
                        self.preference.saveString(value: item.menu_key, key: "MENU_\(index + 1)")
                    } else if index > 5 {
                        self.preference.saveString(value: item.menu_key, key: "MENU_\(index)")
                    }
                }
            }
            
            if _menu.data.count > 0 {
                self.labelMenuEmptyHeight.constant = 0
                self.loadMenuItem()
            } else {
                self.labelMenuEmptyTop.constant = 30
                self.labelBeritaTop.constant = 30
                self.buttonSelengkapnyaTop.constant = 30 - 7
                self.menuCollectionViewHeight.constant = 0
                self.scrollView.resizeScrollViewContentSize()
                self.view.layoutIfNeeded()
            }
        }
    }
    
    private func checkVersion() {
        if #available(iOS 11, *) {
            //do nothing
        } else {
            collectionBeritaBottomMargin.constant += 49 // 49 is height of ui tabbar
            scrollView.resizeScrollViewContentSize()
        }
    }
    
    private func clickEvent() {
        viewContainerPresensi.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(viewContainerPresensiClick)))
    }
    
    private func loadMenuItem() {
        listMenu.removeAll()
        
        for index in 0...5 {
            if index < 5 { listMenu.append(generateMenu(savedMenu: preference.getString(key: "MENU_\(index + 1)"), action: nil)) }
            else { listMenu.append(Menu(id: "menuAll", image: UIImage(named: "menuLainya"), title: "Lihat Lainya", action: nil)) }
        }
        
        menuCollectionView.reloadData()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
            UIView.animate(withDuration: 0.2, animations: {
                self.menuCollectionViewHeight.constant = self.menuCollectionView.contentSize.height
                self.scrollView.resizeScrollViewContentSize()
                self.view.layoutIfNeeded()
            })
        }
    }
    
    private func checkShowFirstDialog() {
        if !preference.getBool(key: staticLet.IS_SHOW_FIRST_DIALOG) {
            getAnnouncement()
        }
    }
    
    private func getAnnouncement() {
        informationNetworking.getAnnouncement { (error, itemAnnouncement) in
            if let _ = error {
                return
            }
            
            guard let item = itemAnnouncement else { return }
            
            if item.count == 0 { return }
            
            let content = item[0]
            let cleanContent = content.content?.removingRegexMatches(pattern: "<[^>]+>", replaceWith: "").removingRegexMatches(pattern: "&[^;]+;", replaceWith: "").removingRegexMatches(pattern: "&[^;]+", replaceWith: "")
            
            let vc = DialogFirstController()
            vc.resources = (image: content.img, title: content.title, description: cleanContent) as? (image: String, title: String, description: String)
            let popupVc = PopupViewController(contentController: vc, popupWidth: UIScreen.main.bounds.width, popupHeight: UIScreen.main.bounds.height)
            popupVc.shadowEnabled = false
            self.present(popupVc, animated: true)
        }
    }
    
    private func initCollection() {
        menuCollectionView.register(UINib(nibName: "MenuUtamaCell", bundle: nil), forCellWithReuseIdentifier: "MenuUtamaCell")
        beritaCollectionView.register(UINib(nibName: "BeritaCell", bundle: nil), forCellWithReuseIdentifier: "BeritaCell")
        
        let menuSize = (UIScreen.main.bounds.width * 0.33) - 20
        let layoutMenuCollectionView = menuCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layoutMenuCollectionView.itemSize = CGSize(width: menuSize, height: menuSize)
        
        menuCollectionView.delegate = self
        menuCollectionView.dataSource = self
        beritaCollectionView.delegate = self
        beritaCollectionView.dataSource = self
    }
    
    private func initView() {
        print("token \(preference.getString(key: staticLet.TOKEN))")
        checkTopMargin(viewRootTopMargin: viewRootTopMargin)
        function.changeStatusBar(hexCode: 0x42A5F5, view: self.view, opacity: 1)
        scrollView.addSubview(refreshControl)
        viewContainerCapaian.addShadow(CGSize(width: 1, height: 2), UIColor.lightGray, 2, 0.6, 6)
        viewContainerClock.addShadow(CGSize(width: 1, height: 2), UIColor.lightGray, 2, 0.6, 6)
        viewContainerCuti.addShadow(CGSize(width: 1, height: 2), UIColor.lightGray, 2, 0.6, 6)
        viewContainerPresensi.addShadow(CGSize(width: 1, height: 2), UIColor.lightGray, 2, 0.6, 6)
        
        labelName.text = preference.getString(key: staticLet.EMP_NAME)
        imageAccount.loadUrl(preference.getString(key: staticLet.EMP_PHOTO))
        
        let estimatedStackHeight = iconPresenceStatus.frame.height + labelClock.getHeight(width: labelClock.frame.width) + labelPresenceStatus.getHeight(width: labelPresenceStatus.frame.width) + 12.4 + 3.6 + 2.3 + 10.7
        
        DispatchQueue.main.async { self.imageAccount.layer.cornerRadius = self.imageAccount.frame.height / 2 }
        
        UIView.animate(withDuration: 0.2) {
            self.stackTopHeight.constant = estimatedStackHeight
            self.stackBottomHeight.constant = estimatedStackHeight
            self.scrollView.resizeScrollViewContentSize()
            self.view.layoutIfNeeded()
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle { return .lightContent }
    
}

//click event
extension BerandaController {
    @objc func viewContainerPresensiClick() { getPreparePresence() }
    
    @IBAction func buttonSelengkapnyaClick(_ sender: Any) { delegate?.buttonSelengkapnyaClick() }
    
    @objc func menuClick(sender: UITapGestureRecognizer) {
        if let indexpath = menuCollectionView.indexPathForItem(at: sender.location(in: menuCollectionView)) {
            switch listMenu[indexpath.item].id {
            case "menuCuti":
                //pengajuan cuti
                self.navigationController?.pushViewController(PengajuanCutiController(), animated: true)
            case "menuLembur":
                //pengajuan lembur
                self.navigationController?.pushViewController(PengajuanLemburController(), animated: true)
            case "menuPersetujuan":
                //persetujuan
                self.navigationController?.pushViewController(TabPersetujuanController(), animated: true)
            case "menuPresensi":
                //presensi
                getPreparePresence()
            case "menuDaftarPresensi":
                //presensi list item
                let vc = PresensiListController()
                vc.from = .standart
                self.navigationController?.pushViewController(vc, animated: true)
            case "menuUpah":
                //slip gaji
                self.navigationController?.pushViewController(TabUpahController(), animated: true)
            case "menuRuang":
                //peminjaman ruangan
                self.navigationController?.pushViewController(DaftarPeminjamanRuanganController(), animated: true)
            case "menuMobil":
                //peminjaman mobil dinas
                self.navigationController?.pushViewController(PeminjamanMobilDinasController(), animated: true)
            case "menuKaryawan":
                //daftar karyawan
                self.navigationController?.pushViewController(DaftarKaryawanController(), animated: true)
            case "menuLink":
                //link website aps
                let safariVc = SFSafariViewController(url: URL(string: "https://angkasapurasolusi.co.id")!)
                self.present(safariVc, animated: true)
            case "menuKebijakan":
                //link kebijakan & peraturan
                self.navigationController?.pushViewController(KebijakanPeraturanController(), animated: true)
            case "menuDaftarCuti":
                //link daftar cuti
                print("daftar cuti")
            case "menuAll":
                //menu lainya item
                openBottomSheet()
            default: break
            }
        }
    }
    
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        refreshControl.endRefreshing()
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
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                self.loadMenuItem()
            }
        }
        
        self.present(sheetController, animated: false, completion: nil)
    }
    
    private func getDashboard() {
        SVProgressHUD.show()
        
        informationNetworking.getDashboard { (error, itemDashboard, isExpired) in
            
            SVProgressHUD.dismiss()
            
            if let _ = isExpired {
                DispatchQueue.main.async { self.forceLogout(self.navigationController!) }
                return
            }
            
            if let error = error {
                self.function.showUnderstandDialog(self, "Dashboard Error", error, "Reload", "Cancel", completionHandler: {
                    self.getDashboard()
                })
                return
            }
            
            guard let item = itemDashboard else { return }
            
            DispatchQueue.main.async { self.setDashboardView(item) }
        }
    }
    
    private func setDashboardView(_ item: ItemDashboard) {
        labelCuti.text = item.total_leave_quota
        labelCapaian.text = "\(item.total_work?.total_work_achievement ?? "") / 120"
        if item.presence_today?.icon == "sad" {
            iconPresenceStatus.image = UIImage(named: "sad")
        } else if item.presence_today?.icon == "emotionless" {
            iconPresenceStatus.image = UIImage(named: "surprised")
        }
        labelPresenceStatus.text = item.presence_today?.status?.uppercased()
        labelClock.text = item.presence_today?.time
    }
    
    private func getLatestNews() {
        listBerita.removeAll()
        
        informationNetworking.getLatestNews { (error, news, isExpired) in
            
            if let _ = error {
                self.getLatestNews()
                return
            }
            
            guard let news = news else { return }
            
            self.listBerita = news
            
            DispatchQueue.main.async { self.beritaCollectionView.reloadData() }
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
            
            DispatchQueue.main.async {
                cell.viewContaineInsideHeight.constant = cell.icon.frame.height + cell.labelTitle.getHeight(width: cell.labelTitle.frame.width) + 7.2
            }
            
            cell.data = listMenu[indexPath.item]
            cell.viewContainer.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(menuClick(sender:))))
            return cell
        } else {
            let beritaCell = collectionView.dequeueReusableCell(withReuseIdentifier: "BeritaCell", for: indexPath) as! BeritaCell
            
            if !isAlreadyCalculateBeritaHeight && indexPath.item == listBerita.count - 1 {
                isAlreadyCalculateBeritaHeight = true
                DispatchQueue.main.async {
                    let beritaHeight = ((UIScreen.main.bounds.width * 0.8) * 0.45) + beritaCell.labelCreatedAt.getHeight(width: beritaCell.labelCreatedAt.frame.width) + beritaCell.labelTitle.getHeight(width: beritaCell.labelTitle.frame.width) + 29.5
                    let layoutBeritaCollectionView = self.beritaCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
                    layoutBeritaCollectionView.itemSize = CGSize(width: UIScreen.main.bounds.width * 0.8, height: beritaHeight)
                    
                    self.beritaCollectionViewHeight.constant = beritaHeight + 4
                    self.scrollView.resizeScrollViewContentSize()
                    self.view.layoutIfNeeded()
                }
            }
            
            beritaCell.data = listBerita[indexPath.item]
            beritaCell.viewContainer.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(beritaContainerClick(sender:))))
            
            return beritaCell
        }
        
    }
}
