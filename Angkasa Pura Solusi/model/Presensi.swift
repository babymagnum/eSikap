//
//  Presensi.swift
//  Angkasa Pura Solusi
//
//  Created by Arief Zainuri on 04/08/19.
//  Copyright © 2019 Gama Techno. All rights reserved.
//

import Foundation

struct Presensi: Decodable {
    var status: Int?
    var message: String?
    var data = [ItemPresensi]()
}

struct ItemPresensi: Decodable {
    var date: String?
    var shift_start: String?
    var shift_end: String?
    var date_in: String?
    var date_out: String?
    var presence_status: String?
    var presence_status_bg_color: String?
}
