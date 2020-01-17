//
//  CategoryCarRequest.swift
//  Angkasa Pura Solusi
//
//  Created by Arief Zainuri on 15/01/20.
//  Copyright © 2020 Gama Techno. All rights reserved.
//

import Foundation

struct CategoryCarRequest: Decodable {
    var status: Int
    var message: String
    var data = [CategoryCarRequestDataItem]()
}

struct CategoryCarRequestDataItem: Decodable {
    var id: String
    var name: String
}
