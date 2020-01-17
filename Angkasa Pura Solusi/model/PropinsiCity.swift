//
//  Propinsi.swift
//  Angkasa Pura Solusi
//
//  Created by Arief Zainuri on 15/01/20.
//  Copyright © 2020 Gama Techno. All rights reserved.
//

import Foundation

struct PropinsiCity: Decodable {
    var status: Int?
    var message: String?
    var data: PropinsiCityData?
}

struct PropinsiCityData: Decodable {
    var total_page: Int
    var emp = [PropinsiCityDataItem]()
}

struct PropinsiCityDataItem: Decodable {
    var id: String
    var name: String
}
