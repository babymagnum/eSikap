//
//  DialogFirstController.swift
//  Angkasa Pura Solusi
//
//  Created by Arief Zainuri on 02/08/19.
//  Copyright © 2019 Gama Techno. All rights reserved.
//

import UIKit
import Foundation

class DialogFirstController: BaseViewController {

    @IBOutlet weak var viewRoot: UIView!
    @IBOutlet weak var viewContainerHeight: NSLayoutConstraint!
    @IBOutlet weak var viewContainer: UIView!
    @IBOutlet weak var imageAnnouncement: UIImageView!
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var labelDescription: UILabel!
    
    var resources: (image: String, title: String, description: String)?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initView()
        
        initEvent()
    }
    
    private func initEvent() {
        viewRoot.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(viewRootClick)))
        viewContainer.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(viewContainerClick)))
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        UIView.animate(withDuration: 0.2) {
            self.viewContainerHeight.constant = self.viewContainer.getHeight() + 12
            self.view.layoutIfNeeded()
        }
    }
    
    private func initView() {
        viewContainer.layer.cornerRadius = 4
        
        if let data = resources {
            imageAnnouncement.loadUrl(data.image)
            labelTitle.text = data.title
            labelDescription.text = data.description
        }
    }
    
    private func cancel() {
        print("cancel click")
        preference.saveBool(value: true, key: staticLet.IS_SHOW_FIRST_DIALOG)
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func iconCancelClick(_ sender: Any) { cancel() }
    
    @objc func viewRootClick() { cancel() }
    
    @objc func viewContainerClick() { cancel() }
}
