//
//  Gender.swift
//  Angkasa Pura Solusi
//
//  Created by Arief Zainuri on 05/08/19.
//  Copyright © 2019 Gama Techno. All rights reserved.
//

import Foundation

struct Gender: Decodable {
    var status: Int?
    var message: String?
    var data = [ItemGender]()
}

struct ItemGender: Decodable {
    var gender: String?
    var gender_name: String?
}
