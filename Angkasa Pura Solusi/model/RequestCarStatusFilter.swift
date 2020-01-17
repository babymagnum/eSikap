//
//  RequestCarStatusFilter.swift
//  Angkasa Pura Solusi
//
//  Created by Arief Zainuri on 16/01/20.
// /Users/ariefzainuri/Documents/iOS/Angkasa Pura Solusi/Angkasa Pura Solusi.xcodeproj Copyright © 2020 Gama Techno. All rights reserved.
//

import Foundation

struct RequestCarStatusFilter: Decodable {
    var status: Int
    var message: String
    var data = [RequestCarStatusFilterItem]()
}

struct RequestCarStatusFilterItem: Decodable {
    var opercarstat_id: String
    var opercarstat_name: String
}
