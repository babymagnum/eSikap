//
//  TabPersetujuanController.swift
//  Angkasa Pura Solusi
//
//  Created by Arief Zainuri on 09/08/19.
//  Copyright © 2019 Gama Techno. All rights reserved.
//

import UIKit
import XLPagerTabStrip

class TabPersetujuanController: ButtonBarPagerTabStripViewController {

    @IBOutlet weak var viewRootTopMargin: NSLayoutConstraint!
    
    lazy var function: PublicFunction = {
        let mFunction = PublicFunction()
        return mFunction
    }()
    
    var pages = [UIViewController]()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidLoad() {
        setupTabLayout()
        
        super.viewDidLoad()
        
        function.changeStatusBar(hexCode: 0x42a5f5, view: self.view, opacity: 1)
        
        if #available(iOS 11, *) {
            self.viewRootTopMargin.constant = 0
        } else {
            self.viewRootTopMargin.constant = UIApplication.shared.statusBarFrame.height
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
        pages.append(DelegasiCutiController())
        pages.append(CutiController())
        //pages.append(LemburController())
        return pages
    }
}

extension TabPersetujuanController {
    @IBAction func buttonBackClick(_ sender: Any) { navigationController?.popViewController(animated: true) }
}
