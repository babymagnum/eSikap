//
//  DetailRiwayatCuti.swift
//  Angkasa Pura Solusi
//
//  Created by Arief Zainuri on 01/09/19.
//  Copyright © 2019 Gama Techno. All rights reserved.
//

import Foundation

struct DetailRiwayatCuti: Decodable {
    var status: Int
    var message: String
    var data: DataDetailRiwayatCuti?
}

struct DataDetailRiwayatCuti: Decodable {
    var leave = [ItemDetailRiwayatCuti]()
}

struct ItemDetailRiwayatCuti: Decodable {
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
    var photo: String?
    var dates: String?
    var date_show = [ItemDateShow]()
    var cancel_notes: String?
    var cancel_button_is_show: String?
    var last_insert: String?
    var last_update: String?
    var attachment_name: String?
    var attachment: String?
    var approval = [ItemApproval]()
}

struct ItemDateShow: Decodable {
    var date: String?
    var status: String?
}

struct ItemApproval: Decodable {
    var no: String?
    var id: String?
    var emp_id: String?
    var emp_name: String?
    var status: String?
    var status_name: String?
    var status_date: String?
    var status_notes: String?
}
