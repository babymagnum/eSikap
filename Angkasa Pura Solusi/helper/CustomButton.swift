//
//  CustomButton.swift
//  Angkasa Pura Solusi
//
//  Created by Arief Zainuri on 12/08/19.
//  Copyright © 2019 Gama Techno. All rights reserved.
//

import Foundation
import UIKit

class CustomButton: UIButton {
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
            self.titleLabel?.font = UIFont(name: (self.titleLabel?.font.fontName)!, size: (self.titleLabel?.font.pointSize)! + 2)
        } else if (UIScreen.main.bounds.width == 375) {
            self.titleLabel?.font = UIFont(name: (self.titleLabel?.font.fontName)!, size: (self.titleLabel?.font.pointSize)! + 3)
        } else if (UIScreen.main.bounds.width == 414) {
            self.titleLabel?.font = UIFont(name: (self.titleLabel?.font.fontName)!, size: (self.titleLabel?.font.pointSize)! + 4)
        } else {
            self.titleLabel?.font = UIFont(name: (self.titleLabel?.font.fontName)!, size: (self.titleLabel?.font.pointSize)! + 5)
        }
    }
}
