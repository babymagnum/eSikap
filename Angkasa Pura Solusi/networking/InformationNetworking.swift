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
    
    func getProfileByEmpId(empId: String, completion: @escaping (_ error: String?, _ itemDetailKaryawan: ItemDetailKaryawan?) -> Void) {
        
        let url = "\(staticLet.base_url)api/getProfileByEmpId"
        let headers: [String: String] = [ "Authorization": "Bearer \(preference.getString(key: staticLet.TOKEN))" ]
        let body: [String: String] = [ "emp_id": empId ]
        
        Alamofire.request(url, method: .post, parameters: body, headers: headers).responseJSON { (response) in
            switch response.result {
            case .success:
                let data = response.data
                
                guard let mData = data else {
                    completion("Error null data, please try again later", nil)
                    return
                }
                
                do {
                    let detailKaryawan = try JSONDecoder().decode(DetailKaryawan.self, from: mData)
                    
                    if detailKaryawan.status == 200 {
                        completion(nil, detailKaryawan.data[0])
                    } else {
                        completion(detailKaryawan.message, nil)
                    }
                } catch let err { completion(err.localizedDescription, nil) }
                
            case .failure(let error):
                completion(error.localizedDescription, nil)
            }
        }
    }
    
    func getEmpList(_ request: (emp_name: String, unit_id: String, workarea_id: String, gender: String, page: String), completion: @escaping (_ error: String?, _ listKaryawan: Karyawan?) -> Void) {
        
        let url = "\(staticLet.base_url)api/getEmpList"
        let headers: [String: String] = [ "Authorization": "Bearer \(preference.getString(key: staticLet.TOKEN))" ]
        let body: [String: String] = [
            "order": "a_to_z",
            "emp_name": request.emp_name,
            "unit_id": request.unit_id,
            "workarea_id": request.workarea_id,
            "gender": request.gender,
            "page": request.page
        ]
        
        Alamofire.request(url, method: .post, parameters: body, headers: headers).responseJSON { (response) in
            switch response.result {
            case .success:
                let data = response.data
                
                guard let mData = data else {
                    completion("Error null data, please try again later", nil)
                    return
                }
                
                do {
                    let listKaryawan = try JSONDecoder().decode(ListKaryawan.self, from: mData)
                    
                    if listKaryawan.status == 200 {
                        completion(nil, listKaryawan.data)
                    } else {
                        completion(listKaryawan.message, nil)
                    }
                } catch let err { completion(err.localizedDescription, nil) }
                
            case .failure(let error): completion(error.localizedDescription, nil)
            }
        }
    }
    
    func getUnit(completion: @escaping (_ error: String?, _ listUnit: [ItemUnit]?) -> Void) {
        let url = "\(staticLet.base_url)api/getUnit"
        let headers: [String: String] = [ "Authorization": "Bearer \(preference.getString(key: staticLet.TOKEN))" ]
        
        Alamofire.request(url, method: .get, headers: headers).responseJSON { (response) in
            switch response.result {
            case .success:
                let data = response.data
                
                guard let mData = data else {
                    completion("Error null data, please try again later", nil)
                    return
                }
                
                do {
                    let unit = try JSONDecoder().decode(Unit.self, from: mData)
                    
                    if unit.status == 200 {
                        completion(nil, unit.data)
                    } else {
                        completion(unit.message, nil)
                    }
                } catch let err { completion(err.localizedDescription, nil) }
            case .failure(let error): completion(error.localizedDescription, nil)
            }
        }
    }
    
    func getWorkarea(completion: @escaping (_ error: String?, _ listUnit: [ItemWorkarea]?) -> Void) {
        let url = "\(staticLet.base_url)api/getWorkarea"
        let headers: [String: String] = [ "Authorization": "Bearer \(preference.getString(key: staticLet.TOKEN))" ]
        
        Alamofire.request(url, method: .get, headers: headers).responseJSON { (response) in
            switch response.result {
            case .success:
                let data = response.data
                
                guard let mData = data else {
                    completion("Error null data, please try again later", nil)
                    return
                }
                
                do {
                    let workarea = try JSONDecoder().decode(Workarea.self, from: mData)
                    
                    if workarea.status == 200 {
                        completion(nil, workarea.data)
                    } else {
                        completion(workarea.message, nil)
                    }
                } catch let err { completion(err.localizedDescription, nil) }
                
            case .failure(let error): completion(error.localizedDescription, nil)
            }
        }
    }
    
    func getGender(completion: @escaping (_ error: String?, _ listUnit: [ItemGender]?) -> Void) {
        let url = "\(staticLet.base_url)api/getGender"
        let headers: [String: String] = [ "Authorization": "Bearer \(preference.getString(key: staticLet.TOKEN))" ]
        
        Alamofire.request(url, method: .get, headers: headers).responseJSON { (response) in
            switch response.result {
            case .success:
                let data = response.data
                
                guard let mData = data else {
                    completion("Error null data, please try again later", nil)
                    return
                }
                
                do {
                    let gender = try JSONDecoder().decode(Gender.self, from: mData)
                    
                    if gender.status == 200 {
                        completion(nil, gender.data)
                    } else {
                        completion(gender.message, nil)
                    }
                } catch let err { completion(err.localizedDescription, nil) }
                
            case .failure(let error): completion(error.localizedDescription, nil)
            }
        }
    }
    
    func getOrder(completion: @escaping (_ error: String?, _ listUnit: [ItemOrder]?) -> Void) {
        let url = "\(staticLet.base_url)api/getOrder"
        let headers: [String: String] = [ "Authorization": "Bearer \(preference.getString(key: staticLet.TOKEN))" ]
        
        Alamofire.request(url, method: .get, headers: headers).responseJSON { (response) in
            switch response.result {
            case .success:
                let data = response.data
                
                guard let mData = data else {
                    completion("Error null data, please try again later", nil)
                    return
                }
                
                do {
                    let order = try JSONDecoder().decode(Order.self, from: mData)
                    
                    if order.status == 200 {
                        completion(nil, order.data)
                    } else {
                        completion(order.message, nil)
                    }
                } catch let err { completion(err.localizedDescription, nil) }
                
            case .failure(let error): completion(error.localizedDescription, nil)
            }
        }
    }
    
    func getAnnouncement(completion: @escaping (_ error: String?, _ itemAnnouncement: ItemAnnouncement?) -> Void) {
        let url = "\(staticLet.base_url)api/getAnnouncement"
        let headers: [String: String] = [ "Authorization": "Bearer \(preference.getString(key: staticLet.TOKEN))" ]
        
        Alamofire.request(url, method: .get, headers: headers).responseJSON { (response) in
            switch response.result {
            case .success:
                let data = response.data
                
                guard let mData = data else {
                    completion("Error null data, please try again later", nil)
                    return
                }
                
                do {
                    let announcement = try JSONDecoder().decode(Announcement.self, from: mData)
                    
                    if announcement.status == 200 {
                        completion(nil, announcement.data[0])
                    } else {
                        completion(announcement.message, nil)
                    }
                } catch let err { completion(err.localizedDescription, nil) }
                
            case .failure(let error): completion(error.localizedDescription, nil)
            }
        }
    }
}
