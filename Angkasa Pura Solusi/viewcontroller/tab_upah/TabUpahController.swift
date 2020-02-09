//
//  TabUpahController.swift
//  Angkasa Pura Solusi
//
//  Created by Arief Zainuri on 20/01/20.
//  Copyright © 2020 Gama Techno. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import FittedSheets

class TabUpahController: ButtonBarPagerTabStripViewController {

    @IBOutlet weak var constraintViewRoot: NSLayoutConstraint!
    
    lazy var function: PublicFunction = {
        let mFunction = PublicFunction()
        return mFunction
    }()
    
    private var year = ""
    private var month = ""
    private var pages = [UIViewController]()
    
    override func viewDidLoad() {
        setupTabLayout()
        
        super.viewDidLoad()
        
        function.changeStatusBar(hexCode: 0x42a5f5, view: self.view, opacity: 1)
        
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        }
        
        if #available(iOS 11, *) {
            self.constraintViewRoot.constant = 0
        } else {
            self.constraintViewRoot.constant = UIApplication.shared.statusBarFrame.height
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle { return .lightContent }
    
    func setupTabLayout() {
        // change selected bar color
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
        let slipGajiController = SlipGajiController()
        slipGajiController.year = self.year
        
        let bonusController = BonusController()
        bonusController.year = self.year
        
        pages.append(slipGajiController)
        pages.append(bonusController)
        return pages
    }

}

extension TabUpahController: BottomSheetFilterPresensiProtocol {
    func filterPicked(_ month: String, _ year: String) {
        self.year = year
        pages.removeAll()
        reloadPagerTabStripView()
    }
    
    @IBAction func buttonBackClick(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func buttonFilterClick(_ sender: Any) {
        let vc = BottomSheetFilterPresensi()
        vc.delegate = self
        vc.onlyYear = true
        let sheetController = SheetViewController(controller: vc)
        self.present(sheetController, animated: false, completion: nil)
    }
}
