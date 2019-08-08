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
    
    func getPreparePresence(completion: @escaping(_ error: String?, _ prepare: ItemPreparePresence?, _ isExpired: Bool?) -> Void) {
        let url = "\(staticLet.base_url)api/getPreparePresence"
        let headers: [String: String] = [
            "Authorization": "Bearer \(preference.getString(key: staticLet.TOKEN))"
        ]
        
        Alamofire.request(url, method: .post, headers: headers).responseJSON { (response) in
            switch response.result {
            case .success:
                
                let data = response.data
                
                guard let mData = data else {
                    completion("Error null data, please try again later", nil, nil)
                    return
                }
                
                do {
                    let preparePresence = try JSONDecoder().decode(PreparePresence.self, from: mData)
                    
                    if preparePresence.status == 200 {
                        completion(nil, preparePresence.data, nil)
                    } else if preparePresence.status == 401 {
                        completion(nil, nil, true)
                    } else {
                        completion(preparePresence.message, nil, nil)
                    }
                } catch let err { completion(err.localizedDescription, nil, nil) }
                
            case .failure(let responseFailure): completion(responseFailure.localizedDescription, nil, nil)
            }
        }
    }
    
    func addPresence(request: (checkpoint_id: String, presence_type: String, latitude: String, longitude: String), completion: @escaping(_ error: String?, _ isExpired: Bool?) -> Void) {
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
    
    func getPresenceList(request: (month: String, year: String), completion: @escaping (_ error: String?, _ listPresensi: [ItemPresensi]?, _ isExpired: Bool?) -> Void) {
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
            case .success:
                
                let data = response.data
                
                guard let mData = data else {
                    completion("Error null data, please try again later", nil, nil)
                    return
                }
                
                do {
                    let presensi = try JSONDecoder().decode(Presensi.self, from: mData)
                    
                    if presensi.status == 200 {
                        completion(nil, presensi.data, nil)
                    } else if presensi.status == 401 {
                        completion(nil, nil, true)
                    } else {
                        completion(presensi.message, nil, nil)
                    }
                } catch let err { completion(err.localizedDescription, nil, nil) }
                
            case .failure(let responseFailure): completion(responseFailure.localizedDescription, nil, nil)
            }
        }
    }
}
