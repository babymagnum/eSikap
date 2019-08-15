//
//  NotifikasiController.swift
//  Angkasa Pura Solusi
//
//  Created by Arief Zainuri on 28/07/19.
//  Copyright © 2019 Gama Techno. All rights reserved.
//

import UIKit

class NotifikasiController: BaseViewController {

    @IBOutlet weak var viewRootTopMargin: NSLayoutConstraint!
    @IBOutlet weak var notifikasiCollectionView: UICollectionView!
    
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(handleRefresh(_:)),for: UIControl.Event.valueChanged)
        refreshControl.tintColor = UIColor.blue
        
        return refreshControl
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        checkTopMargin(viewRootTopMargin: viewRootTopMargin)
        
        function.changeStatusBar(hexCode: 0x42a5f5, view: self.view, opacity: 1.0)
        
        initCollectionView()
    }
    
    private func initCollectionView() {
        notifikasiCollectionView.addSubview(refreshControl)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle { return .lightContent }

}

extension NotifikasiController {
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        refreshControl.endRefreshing()
        // do something
    }
}
