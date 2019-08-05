//
//  ListKaryawan.swift
//  Angkasa Pura Solusi
//
//  Created by Arief Zainuri on 05/08/19.
//  Copyright © 2019 Gama Techno. All rights reserved.
//

import Foundation

struct ListKaryawan: Decodable {
    var status: Int?
    var message: String?
    var data: Karyawan?
}

struct Karyawan: Decodable {
    var total_page: Int?
    var emp = [ItemKaryawan]()
}

struct ItemKaryawan: Decodable {
    var emp_id: String?
    var emp_name: String?
    var position: String?
    var unit: String?
    var img: String?
}
