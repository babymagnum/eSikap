//
//  Destination.swift
//  Angkasa Pura Solusi
//
//  Created by Arief Zainuri on 15/01/20.
//  Copyright © 2020 Gama Techno. All rights reserved.
//

import Foundation

struct Destination: Decodable {
    var status: Int
    var message: String
    var data = [DestinationDataItem]()
}

struct DestinationDataItem: Decodable {
    var id: String
    var name: String
}
