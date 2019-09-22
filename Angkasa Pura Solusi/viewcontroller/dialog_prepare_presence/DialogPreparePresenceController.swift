//
//  DialogPreparePresenceController.swift
//  Angkasa Pura Solusi
//
//  Created by Arief Zainuri on 02/08/19.
//  Copyright © 2019 Gama Techno. All rights reserved.
//

import UIKit

class DialogPreparePresenceController: UIViewController {

    @IBOutlet weak var viewContainerHeight: NSLayoutConstraint!
    @IBOutlet weak var viewContainer: UIView!
    @IBOutlet weak var labelDescription: UILabel!
    @IBOutlet weak var buttonOke: UIButton!
    @IBOutlet weak var imageX: UIImageView!
    
    var stringDescription: String?
    var image: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    private func initView() {
        buttonOke.layer.cornerRadius = 5
        viewContainer.layer.cornerRadius = 4
        
        labelDescription.text = stringDescription
        if let image = image {
            imageX.image = UIImage(named: image)
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            UIView.animate(withDuration: 0.2) {
                self.viewContainerHeight.constant = self.imageX.frame.height + self.labelDescription.getHeight(width: self.labelDescription.frame.width) + self.buttonOke.frame.height + 62.1 + 47 + 39 + 23
                self.view.layoutIfNeeded()
            }
        }
    }

    @IBAction func buttonOkeClick(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
