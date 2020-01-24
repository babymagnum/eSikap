//
//  Rooms.swift
//  Angkasa Pura Solusi
//
//  Created by Arief Zainuri on 24/01/20.
//  Copyright © 2020 Gama Techno. All rights reserved.
//

import Foundation

struct Rooms: Decodable {
    var status: Int
    var message: String
    var data = [RoomsData]()
}

struct RoomsData: Decodable {
    var id: String?
    var name: String?
}
