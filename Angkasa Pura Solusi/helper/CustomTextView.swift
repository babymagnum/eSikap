//
//  CustomTextView.swift
//  Angkasa Pura Solusi
//
//  Created by Arief Zainuri on 13/08/19.
//  Copyright © 2019 Gama Techno. All rights reserved.
//

import Foundation
import UIKit

class CustomTextView: UITextView {
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        self.commonInit()
    }
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)        
        self.commonInit()
    }
    
    func commonInit(){
        if (UIScreen.main.bounds.width == 320) {
            self.font = UIFont(name: self.font!.fontName, size: self.font!.pointSize + 2)
        } else if (UIScreen.main.bounds.width == 375) {
            self.font = UIFont(name: self.font!.fontName, size: self.font!.pointSize + 3)
        } else if (UIScreen.main.bounds.width == 414) {
            self.font = UIFont(name: self.font!.fontName, size: self.font!.pointSize + 4)
        } else {
            self.font = UIFont(name: self.font!.fontName, size: self.font!.pointSize + 5)
        }
    }
}
