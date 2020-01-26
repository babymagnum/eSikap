//
//  RealisasiLemburTabController.swift
//  Angkasa Pura Solusi
//
//  Created by Arief Zainuri on 26/01/20.
//  Copyright © 2020 Gama Techno. All rights reserved.
//

import UIKit
import XLPagerTabStrip

class RealisasiLemburTabController: UIViewController, IndicatorInfoProvider {

    var year: String?
    var status: String?
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "REALISASI")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
