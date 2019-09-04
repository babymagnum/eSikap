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

class InformationNetworking: BaseNetworking {
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
                
                print(JSON(success))
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
    
    func getEmpListFilter(page: Int, keyword: String, completion: @escaping(_ error: String?, _ listEmpFilter: ListEmpFilter?, _ isExpired: Bool?) -> Void) {
        let url = "\(staticLet.base_url)api/getEmpListFiter"
        let body: [String: String] = [
            "page": "\(page)",
            "keyword": keyword
        ]
        alamofirePostFormData(url: url, headers: getHeaders(), body: body, completion: completion)
    }
    
    func postLeaveRequest(imageData: Data, body: [String: String], completion : @escaping(_ error: String?, _ success: Success?, _ isExpired: Bool?) -> Void) {
        let url = "\(staticLet.base_url)api/addLeaveRequest"
        alamofirePostImage(imageData: imageData, url: url, headers: getHeaders(), body: body, completion: completion)
    }
    
    func getLeaveHistoryList(page: Int, year: String, leave_type_id: String, status: String, completion: @escaping(_ error: String?, _ riwayatCuti: RiwayatCuti?, _ isExpired: Bool?) -> Void) {
        let url = "\(staticLet.base_url)api/getLeaveHistoryList"
        let body: [String: String] = [
            "page": "\(page)",
            "year": year,
            "leave_type_id": leave_type_id,
            "status": status
        ]
        alamofirePostFormData(url: url, headers: getHeaders(), body: body, completion: completion)
    }
    
    func getDetailLeaveById(id: String, completion: @escaping(_ error: String?, _ detailRiwayatCuti: DetailRiwayatCuti?, _ isExpired: Bool?) -> Void) {
        let url = "\(staticLet.base_url)api/getDetailLeaveById"
        let body: [String: String] = [
            "leave_id": id
        ]
        
        alamofirePostFormData(url: url, headers: getHeaders(), body: body, completion: completion)
    }
    
    func cancelLeave(id: String, cancelNotes: String, completion: @escaping(_ error: String?, _ baseResponse: BaseResponse?, _ isExpired: Bool?) -> Void) {
        let url = "\(staticLet.base_url)api/cancelLeave"
        let body: [String: String] = [
            "leave_id": id,
            "cancel_notes": cancelNotes
        ]
        alamofirePostFormData(url: url, headers: getHeaders(), body: body, completion: completion)
    }
    
    func getEditDetailLeaveById(id: String, completion: @escaping(_ error: String?, _ detailLeaveById: DetailLeaveById?, _ isExpired: Bool?) -> Void) {
        let url = "\(staticLet.base_url)api/getEditDetailLeaveById"
        let body: [String: String] = [
            "leave_id": id
        ]
        alamofirePostFormData(url: url, headers: getHeaders(), body: body, completion: completion)
    }
    
    func getLeaveApprovalList(page: Int, completion: @escaping(_ error: String?, _ delegationList: DelegationList?, _ isExpired: Bool?) -> Void) {
        let url = "\(staticLet.base_url)api/getLeaveApprovalList"
        let body: [String: String] = [ "page": "\(page)" ]
        alamofirePostFormData(url: url, headers: getHeaders(), body: body, completion: completion)
    }
    
    func getDetailLeaveApprovalById(leave_id: String, completion: @escaping(_ error: String?, _ detailLeaveApproval: DetailLeaveApproval?, _ isExpired: Bool?) -> Void) {
        let url = "\(staticLet.base_url)api/getDetailLeaveApprovalById"
        let body: [String: String] = [ "leave_id": leave_id ]
        alamofirePostFormData(url: url, headers: getHeaders(), body: body, completion: completion)
    }
    
    func getLeaveDelegationList(page: Int, completion: @escaping(_ error: String?, _ delegationList: DelegationList?, _ isExpired: Bool?) -> Void) {
        let url = "\(staticLet.base_url)api/getLeaveDelegationList"
        let body: [String: String] = [ "page": "\(page)" ]
        alamofirePostFormData(url: url, headers: getHeaders(), body: body, completion: completion)
    }
    
    func getDetailLeaveDelegationById(leave_id: String, completion: @escaping(_ error: String?, _ detailDelegationList: DetailDelegationList?, _ isExpired: Bool?) -> Void) {
        let url = "\(staticLet.base_url)api/getDetailLeaveDelegationById"
        let body: [String: String] = [ "leave_id": leave_id ]
        alamofirePostFormData(url: url, headers: getHeaders(), body: body, completion: completion)
    }
    
    func approvalLeaveByDate(leave_id: String, approval_notes: String, listStatusAction: [StatusAction], completion: @escaping(_ error: String?, _ success: Success?, _ isExpired: Bool?) -> Void) {
        let url = "\(staticLet.base_url)api/approvalLeave"
        var body: [String: String] = [
            "leave_id": leave_id,
            "approval_notes": approval_notes
        ]
        
        //appen the dictionary
        for (index, status) in listStatusAction.enumerated() {
            body.updateValue(status.isApproved!, forKey: "status_date[\(index)]")
            body.updateValue(status.date!, forKey: "dates[\(index)]")
        }
        
        alamofirePostFormData(url: url, headers: getHeaders(), body: body, completion: completion)
    }
    
    func approvalLeaveOneDayAndRange(leave_id: String, approval_notes: String, status_date: String, completion: @escaping(_ error: String?, _ success: Success?, _ isExpired: Bool?) -> Void) {
        let url = "\(staticLet.base_url)api/approvalLeave"
        let body: [String: String] = [
            "leave_id": leave_id,
            "approval_notes": approval_notes,
            "status_date": status_date
        ]
        
        alamofirePostFormData(url: url, headers: getHeaders(), body: body, completion: completion)
    }
    
    func getNotificationList(page: Int, completion: @escaping(_ error: String?, _ listNotification: ListNotification?, _ isExpired: Bool?) -> Void) {
        let url = "\(staticLet.base_url)api/getNotificationList"
        let body: [String: String] = [
            "page": "\(page)"
        ]
        alamofirePostFormData(url: url, headers: getHeaders(), body: body, completion: completion)
    }
    
    func getLeaveTypeFilter(completion: @escaping(_ error: String?, _ leaveTypeFilter: LeaveTypeFilter?, _ isExpired: Bool?) -> Void) {
        let url = "\(staticLet.base_url)api/getLeaveTypeFilter"
        alamofireGet(url: url, headers: getHeaders(), body: nil, completion: completion)
    }
    
    func getYearsFilter(completion: @escaping(_ error: String?, _ yearsFilter: YearsFilter?, _ isExpired: Bool?) -> Void) {
        let url = "\(staticLet.base_url)api/getYearsFilter"
        alamofireGet(url: url, headers: getHeaders(), body: nil, completion: completion)
    }
    
    func getLeaveStatusFilter(completion: @escaping(_ error: String?, _ leaveStatusFilter: LeaveStatusFilter?, _ isExpired: Bool?) -> Void) {
        let url = "\(staticLet.base_url)api/getLeaveStatusFilter"
        alamofireGet(url: url, headers: getHeaders(), body: nil, completion: completion)
    }
    
    func updateIsReadNotification(notification_id: String, completion: @escaping(_ error: String?, _ success: Success?, _ isExpired: Bool?) -> Void) {
        let url = "\(staticLet.base_url)api/updateIsReadNotification"
        let body: [String: String] = [
            "notification_id": notification_id
        ]
        alamofirePostFormData(url: url, headers: getHeaders(), body: body, completion: completion)
    }
}
