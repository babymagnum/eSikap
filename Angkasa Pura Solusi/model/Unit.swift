//
//  Unit.swift
//  Angkasa Pura Solusi
//
//  Created by Arief Zainuri on 05/08/19.
//  Copyright © 2019 Gama Techno. All rights reserved.
//

import Foundation

struct Unit: Decodable {
    var status: Int?
    var message: String?
    var data = [ItemUnit]()
}

struct ItemUnit: Decodable {
    var unit_id: String?
    var unit_name: String?
}
