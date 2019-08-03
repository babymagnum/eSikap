//
//  InformationNetworking.swift
//  Angkasa Pura Solusi
//
//  Created by Arief Zainuri on 01/08/19.
//  Copyright © 2019 Gama Techno. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class InformationNetworking {
    lazy var preference: Preference = {
        let mPreference = Preference()
        return mPreference
    }()
    
    lazy var staticLet: StaticLet = {
        let mStaticLet = StaticLet()
        return mStaticLet
    }()
    
    func getDashboard(completion: @escaping(_ error: String?, _ dashboard: ItemDashboard?) -> Void) {
        guard let url = URL(string: "\(staticLet.base_url)api/getDashboard") else { return }
        var request = URLRequest(url: url)
        request.setValue("Bearer \(preference.getString(key: staticLet.TOKEN))", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                completion(error.localizedDescription, nil)
                return
            }
            
            guard let data = data else {
                completion("error", nil)
                return
            }
            
            do {
                let dashboard = try JSONDecoder().decode(Dashboard.self, from: data)
                
                if dashboard.status == 200 {
                    completion(nil, dashboard.data[0])
                } else {
                    completion(dashboard.message, nil)
                }
            } catch let err { completion(err.localizedDescription, nil) }
            }.resume()
    }
    
    func getLatestNews(completion: @escaping (_ error: String?, _ listNews: [News]?) -> Void) {
        guard let url = URL(string: "\(staticLet.base_url)api/getLatestNews") else { return }
        var request = URLRequest(url: url)
        request.setValue("Bearer \(preference.getString(key: staticLet.TOKEN))", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                completion(error.localizedDescription, nil)
                return
            }
            
            guard let data = data else {
                completion("Error null data, please try again later", nil)
                return
            }
            
            do {
                let latestNew = try JSONDecoder().decode(LatestNews.self, from: data)
                
                if latestNew.status == 200 {
                    completion(nil, latestNew.data)
                } else {
                    completion(latestNew.message, nil)
                }
            } catch let err { completion(err.localizedDescription, nil) }
            }.resume()
    }
    
    func getNewsDetail(newsId: String, completion: @escaping (_ error: String?, _ itemDetailNews: ItemDetailNews?) -> Void) {
        let url = "\(staticLet.base_url)api/getNewsDetail"
        let body : [String: String] = [ "news_id": newsId ]
        let headers: [String: String] = [ "Authorization": "Bearer \(preference.getString(key: staticLet.TOKEN))" ]
        
        Alamofire.request(url, method: .post, parameters: body, headers: headers).responseJSON { (response) in
            switch response.result {
            case .success:
                let data = response.data
                
                guard let mData = data else {
                    completion("Error null data, please try again later", nil)
                    return
                }
                
                do {
                    let detailNews = try JSONDecoder().decode(DetailNews.self, from: mData)
                    
                    if detailNews.status == 200 {
                        print("detail news \(detailNews.data[0])")
                        completion(nil, detailNews.data[0])
                    } else {
                        completion(detailNews.message, nil)
                    }
                } catch let err { completion(err.localizedDescription, nil) }
                
            case .failure(let error): completion(error.localizedDescription, nil)
            }
        }
    }
    
    func getAllNews(page: Int, completion: @escaping (_ error: String?, _ listNews: [News]?) -> Void) {
        
        let url = "\(staticLet.base_url)api/getAllNews"
        let body : [String: String] = [
            "page": "\(page)"
        ]
        let headers: [String: String] = [
            "Authorization": "Bearer \(preference.getString(key: staticLet.TOKEN))"
        ]
        
        Alamofire.request(url, method: .post, parameters: body, headers: headers).responseJSON { (response) in
            switch response.result{
            case .success:
                
                let data = response.data
                
                guard let mData = data else {
                    completion("Error null data, please try again later", nil)
                    return
                }
                
                do {
                    let latestNew = try JSONDecoder().decode(AllNews.self, from: mData)
                
                    if latestNew.status == 200 {
                        completion(nil, latestNew.data?.news)
                    } else {
                        completion(latestNew.message, nil)
                    }
                } catch let err { completion(err.localizedDescription, nil) }
                
            case .failure(let responseFailure):
                completion(responseFailure.localizedDescription, nil)
            }
        }
    }
    
    func getProfile(completion: @escaping (_ error: String?, _ profile: ItemProfile?) -> Void) {
        let url = "\(staticLet.base_url)api/getProfile"
        let headers: [String: String] = [ "Authorization": "Bearer \(preference.getString(key: staticLet.TOKEN))" ]
        
        Alamofire.request(url, method: .post, headers: headers).responseJSON { (response) in
            switch response.result{
            case .success:
                
                let data = response.data
                
                guard let mData = data else {
                    completion("Error null data, please try again later", nil)
                    return
                }
                
                do {
                    let profile = try JSONDecoder().decode(Profile.self, from: mData)
                    
                    if profile.status == 200 {
                        completion(nil, profile.data[0])
                    } else {
                        completion(profile.message, nil)
                    }
                } catch let err { completion(err.localizedDescription, nil) }
                
            case .failure(let responseFailure):
                completion(responseFailure.localizedDescription, nil)
            }
        }
    }
}
