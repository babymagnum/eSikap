//
//  Workarea.swift
//  Angkasa Pura Solusi
//
//  Created by Arief Zainuri on 05/08/19.
//  Copyright © 2019 Gama Techno. All rights reserved.
//

import Foundation

struct Workarea: Decodable {
    var status: Int?
    var message: String?
    var data = [ItemWorkarea]()
}

struct ItemWorkarea: Decodable {
    var workarea_id: String?
    var workarea_name: String?
}
