//
//  OvertimeHistoryList.swift
//  Angkasa Pura Solusi
//
//  Created by Arief Zainuri on 27/01/20.
//  Copyright © 2020 Gama Techno. All rights reserved.
//

import Foundation

struct OvertimeHistoryList: Decodable {
    var status: Int
    var message: String
    var data: OvertimeHistoryListData?
}

struct OvertimeHistoryListData: Decodable {
    var total_page: Int
    var overtime = [OvertimeHistoryListItem]()
}

struct OvertimeHistoryListItem: Decodable {
    var id: String?
    var date: String?
    var number: String?
    var status: String?
    var status_icon: String?
    var dates: String?
}
