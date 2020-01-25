//
//  DetailRequestRooms.swift
//  Angkasa Pura Solusi
//
//  Created by Arief Zainuri on 22/01/20.
//  Copyright © 2020 Gama Techno. All rights reserved.
//

import Foundation

struct DetailsRequestRooms: Decodable {
    var status: Int
    var message: String
    var data = [DetailsRequestRoomsData]()
}

struct DetailsRequestRoomsData: Decodable {
    var requestor: String?
    var title_agenda: String?
    var description: String?
    var room_name: String?
    var start: String?
    var end: String?
    var total_person: String?
    var participants = [String]()
    var attachment = [DetailsRequestRoomsAttachment]()
    var button_cancel_is_show : String?
    var button_realization_is_show: String?
}

struct DetailsRequestRoomsAttachment: Decodable {
    var title: String?
    var file: String?
}
