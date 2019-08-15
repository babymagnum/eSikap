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
    
    func getDashboard(completion: @escaping(_ error: String?, _ dashboard: ItemDashboard?, _ isExpired: Bool?) -> Void) {
        guard let url = URL(string: "\(staticLet.base_url)api/getDashboard") else { return }
        var request = URLRequest(url: url)
        request.setValue("Bearer \(preference.getString(key: staticLet.TOKEN))", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                completion(error.localizedDescription, nil, nil)
                return
            }
            
            guard let data = data else {
                completion("error", nil, nil)
                return
            }
            
            do {
                let dashboard = try JSONDecoder().decode(Dashboard.self, from: data)
                
                if dashboard.status == 200 {
                    completion(nil, dashboard.data[0], nil)
                } else if dashboard.status == 401 {
                    completion(nil, nil, true)
                } else {
                    completion(dashboard.message, nil, nil)
                }
            } catch let err { completion(err.localizedDescription, nil, nil) }
            }.resume()
    }
    
    func getLatestNews(completion: @escaping (_ error: String?, _ listNews: [News]?, _ isExpired: Bool?) -> Void) {
        guard let url = URL(string: "\(staticLet.base_url)api/getLatestNews") else { return }
        var request = URLRequest(url: url)
        request.setValue("Bearer \(preference.getString(key: staticLet.TOKEN))", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                completion(error.localizedDescription, nil, nil)
                return
            }
            
            guard let data = data else {
                completion("Error null data, please try again later", nil, nil)
                return
            }
            
            do {
                let latestNew = try JSONDecoder().decode(LatestNews.self, from: data)
                
                if latestNew.status == 200 {
                    completion(nil, latestNew.data, nil)
                } else if latestNew.status == 401 {
                    completion(nil, nil, true)
                } else {
                    completion(latestNew.message, nil, nil)
                }
            } catch let err { completion(err.localizedDescription, nil, nil) }
            }.resume()
    }
    
    func getNewsDetail(newsId: String, completion: @escaping (_ error: String?, _ itemDetailNews: ItemDetailNews?, _ isExpired: Bool?) -> Void) {
        let url = "\(staticLet.base_url)api/getNewsDetail"
        let body : [String: String] = [ "news_id": newsId ]
        let headers: [String: String] = [ "Authorization": "Bearer \(preference.getString(key: staticLet.TOKEN))" ]
        
        Alamofire.request(url, method: .post, parameters: body, headers: headers).responseJSON { (response) in
            switch response.result {
            case .success(let success):
                let status = JSON(success)["status"].int
                let message = JSON(success)["message"].string
                
                if status == 200 {
                    guard let mData = response.data else { return}
                    
                    do {
                        let detailNews = try JSONDecoder().decode(DetailNews.self, from: mData)
                        completion(nil, detailNews.data[0], nil)
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
    
    func getAllNews(page: Int, completion: @escaping (_ error: String?, _ listNews: [News]?, _ isExpired: Bool?) -> Void) {
        
        let url = "\(staticLet.base_url)api/getAllNews"
        let body : [String: String] = [
            "page": "\(page)"
        ]
        let headers: [String: String] = [
            "Authorization": "Bearer \(preference.getString(key: staticLet.TOKEN))"
        ]
        
        Alamofire.request(url, method: .post, parameters: body, headers: headers).responseJSON { (response) in
            switch response.result{
            case .success(let success):
                
                let status = JSON(success)["status"].int
                let message = JSON(success)["message"].string
                
                if status == 200 {
                    guard let mData = response.data else { return}
                    
                    do {
                        let allNews = try JSONDecoder().decode(AllNews.self, from: mData)
                        completion(nil, allNews.data?.news, nil)
                    } catch let err { completion(err.localizedDescription, nil, nil) }
                    
                } else if status == 401 {
                    completion(nil, nil, true)
                } else {
                    completion(message, nil, nil)
                }
                
            case .failure(let responseFailure):
                completion(responseFailure.localizedDescription, nil, nil)
            }
        }
    }
    
    func getProfile(completion: @escaping (_ error: String?, _ profile: ItemProfile?, _ isExpired: Bool?) -> Void) {
        let url = "\(staticLet.base_url)api/getProfile"
        let headers: [String: String] = [ "Authorization": "Bearer \(preference.getString(key: staticLet.TOKEN))" ]
        
        Alamofire.request(url, method: .post, headers: headers).responseJSON { (response) in
            switch response.result{
            case .success(let success):
                
                let status = JSON(success)["status"].int
                let message = JSON(success)["message"].string
                
                if status == 200 {
                    guard let mData = response.data else { return}
                    
                    do {
                        let profile = try JSONDecoder().decode(Profile.self, from: mData)
                        completion(nil, profile.data[0], nil)
                    } catch let err { completion(err.localizedDescription, nil, nil) }
                    
                } else if status == 401 {
                    completion(nil, nil, true)
                } else {
                    completion(message, nil, nil)
                }
                
            case .failure(let responseFailure):
                completion(responseFailure.localizedDescription, nil, nil)
            }
        }
    }
    
    func getProfileByEmpId(empId: String, completion: @escaping (_ error: String?, _ itemDetailKaryawan: ItemDetailKaryawan?, _ isExpired: Bool?) -> Void) {
        
        let url = "\(staticLet.base_url)api/getProfileByEmpId"
        let headers: [String: String] = [ "Authorization": "Bearer \(preference.getString(key: staticLet.TOKEN))" ]
        let body: [String: String] = [ "emp_id": empId ]
        
        Alamofire.request(url, method: .post, parameters: body, headers: headers).responseJSON { (response) in
            switch response.result {
            case .success(let success):
                let status = JSON(success)["status"].int
                let message = JSON(success)["message"].string
                
                if status == 200 {
                    guard let mData = response.data else { return}
                    
                    do {
                        let detailKaryawan = try JSONDecoder().decode(DetailKaryawan.self, from: mData)
                        completion(nil, detailKaryawan.data[0], nil)
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
    
    func getEmpList(_ request: (emp_name: String, unit_id: String, workarea_id: String, gender: String, page: String, order_id: String), completion: @escaping (_ error: String?, _ listKaryawan: ListKaryawan?, _ isExpired: Bool?) -> Void) {
        
        let url = "\(staticLet.base_url)api/getEmpList"
        let headers: [String: String] = [ "Authorization": "Bearer \(preference.getString(key: staticLet.TOKEN))" ]
        let body: [String: String] = [
            "order": request.order_id,
            "emp_name": request.emp_name,
            "unit_id": request.unit_id,
            "workarea_id": request.workarea_id,
            "gender": request.gender,
            "page": request.page
        ]
        
        Alamofire.request(url, method: .post, parameters: body, headers: headers).responseJSON { (response) in
            switch response.result {
            case .success(let success):
                let status = JSON(success)["status"].int
                let message = JSON(success)["message"].string
                
                if status == 200 {
                    guard let mData = response.data else { return}
                    
                    do {
                        let listKaryawan = try JSONDecoder().decode(ListKaryawan.self, from: mData)
                        completion(nil, listKaryawan, nil)
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
    
    func getUnit(completion: @escaping (_ error: String?, _ listUnit: [ItemUnit]?, _ isExpired: Bool?) -> Void) {
        let url = "\(staticLet.base_url)api/getUnit"
        let headers: [String: String] = [ "Authorization": "Bearer \(preference.getString(key: staticLet.TOKEN))" ]
        
        Alamofire.request(url, method: .get, headers: headers).responseJSON { (response) in
            switch response.result {
            case .success(let success):
                let status = JSON(success)["status"].int
                let message = JSON(success)["message"].string
                
                if status == 200 {
                    guard let mData = response.data else { return}
                    
                    do {
                        let unit = try JSONDecoder().decode(Unit.self, from: mData)
                        completion(nil, unit.data, nil)
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
    
    func getWorkarea(completion: @escaping (_ error: String?, _ listUnit: [ItemWorkarea]?, _ isExpired: Bool?) -> Void) {
        let url = "\(staticLet.base_url)api/getWorkarea"
        let headers: [String: String] = [ "Authorization": "Bearer \(preference.getString(key: staticLet.TOKEN))" ]
        
        Alamofire.request(url, method: .get, headers: headers).responseJSON { (response) in
            switch response.result {
            case .success(let success):
                let status = JSON(success)["status"].int
                let message = JSON(success)["message"].string
                
                if status == 200 {
                    guard let mData = response.data else { return}
                    
                    do {
                        let workarea = try JSONDecoder().decode(Workarea.self, from: mData)
                        completion(nil, workarea.data, nil)
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
    
    func getGender(completion: @escaping (_ error: String?, _ listUnit: [ItemGender]?, _ isExpired: Bool?) -> Void) {
        let url = "\(staticLet.base_url)api/getGender"
        let headers: [String: String] = [ "Authorization": "Bearer \(preference.getString(key: staticLet.TOKEN))" ]
        
        Alamofire.request(url, method: .get, headers: headers).responseJSON { (response) in
            switch response.result {
            case .success(let success):
                let status = JSON(success)["status"].int
                let message = JSON(success)["message"].string
                
                if status == 200 {
                    guard let mData = response.data else { return}
                    
                    do {
                        let gender = try JSONDecoder().decode(Gender.self, from: mData)
                        completion(nil, gender.data, nil)
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
    
    func getOrder(completion: @escaping (_ error: String?, _ listUnit: [ItemOrder]?, _ isExpired: Bool?) -> Void) {
        let url = "\(staticLet.base_url)api/getOrder"
        let headers: [String: String] = [ "Authorization": "Bearer \(preference.getString(key: staticLet.TOKEN))" ]
        
        Alamofire.request(url, method: .get, headers: headers).responseJSON { (response) in
            switch response.result {
            case .success(let success):
                let status = JSON(success)["status"].int
                let message = JSON(success)["message"].string
                
                if status == 200 {
                    guard let mData = response.data else { return}
                    
                    do {
                        let order = try JSONDecoder().decode(Order.self, from: mData)
                        completion(nil, order.data, nil)
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
    
    func getAnnouncement(completion: @escaping (_ error: String?, _ itemAnnouncement: ItemAnnouncement?) -> Void) {
        let url = "\(staticLet.base_url)api/getAnnouncement"
        let headers: [String: String] = [ "Authorization": "Bearer \(preference.getString(key: staticLet.TOKEN))" ]
        
        Alamofire.request(url, method: .get, headers: headers).responseJSON { (response) in
            switch response.result {
            case .success(let success):
                let status = JSON(success)["status"].int
                let message = JSON(success)["message"].string
                
                if status == 200 {
                    guard let mData = response.data else { return}
                    
                    do {
                        let annoucement = try JSONDecoder().decode(Announcement.self, from: mData)
                        completion(nil, annoucement.data[0])
                    } catch let err { completion(err.localizedDescription, nil) }
                    
                } else if status == 401 {
                    completion(nil, nil)
                } else {
                    completion(message, nil)
                }
                
            case .failure(let error): completion(error.localizedDescription, nil)
            }
        }
    }
}
