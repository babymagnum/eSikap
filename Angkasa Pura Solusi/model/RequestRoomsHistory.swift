//
//  RequestRoomsHistory.swift
//  Angkasa Pura Solusi
//
//  Created by Arief Zainuri on 25/01/20.
//  Copyright © 2020 Gama Techno. All rights reserved.
//

import Foundation

struct RequestRoomsHistory: Decodable {
    var status: Int
    var message: String
    var data: RequestRoomsHistoryData?
}

struct RequestRoomsHistoryData: Decodable {
    var total_page: Int
    var requestrooms = [RequestRoomsHistoryItem]()
}

struct RequestRoomsHistoryItem: Decodable {
    var id: String?
    var date: String?
    var title_agenda: String?
    var date_use: String?
}
