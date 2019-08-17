//
//  LeaveType.swift
//  Angkasa Pura Solusi
//
//  Created by Arief Zainuri on 17/08/19.
//  Copyright © 2019 Gama Techno. All rights reserved.
//

import Foundation

struct LeaveType: Decodable {
    var status: Int?
    var message: String?
    var data = [ItemType]()
}

struct ItemType: Decodable {
    var id: String?
    var code: String?
    var type: String?
    var name: String?
    var is_day: String?
    var days_count: String?
    var is_range: String?
    var is_reduced: String?
    var is_backdated: String?
    var is_salary_reduced: String?
    var is_lampiran: String?
    var work_period: String?
}
