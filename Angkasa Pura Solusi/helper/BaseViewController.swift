//
//  BaseViewController.swift
//  Angkasa Pura Solusi
//
//  Created by Arief Zainuri on 27/07/19.
//  Copyright © 2019 Gama Techno. All rights reserved.
//

import Foundation
import UIKit

class BaseViewController: UIViewController {
    
    lazy var preference: Preference = {
        let mPreference = Preference()
        return mPreference
    }()
    
    lazy var staticLet: StaticLet = {
        let mStaticLet = StaticLet()
        return mStaticLet
    }()
    
    lazy var function: PublicFunction = {
        let mFunction = PublicFunction()
        return mFunction
    }()
    
    lazy var authNetworking: AuthenticationNetworking = {
        let mAuthNetworking = AuthenticationNetworking()
        return mAuthNetworking
    }()
    
    lazy var presenceNetworking: PresenceNetworking = {
        let mPresenceNetworking = PresenceNetworking()
        return mPresenceNetworking
    }()
    
    lazy var informationNetworking: InformationNetworking = {
        let mInformationNetworking = InformationNetworking()
        return mInformationNetworking
    }()
    
    override func viewDidLoad() {
        //do something
    }

}
