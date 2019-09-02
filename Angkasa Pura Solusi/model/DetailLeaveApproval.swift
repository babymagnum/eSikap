//
//  DetailLeaveApproval.swift
//  Angkasa Pura Solusi
//
//  Created by Arief Zainuri on 02/09/19.
//  Copyright © 2019 Gama Techno. All rights reserved.
//

import Foundation

struct DetailLeaveApproval: Decodable {
    var status: Int?
    var message: String?
    var data: DataDetailLeaveApproval?
}

struct DataDetailLeaveApproval: Decodable {
    var leave = [ItemDetailLeaveApproval]()
}

struct ItemDetailLeaveApproval: Decodable {
    var id: String?
    var date: String?
    var number: String?
    var emp_name: String?
    var unit_id: String?
    var unit_name: String?
    var type_name: String?
    var reason: String?
    var status: String?
    var status_icon: String?
    var status_color: String?
    var is_day: String?
    var is_range: String?
    var photo: String?
    var dates: String?
    var approval = [ItemApproval]()
    var approval_dates = [String]()
    var is_processed: String?
}
