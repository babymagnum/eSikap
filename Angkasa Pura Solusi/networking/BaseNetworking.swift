//
//  BaseNetworking.swift
//  Angkasa Pura Solusi
//
//  Created by Arief Zainuri on 26/08/19.
//  Copyright © 2019 Gama Techno. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class BaseNetworking {
    
    lazy var staticLet: StaticLet = { return StaticLet() }()
    lazy var preference: Preference = { return Preference() }()
    lazy var function: PublicFunction = { return PublicFunction() }()
    
    func getHeaders() -> [String: String] {
        return [ "Authorization": "Bearer \(preference.getString(key: staticLet.TOKEN))" ]
    }
    
    func alamofirePost<T: Decodable>(url: String, headers: [String: String]?, body: [String: String]?, completion : @escaping(_ error: String?, _ object: T?, _ isExpired: Bool?) -> Void) {
        
        Alamofire.request(url, method: .post, parameters: body, headers: headers).responseJSON { (response) in
            
            switch response.result {
            case .success(let success):
                let status = JSON(success)["status"].int
                let message = JSON(success)["message"].string
                
                if status == 200 {
                    guard let mData = response.data else { return}
                    
                    do {
                        let data = try JSONDecoder().decode(T.self, from: mData)
                        completion(nil, data, nil)
                    } catch let err { completion(err.localizedDescription, nil, nil) }
                    
                } else if status == 401 {
                    completion(nil, nil, true)
                } else {
                    completion(message, nil, nil)
                }
                
            case .failure(let error):
                completion(error.localizedDescription, nil, nil)
            }
            
        }
        
    }
    
    func alamofirePostFormData<T: Decodable>(url: String, headers: [String: String]?, body: [String: String]?, completion : @escaping(_ error: String?, _ object: T?, _ isExpired: Bool?) -> Void) {
        
        Alamofire.request(url, method: .post, parameters: (body as! Parameters), headers: headers).responseJSON { (response) in
            
            switch response.result {
            case .success(let success):
                let status = JSON(success)["status"].int
                let message = JSON(success)["message"].string
                
                if status == 200 {
                    guard let mData = response.data else { return}
                    
                    do {
                        let data = try JSONDecoder().decode(T.self, from: mData)
                        completion(nil, data, nil)
                    } catch let err { completion(err.localizedDescription, nil, nil) }
                    
                } else if status == 401 {
                    completion(nil, nil, true)
                } else {
                    completion(message, nil, nil)
                }
                
            case .failure(let error):
                completion(error.localizedDescription, nil, nil)
            }
            
        }
        
    }
    
    func alamofirePostJSONRequest<T: Decodable>(url: String, headers: [String: String]?, body: [String: String]?, completion : @escaping(_ error: String?, _ object: T?, _ isExpired: Bool?) -> Void) {
        
        Alamofire.request(url, method: .post, parameters: body, encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in
            switch response.result {
            case .success(let success):
                let status = JSON(success)["status"].int
                let message = JSON(success)["message"].string
                
                if status == 200 {
                    guard let mData = response.data else { return}
                    
                    do {
                        let data = try JSONDecoder().decode(T.self, from: mData)
                        completion(nil, data, nil)
                    } catch let err { completion(err.localizedDescription, nil, nil) }
                    
                } else if status == 401 {
                    completion(nil, nil, true)
                } else {
                    completion(message, nil, nil)
                }
                
            case .failure(let error):
                completion(error.localizedDescription, nil, nil)
            }
        }
        
    }
    
    func alamofireGet<T: Decodable>(url: String, headers: [String: String]?, body: [String: String]?, completion: @escaping (_ error: String?, T?, _ isExpired: Bool?) -> Void) {
        
        Alamofire.request(url, method: .get, parameters: body, headers: headers).responseJSON { (response) in
            
            switch response.result {
            case .success(let success):
                let status = JSON(success)["status"].int
                let message = JSON(success)["message"].string
                
                if status == 200 {
                    guard let mData = response.data else { return}
                    
                    do {
                        let data = try JSONDecoder().decode(T.self, from: mData)
                        completion(nil, data, nil)
                    } catch let err { completion(err.localizedDescription, nil, nil) }
                    
                } else if status == 401 {
                    completion(nil, nil, true)
                } else {
                    completion(message, nil, nil)
                }
                
            case .failure(let error):
                completion(error.localizedDescription, nil, nil)
            }
            
        }
        
    }
    
    func alamofireDelete<T: Decodable>(url: String, headers: [String: String]?, body: [String: String]?, completion : @escaping(_ error: String?, _ object: T?, _ isExpired: Bool?) -> Void) {
        
        Alamofire.request(url, method: .delete, parameters: body, headers: headers).responseJSON { (response) in
            
            switch response.result {
            case .success(let success):
                let status = JSON(success)["status"].int
                let message = JSON(success)["message"].string
                
                if status == 200 {
                    guard let mData = response.data else { return}
                    
                    do {
                        let data = try JSONDecoder().decode(T.self, from: mData)
                        completion(nil, data, nil)
                    } catch let err { completion(err.localizedDescription, nil, nil) }
                    
                } else if status == 401 {
                    completion(nil, nil, true)
                } else {
                    completion(message, nil, nil)
                }
                
            case .failure(let error):
                completion(error.localizedDescription, nil, nil)
            }
            
        }
        
    }
    
}