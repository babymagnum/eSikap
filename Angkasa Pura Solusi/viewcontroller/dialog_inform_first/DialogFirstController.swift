//
//  DialogFirstController.swift
//  Angkasa Pura Solusi
//
//  Created by Arief Zainuri on 02/08/19.
//  Copyright © 2019 Gama Techno. All rights reserved.
//

import UIKit

class DialogFirstController: UIViewController {

    @IBOutlet weak var viewContainer: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initView()
    }
    
    private func initView() {
        viewContainer.layer.cornerRadius = 4
    }
    
    @IBAction func iconCancelClick(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
