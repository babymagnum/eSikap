//
//  DetailOvertime.swift
//  Angkasa Pura Solusi
//
//  Created by Arief Zainuri on 27/01/20.
//  Copyright © 2020 Gama Techno. All rights reserved.
//

import Foundation

struct DetailOvertime: Decodable {
    var status: Int
    var message: String
    var data: DetailOvertimeData?
}

struct DetailOvertimeData: Decodable {
    var overtime = [DetailOvertimeDataItem]()
}

struct DetailOvertimeDataItem: Decodable {
    var id: String?
    var date: String?
    var number: String?
    var emp_name: String?
    var unit_name: String?
    var reason: String?
    var status: String?
    var status_icon: String?
    var status_color: String?
    var photo: String?
    var date_show = [DetailOvertimeDataItemDates]()
    var approval = [DetailOvertimeDataItemApproval]()
    var cancel_notes: String?
    var cancel_button_is_show: String?
    var last_insert: String?
    var last_update: String?
}

struct DetailOvertimeDataItemDates: Decodable {
    var start: String?
    var end: String?
    var status: String?
}

struct DetailOvertimeDataItemApproval: Decodable {
    var no: Int?
    var emp_id: String?
    var emp_name: String?
    var status_notes: String?
    var status_name: String?
    var status_date: String?
}
