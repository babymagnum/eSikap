//
//  DialogSendEmailController.swift
//  Angkasa Pura Solusi
//
//  Created by Arief Zainuri on 05/09/19.
//  Copyright © 2019 Gama Techno. All rights reserved.
//

import UIKit

class DialogSendEmailController: BaseViewController {

    @IBOutlet weak var labelEmail: CustomLabel!
    @IBOutlet weak var buttonOke: CustomButton!
    @IBOutlet weak var viewContainer: UIView!
    
    var email: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initView()
    }
    
    private func initView() {
        buttonOke.layer.cornerRadius = 5
        
        labelEmail.text = email
    }

    @IBAction func buttonOkeClick(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}
