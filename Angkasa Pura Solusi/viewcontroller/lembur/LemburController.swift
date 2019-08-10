//
//  LemburController.swift
//  Angkasa Pura Solusi
//
//  Created by Arief Zainuri on 09/08/19.
//  Copyright © 2019 Gama Techno. All rights reserved.
//

import UIKit
import XLPagerTabStrip

class LemburController: UIViewController, IndicatorInfoProvider {
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "LEMBUR")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

}
