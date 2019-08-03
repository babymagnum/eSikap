//
//  Profile.swift
//  Angkasa Pura Solusi
//
//  Created by Arief Zainuri on 03/08/19.
//  Copyright © 2019 Gama Techno. All rights reserved.
//

import Foundation

struct Profile: Decodable {
    var status: Int?
    var message: String?
    var data = [ItemProfile]()
}

struct ItemProfile: Decodable {
    var emp_id: String?
    var emp_name: String?
    var position: String?
    var unit: String?
    var nik: String?
    var workarea: String?
    var email: String?
    var phone: String?
    var img: String?
}
