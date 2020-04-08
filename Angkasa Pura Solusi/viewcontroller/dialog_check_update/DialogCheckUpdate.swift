//
//  DialogCheckUpdate.swift
//  Angkasa Pura Solusi
//
//  Created by Arief Zainuri on 08/04/20.
//  Copyright © 2020 Gama Techno. All rights reserved.
//

import UIKit

class DialogCheckUpdate: UIViewController {

    @IBOutlet weak var buttonUpdate: CustomButton!
    @IBOutlet weak var labelContent: CustomLabel!
    @IBOutlet weak var viewDialog: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setView()
    }
    
    private func setView() {
        buttonUpdate.layer.cornerRadius = 5
        labelContent.font = UIFont(name: "Roboto-Medium", size: labelContent.font.pointSize)
        viewDialog.layer.cornerRadius = 10
    }
    
    @IBAction func buttonUpdateClick(_ sender: Any) {
        if let url = URL(string: "https://apps.apple.com/id/app/esikap/id1481214579"),
            UIApplication.shared.canOpenURL(url)
        {
            print(url)
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
    }
}
