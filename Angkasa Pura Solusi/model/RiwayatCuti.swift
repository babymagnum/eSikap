//
//  RiwayatCuti.swift
//  Angkasa Pura Solusi
//
//  Created by Arief Zainuri on 10/08/19.
//  Copyright © 2019 Gama Techno. All rights reserved.
//

import Foundation

struct RiwayatCuti: Decodable {
    var status: Int?
    var message: String?
    var data: DataRiwayatCuti?
}

struct DataRiwayatCuti: Decodable {
    var total_page: Int?
    var leave = [ItemRiwayatCuti]()
}

struct ItemRiwayatCuti: Decodable {
    var id: String?
    var date: String?
    var number: String?
    var type_name: String?
    var status: String?
    var status_icon: String?
    var dates: String?
}
