//
//  LeaveStatusFilter.swift
//  Angkasa Pura Solusi
//
//  Created by Arief Zainuri on 03/09/19.
//  Copyright © 2019 Gama Techno. All rights reserved.
//

import Foundation

struct LeaveStatusFilter: Decodable {
    var status: Int?
    var message: String?
    var data = [ItemLeaveStatusFilter]()
}

struct ItemLeaveStatusFilter: Decodable {
    var leavestatus_id: String?
    var leavestatus_name: String?
}
