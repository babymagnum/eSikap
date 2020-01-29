//
//  DetailOvertimeRealization.swift
//  Angkasa Pura Solusi
//
//  Created by Arief Zainuri on 29/01/20.
//  Copyright © 2020 Gama Techno. All rights reserved.
//

import Foundation

struct DetailOvertimeRealization: Decodable {
    var status: Int
    var message: String
    var data: DetailOvertimeRealizationData?
}

struct DetailOvertimeRealizationData: Decodable {
    var overtime = [DetailOvertimeRealizationItem]()
}

struct DetailOvertimeRealizationItem: Decodable {
    var id: String?
    var date: String?
    var number: String?
    var emp_name: String?
    var unit_name: String?
    var reason: String?
    var status: String?
    var status_icon: String?
    var attachment: String?
    var attachment_name: String?
    var url_attachment: String?
    var status_color: String?
    var photo: String?
    var date_show = [DetailOvertimeDataItemDates]()
    var approval = [DetailOvertimeDataItemApproval]()
    var cancel_notes: String?
    var cancel_button_is_show: String?
    var last_insert: String?
    var last_update: String?
}
