//
//  LeaveTypeFilter.swift
//  Angkasa Pura Solusi
//
//  Created by Arief Zainuri on 03/09/19.
//  Copyright © 2019 Gama Techno. All rights reserved.
//

import Foundation

struct LeaveTypeFilter: Decodable {
    var status: Int?
    var message: String?
    var data = [ItemLeaveTypeFilter]()
}

struct ItemLeaveTypeFilter: Decodable {
    var id: String?
    var name: String?
}
