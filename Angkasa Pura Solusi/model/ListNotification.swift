//
//  ListNotification.swift
//  Angkasa Pura Solusi
//
//  Created by Arief Zainuri on 03/09/19.
//  Copyright © 2019 Gama Techno. All rights reserved.
//

import Foundation

struct ListNotification: Decodable {
    var status: Int?
    var message: String?
    var data: DataListNotification?
}

struct DataListNotification: Decodable {
    var total_page: Int?
    var notification = [ItemListNotification]()
}

struct ItemListNotification: Decodable {
    var id: String?
    var title: String?
    var content: String?
    var redirect: String?
    var data_id: String?
    var is_read: String?
    var date: String?
}
