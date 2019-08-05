//
//  Order.swift
//  Angkasa Pura Solusi
//
//  Created by Arief Zainuri on 05/08/19.
//  Copyright © 2019 Gama Techno. All rights reserved.
//

import Foundation

struct Order: Decodable {
    var status: Int?
    var message: String?
    var data = [ItemOrder]()
}

struct ItemOrder: Decodable {
    var order: String?
    var order_name: String?
}
