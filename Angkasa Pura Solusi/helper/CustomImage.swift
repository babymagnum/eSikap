//
//  CustomImage.swift
//  Angkasa Pura Solusi
//
//  Created by Arief Zainuri on 12/08/19.
//  Copyright © 2019 Gama Techno. All rights reserved.
//

import Foundation
import UIKit

class CustomImage: UIImageView {
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
            self.frame = CGRect(x: self.frame.origin.x, y: self.frame.origin.y, width: self.frame.width + 2, height: self.frame.height + 2)
        } else if (UIScreen.main.bounds.width == 375) {
            self.frame = CGRect(x: self.frame.origin.x, y: self.frame.origin.y, width: self.frame.width + 3, height: self.frame.height + 3)
        } else if (UIScreen.main.bounds.width == 414) {
            self.frame = CGRect(x: self.frame.origin.x, y: self.frame.origin.y, width: self.frame.width + 4, height: self.frame.height + 4)
        } else {
            self.frame = CGRect(x: self.frame.origin.x, y: self.frame.origin.y, width: self.frame.width + 5, height: self.frame.height + 5)
        }
    }
}
