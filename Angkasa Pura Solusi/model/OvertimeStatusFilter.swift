//
//  OvertimeStatusFilter.swift
//  Angkasa Pura Solusi
//
//  Created by Arief Zainuri on 27/01/20.
//  Copyright © 2020 Gama Techno. All rights reserved.
//

import Foundation

struct OvertimeStatusFilter: Decodable {
    var status: Int
    var message: String
    var data = [OvertimeStatusFilterItem]()
}

struct OvertimeStatusFilterItem: Decodable {
    var overtimestat_id: String?
    var overtimestat_name: String?
}
