//
//  EditDetailOvertime.swift
//  Angkasa Pura Solusi
//
//  Created by Arief Zainuri on 29/01/20.
//  Copyright © 2020 Gama Techno. All rights reserved.
//

import Foundation

struct EditDetailOvertime: Decodable {
    var status: Int
    var message: String
    var data: EditDetailOvertimeData?
}

struct EditDetailOvertimeData: Decodable {
    var id: String?
    var number: String?
    var date: String?
    var unit_id: String?
    var overtime_emp_id: String?
    var approval_id: String?
    var reason: String?
    var real_reason: String?
    var overtimestat_id: String?
    var status_date: String?
    var status_notes: String?
    var cancel_notes: String?
    var real_overtimestat_id: String?
    var real_file: String?
    var real_file_name: String?
    var real_approval_id: String?
    var real_status_date: String?
    var real_status_notes: String?
    var datetimes_start = [String]()
    var datetimes_end = [String]()
}
