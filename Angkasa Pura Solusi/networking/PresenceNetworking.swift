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

class PresenceNetworking {
    lazy var preference: Preference = {
        let mPreference = Preference()
        return mPreference
    }()
    
    lazy var staticLet: StaticLet = {
        let mStaticLet = StaticLet()
        return mStaticLet
    }()
    
    func getPreparePresence(completion: @escaping(_ error: String?, _ prepare: PreparePresence?) -> Void) {
        let url = "\(staticLet.base_url)api/getPreparePresence"
        let headers: [String: String] = [
            "Authorization": "Bearer \(preference.getString(key: staticLet.TOKEN))"
        ]
        
        Alamofire.request(url, method: .post, headers: headers).responseJSON { (response) in
            switch response.result {
            case .success(let responseSuccess):
                let root = JSON(responseSuccess)
                
                print("prepare presence \(root)")
                
                if root["status"].int == 200 {
                    var prepare = PreparePresence()
                    completion(nil, prepare.convertJSON(root))
                } else {
                    completion(root["message"].string, nil)
                }
                
            case .failure(let responseError):
                completion(responseError.localizedDescription, nil)
            }
        }
    }
    
    func addPresence(request: (checkpoint_id: String, presence_type: String, latitude: String, longitude: String), completion: @escaping(_ error: String?) -> Void) {
        let url = "\(staticLet.base_url)api/addPresence"
        let headers: [String: String] = [
            "Authorization": "Bearer \(preference.getString(key: staticLet.TOKEN))"
        ]
        let body: [String: String] = [
            "checkpoint_id": request.checkpoint_id,
            "presence_type": request.presence_type,
            "latitude": request.latitude,
            "longitude": request.longitude
        ]
        
        Alamofire.request(url, method: .post, parameters: body, headers: headers).responseJSON { (response) in
            switch response.result {
            case .success(let responseSuccess):
                let root = JSON(responseSuccess)
                
                print("presence \(root)")
                
                if root["status"].int == 201 {
                    completion(nil)
                } else {
                    completion(root["message"].string)
                }
            case .failure(let responseFailure):
                completion(responseFailure.localizedDescription)
            }
        }
    }
    
    func getPresenceList(request: (month: String, year: String)) {
        let url = "\(staticLet.base_url)api/getPresenceList"
        let headers: [String: String] = [
            "Authorization": "Bearer \(preference.getString(key: staticLet.TOKEN))"
        ]
        let body: [String: String] = [
            "month": request.month,
            "year": request.year
        ]
        
        Alamofire.request(url, method: .post, parameters: body, headers: headers).responseJSON { (response) in
            switch response.result {
            case .success(let responseSuccess):
                let root = JSON(responseSuccess)
                
                if root["status"].int == 200 {
                    // TODO do something with the list
                } else {
                    // TODO do something if status is not 200
                }
            case .failure(let responseFailure):
                print(responseFailure.localizedDescription)
            }
        }
    }
}
