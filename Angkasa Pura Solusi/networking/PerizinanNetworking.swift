//
//  PerizinanNetworking.swift
//  Angkasa Pura Solusi
//
//  Created by Arief Zainuri on 17/08/19.
//  Copyright © 2019 Gama Techno. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class PerizinanNetworking {
    lazy var preference: Preference = {
        let mPreference = Preference()
        return mPreference
    }()
    
    lazy var staticLet: StaticLet = {
        let mStaticLet = StaticLet()
        return mStaticLet
    }()
    
    func getLeaveType(completion: @escaping(_ error: String?, _ leaveQuota: LeaveType?, _ isExpired: Bool?) -> Void) {
        let headers : [String: String] = [
            "Authorization": "Bearer \(preference.getString(key: staticLet.TOKEN))"
        ]
        
        let url = "\(staticLet.base_url)api/getLeaveType"
        
        Alamofire.request(url, method: .get, headers: headers).responseJSON { (response) in
            switch response.result {
            case .success(let success):
                let status = JSON(success)["status"].int
                let message = JSON(success)["message"].string
                
                if status == 200 {
                    guard let mData = response.data else { return }
                    
                    do {
                        let leaveType = try JSONDecoder().decode(LeaveType.self, from: mData)
                        completion(nil, leaveType, nil)
                    } catch let err { completion(err.localizedDescription, nil, nil) }
                    
                } else if status == 401 {
                    completion(nil, nil, true)
                } else {
                    completion(message, nil, nil)
                }
            case .failure(let error): completion(error.localizedDescription, nil, nil)
            }
        }
    }
    
    func getLeaveQuota(completion: @escaping(_ error: String?, _ leaveQuota: LeaveQuota?, _ isExpired: Bool?) -> Void) {
        let headers : [String: String] = [
            "Authorization": "Bearer \(preference.getString(key: staticLet.TOKEN))"
        ]
        
        let url = "\(staticLet.base_url)api/getLeaveQuota"
        
        Alamofire.request(url, method: .post, headers: headers).responseJSON { (response) in
            switch response.result {
            case .success(let success):
                let status = JSON(success)["status"].int
                let message = JSON(success)["message"].string
                
                if status == 200 {
                    guard let mData = response.data else { return}
                    
                    do {
                        let leaveQuota = try JSONDecoder().decode(LeaveQuota.self, from: mData)
                        completion(nil, leaveQuota, nil)
                    } catch let err { completion(err.localizedDescription, nil, nil) }
                    
                } else if status == 401 {
                    completion(nil, nil, true)
                } else {
                    completion(message, nil, nil)
                }
            case .failure(let error): completion(error.localizedDescription, nil, nil)
            }
        }
    }
}
