//
//  DetailApprovalOvertime.swift
//  Angkasa Pura Solusi
//
//  Created by Arief Zainuri on 30/01/20.
//  Copyright © 2020 Gama Techno. All rights reserved.
//

import Foundation

struct DetailApprovalOvertime: Decodable {
    var status: Int
    var message: String
    var data: DetailApprovalOvertimeData?
}

struct DetailApprovalOvertimeData: Decodable {
    var id: String?
    var number: String?
    var date: String?
    var emp_name: String?
    var unit_id: String?
    var unit_name: String?
    var overtime_emp_id: String?
    var approval_id: String?
    var reason: String?
    var overtimestat_id: String?
    var status: String?
    var status_icon: String?
    var status_date: String?
    var status_notes: String?
    var cancel_notes: String?
    var status_color: String?
    var photo: String?
    var datetimes_start = [String]()
    var datetimes_start_show = [String]()
    var datetimes_end = [String]()
    var datetimes_end_show = [String]()
    var datetime_id = [String]()
    var is_processed: String?
}
