//
//  LeaveQuota.swift
//  Angkasa Pura Solusi
//
//  Created by Arief Zainuri on 17/08/19.
//  Copyright © 2019 Gama Techno. All rights reserved.
//

import Foundation

struct LeaveQuota: Decodable {
    var status: Int?
    var message: String?
    var data = [ItemQuota]()
}

struct ItemQuota: Decodable {
    var id: String?
    var emp_id: String?
    var start: String?
    var end: String?
    var quota: String?
    var taken: String?
    var expired: String?
}
