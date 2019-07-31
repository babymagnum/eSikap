//
//  CoreNetworking.swift
//  Angkasa Pura Solusi
//
//  Created by Arief Zainuri on 27/07/19.
//  Copyright © 2019 Gama Techno. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class CoreNetworking {
    lazy var preference: Preference = {
        let mPreference = Preference()
        return mPreference
    }()
    
    lazy var staticLet: StaticLet = {
        let mStaticLet = StaticLet()
        return mStaticLet
    }()
    
    func login(_ email: String, _ password: String, completion: @escaping(_ message: String?) -> Void) {
        let url = "http://aps-dev.eoviz.com/ess-mobile-api/index.php/api/login"
        let body: [String : String] = [
            "username": email,
            "password": password,
            "fcm": preference.getString(key: staticLet.FCM_TOKEN),
            "unique_id": UIDevice.current.identifierForVendor!.uuidString,
            "phone_brand": "iPhone",
            "phone_series": UIDevice.modelName
        ]
        
        Alamofire.request(url, method: .post, parameters: body).responseJSON { (response) in
            switch response.result {
                
            case .success(let responseSuccess):
                let data = JSON(responseSuccess)
                print("login \(data)")
                
                if data["message"].string == "Login Berhasil" {
                    let dataEmploye = data["data"].array![0]
                    self.preference.saveString(value: dataEmploye["user_id"].string ?? "", key: self.staticLet.USER_ID)
                    self.preference.saveString(value: dataEmploye["emp_photo"].string ?? "", key: self.staticLet.EMP_PHOTO)
                    self.preference.saveString(value: dataEmploye["emp_id"].string ?? "", key: self.staticLet.EMP_ID)
                    self.preference.saveString(value: dataEmploye["emp_number"].string ?? "", key: self.staticLet.EMP_NUMBER)
                    self.preference.saveString(value: dataEmploye["emp_name"].string ?? "", key: self.staticLet.EMP_NAME)
                    self.preference.saveString(value: dataEmploye["token"].string ?? "", key: self.staticLet.TOKEN)
                    completion(nil)
                } else {
                    completion(data["message"].string)
                }
                
            case .failure(let responseError):
                print("login error \(responseError.localizedDescription)")
                completion(responseError.localizedDescription)
            }
        }
    }
}
