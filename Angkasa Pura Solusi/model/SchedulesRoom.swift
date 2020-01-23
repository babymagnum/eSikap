//
//  SchedulesRoom.swift
//  Angkasa Pura Solusi
//
//  Created by Arief Zainuri on 22/01/20.
//  Copyright © 2020 Gama Techno. All rights reserved.
//

import Foundation

struct SchedulesRoom: Decodable {
    var status: Int
    var message: String
    var data = [SchedulesRoomData]()
}

struct SchedulesRoomData: Decodable {
    var date: String?
    var date_show: String?
    var day: String?
    var agenda = [SchedulesRoomDataAgenda]()
}

struct SchedulesRoomDataAgenda: Decodable {
    var id: String?
    var title_agenda: String?
}


