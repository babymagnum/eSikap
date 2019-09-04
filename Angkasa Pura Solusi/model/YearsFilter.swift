//
//  YearsFilter.swift
//  Angkasa Pura Solusi
//
//  Created by Arief Zainuri on 03/09/19.
//  Copyright © 2019 Gama Techno. All rights reserved.
//

import Foundation

struct YearsFilter: Decodable {
    var status: Int?
    var message: String?
    var data = [ItemYearsFilter]()
}

struct ItemYearsFilter: Decodable {
    var year: Int?
    var year_name: Int?
}
