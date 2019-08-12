//
//  CustomTextField.swift
//  Angkasa Pura Solusi
//
//  Created by Arief Zainuri on 12/08/19.
//  Copyright © 2019 Gama Techno. All rights reserved.
//

import Foundation
import UIKit

class CustomTextField: UITextField {
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        self.commonInit()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }
    
    func commonInit(){
        if (UIScreen.main.bounds.width == 320) {
            self.font = UIFont(name: self.font!.fontName, size: self.font!.pointSize + 2.5)
        } else if (UIScreen.main.bounds.width == 375) {
            self.font = UIFont(name: self.font!.fontName, size: self.font!.pointSize + 3.5)
        } else if (UIScreen.main.bounds.width == 414) {
            self.font = UIFont(name: self.font!.fontName, size: self.font!.pointSize + 4.5)
        } else {
            self.font = UIFont(name: self.font!.fontName, size: self.font!.pointSize + 5.5)
        }
    }
}
