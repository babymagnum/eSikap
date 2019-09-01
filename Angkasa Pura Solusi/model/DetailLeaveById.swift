//
//  DetailLeaveById.swift
//  Angkasa Pura Solusi
//
//  Created by Arief Zainuri on 01/09/19.
//  Copyright © 2019 Gama Techno. All rights reserved.
//

import Foundation

struct DetailLeaveById: Decodable {
    var status: Int
    var message: String
    var data: DetailLeave?
}

struct DetailLeave: Decodable {
    var id: String?
    var date: String?
    var number: String?
    var type_id: String?
    var leave_start: String?
    var leave_end: String?
    var start_time: String?
    var end_time: String?
    var reason: String?
    var file: String?
    var file_name: String?
    var url_file: String?
    var dates = [String]()
}
