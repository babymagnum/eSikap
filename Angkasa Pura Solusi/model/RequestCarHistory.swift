//
//  RequestCarHistory.swift
//  Angkasa Pura Solusi
//
//  Created by Arief Zainuri on 16/01/20.
//  Copyright © 2020 Gama Techno. All rights reserved.
//

import Foundation

struct RequestCarHistory: Decodable {
    var status: Int
    var message: String
    var data: RequestCarHistoryData
}

struct RequestCarHistoryData: Decodable {
    var total_page: Int
    var requestcar = [RequestCarHistoryItem]()
}

struct RequestCarHistoryItem: Decodable {
    var id: String
    var date: String
    var purpose: String
    var time_use: String
    var status: String
    var status_color: String
}


