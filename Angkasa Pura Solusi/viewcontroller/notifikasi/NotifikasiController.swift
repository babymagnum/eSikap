//
//  NotifikasiController.swift
//  Angkasa Pura Solusi
//
//  Created by Arief Zainuri on 28/07/19.
//  Copyright © 2019 Gama Techno. All rights reserved.
//

import UIKit

class NotifikasiController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        function.changeStatusBar(hexCode: 0x42a5f5, view: self.view, opacity: 1.0)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle { return .lightContent }

}
