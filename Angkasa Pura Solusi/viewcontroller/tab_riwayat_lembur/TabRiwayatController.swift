//
//  TabRiwayatController.swift
//  Angkasa Pura Solusi
//
//  Created by Arief Zainuri on 26/01/20.
//  Copyright © 2020 Gama Techno. All rights reserved.
//

import UIKit
import XLPagerTabStrip

class TabRiwayatController: ButtonBarPagerTabStripViewController {

    @IBOutlet weak var constraintViewRoot: NSLayoutConstraint!
    
    lazy var function: PublicFunction = {
        let mFunction = PublicFunction()
        return mFunction
    }()
    
    var afterAddLeave: Bool?
    
    private var year = ""
    private var status = ""
    private var pages = [UIViewController]()
    
    override func viewDidLoad() {
        setupTabLayout()
        
        super.viewDidLoad()
        
        function.changeStatusBar(hexCode: 0x42a5f5, view: self.view, opacity: 1)
        
        if #available(iOS 11, *) {
            self.constraintViewRoot.constant = 0
        } else {
            self.constraintViewRoot.constant = UIApplication.shared.statusBarFrame.height
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle { return .lightContent }
    
    func setupTabLayout() {
        settings.style.buttonBarBackgroundColor = UIColor.init(rgb: 0x42a5f5)
        settings.style.buttonBarItemBackgroundColor = UIColor.init(rgb: 0x42a5f5)
        settings.style.selectedBarBackgroundColor = UIColor.init(rgb: 0x707070)
        settings.style.buttonBarItemFont = .boldSystemFont(ofSize: 11)
        settings.style.selectedBarHeight = 2.0
        settings.style.buttonBarMinimumLineSpacing = 0
        settings.style.buttonBarItemTitleColor = .white
        settings.style.buttonBarItemsShouldFillAvailableWidth = true
        settings.style.buttonBarLeftContentInset = 0
        settings.style.buttonBarRightContentInset = 0
        
        changeCurrentIndexProgressive = {(oldCell: ButtonBarViewCell?, newCell: ButtonBarViewCell?, progressPercentage: CGFloat, changeCurrentIndex: Bool, animated: Bool) -> Void in
            guard changeCurrentIndex == true else { return }
            oldCell?.label.textColor = .white
            newCell?.label.textColor = .white
        }
    }
    
    // MARK: - PagerTabStripDataSource
    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        
        if year == "" {
            year = function.getCurrentDate(pattern: "yyyy")
        }
        
        let pengajuanController = PengajuanLemburTabController()
        pengajuanController.year = year
        pengajuanController.status = status
        
        let realisasiController = RealisasiLemburTabController()
        realisasiController.year = year
        realisasiController.status = status
        
        pages.append(pengajuanController)
        pages.append(realisasiController)
        return pages
    }
}

extension TabRiwayatController: FilterPengajuanLemburTabProtocol {
    func filterApply(year: String, status: String) {
        self.year = year
        self.status = status
        pages.removeAll()
        reloadPagerTabStripView()
    }
    
    @IBAction func buttonFilterClick(_ sender: Any) {
        let vc = FilterPengajuanLemburTabController()
        vc.delegate = self
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func buttonBackClick(_ sender: Any) {
        if let _ = afterAddLeave {
            backToHome()
        } else {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    private func backToHome() {
        let transition = CATransition()
        transition.duration = 0.4
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromLeft
        self.navigationController?.view.layer.add(transition, forKey: kCATransition)
        self.navigationController?.pushViewController(HomeController(), animated: true)
    }
}
