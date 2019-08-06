//
//  Announcement.swift
//  Angkasa Pura Solusi
//
//  Created by Arief Zainuri on 06/08/19.
//  Copyright © 2019 Gama Techno. All rights reserved.
//

import Foundation

struct Announcement: Decodable {
    var status: Int?
    var message: String?
    var data = [ItemAnnouncement]()
}

struct ItemAnnouncement: Decodable {
    var title: String?
    var content: String?
    var img: String?
}
