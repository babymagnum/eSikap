//
//  DialogFirstController.swift
//  Angkasa Pura Solusi
//
//  Created by Arief Zainuri on 02/08/19.
//  Copyright © 2019 Gama Techno. All rights reserved.
//

import UIKit
import Foundation

class DialogFirstController: UIViewController {

    @IBOutlet weak var viewContainerHeight: NSLayoutConstraint!
    @IBOutlet weak var viewContainer: UIView!
    @IBOutlet weak var imageAnnouncement: UIImageView!
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var labelDescription: UILabel!
    
    var resources: (image: String, title: String, description: String)?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initView()
    }
    
    private func initView() {
        viewContainer.layer.cornerRadius = 4
        
        if let data = resources {
            imageAnnouncement.loadUrl(data.image)
            labelTitle.text = data.title
            labelDescription.text = data.description
        }
        
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.2) {
                self.viewContainerHeight.constant = self.imageAnnouncement.frame.height + self.labelTitle.getHeight(width: self.labelTitle.frame.width) + self.labelDescription.getHeight(width: self.labelDescription.frame.width) + 34
                self.view.layoutIfNeeded()
            }
        }
    }
    
    @IBAction func iconCancelClick(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
