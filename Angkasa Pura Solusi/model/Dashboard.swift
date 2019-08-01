//
//  Dashboard.swift
//  Angkasa Pura Solusi
//
//  Created by Arief Zainuri on 01/08/19.
//  Copyright © 2019 Gama Techno. All rights reserved.
//

import Foundation

struct Dashboard: Decodable {
    var status: Int?
    var message: String?
    var data = [ItemDashboard]()
}

struct ItemDashboard: Decodable {
    var presence_today: PresenceToday?
    var total_work: TotalWork?
    var total_leave_quota: String?
}

struct PresenceToday: Decodable {
    var time: String?
    var status: String?
    var icon: String?
}

struct TotalWork: Decodable {
    var total_work_achievement: String?
    var total_work_hours: String?
}
