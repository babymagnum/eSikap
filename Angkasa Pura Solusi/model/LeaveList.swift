//
//  LeaveList.swift
//  Angkasa Pura Solusi
//
//  Created by Arief Zainuri on 01/02/20.
//  Copyright © 2020 Gama Techno. All rights reserved.
//

import Foundation

struct LeaveList: Decodable {
    var status: Int
    var message: String
    var data: LeaveListData?
}

struct LeaveListData: Decodable {
    var total_page: Int
    var leave = [LeaveListItem]()
}

struct LeaveListItem: Decodable {
    var id: String?
    var date: String?
    var number: String?
    var emp_name: String?
    var type_name: String?
    var status: String?
    var status_color: String?
    var photo: String?
    var dates: String?
}
