//
//  MenuServer.swift
//  Angkasa Pura Solusi
//
//  Created by Arief Zainuri on 26/01/20.
//  Copyright © 2020 Gama Techno. All rights reserved.
//

import Foundation

struct MenuServer: Decodable {
    var status: Int
    var message: String
    var data = [MenuServerItem]()
}

struct MenuServerItem: Decodable {
    var menu_key: String
    var menu_name: String
}
