//
//  DialogPreparePresenceController.swift
//  Angkasa Pura Solusi
//
//  Created by Arief Zainuri on 02/08/19.
//  Copyright © 2019 Gama Techno. All rights reserved.
//

import UIKit

class DialogPreparePresenceController: UIViewController {

    @IBOutlet weak var viewContainer: UIView!
    @IBOutlet weak var labelDescription: UILabel!
    @IBOutlet weak var buttonOke: UIButton!
    
    var stringDescription: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initView()
    }
    
    private func initView() {
        buttonOke.layer.cornerRadius = 5
        viewContainer.layer.cornerRadius = 4
        
        labelDescription.text = stringDescription
    }

    @IBAction func buttonOkeClick(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
