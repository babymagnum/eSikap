//
//  AuthenticationNetworking.swift
//  Angkasa Pura Solusi
//
//  Created by Arief Zainuri on 01/08/19.
//  Copyright © 2019 Gama Techno. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class AuthenticationNetworking: BaseNetworking {
        
    func logout(completion: @escaping(_ error: String?, _ logout: Logout?, _ isExpired: Bool?) -> Void) {
        let url = "\(baseUrl())api/logout"
        alamofirePost(url: url, headers: getHeaders(), body: nil, completion: completion)
    }
    
    func login(_ email: String, _ password: String, completion: @escaping(_ message: String?) -> Void) {
        let url = "\(baseUrl())api/login"
        print("url: \(url)")
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
    
    func changePassword(request: (new_password: String, old_password: String), completion: @escaping (_ error: String?, _ isExpired: Bool?) -> Void) {
        
        let url = "\(baseUrl())api/changePassword"
        let headers: [String: String] = [
            "Authorization": "Bearer \(preference.getString(key: staticLet.TOKEN))"
        ]
        let body: [String: String] = [
            "new_password": request.new_password,
            "old_password": request.old_password
        ]
        
        Alamofire.request(url, method: .post, parameters: body, headers: headers).responseJSON { (response) in
            switch response.result {
            case .success(let responseSuccess):
                let root = JSON(responseSuccess)
                
                print("change password \(root)")
                
                if root["status"].int == 200 {
                    completion(nil, nil)
                } else if root["status"].int == 401 {
                    completion(nil, true)
                } else {
                    completion(root["message"].string, nil)
                }
            case .failure(let responseFailure):
                completion(responseFailure.localizedDescription, nil)
            }
        }
    }
}
