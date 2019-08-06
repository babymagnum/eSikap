//
//  PreparePresence.swift
//  Angkasa Pura Solusi
//
//  Created by Arief Zainuri on 31/07/19.
//  Copyright © 2019 Gama Techno. All rights reserved.
//

import Foundation
import SwiftyJSON

struct PreparePresence: Decodable {
    var status: Int?
    var message: String?
    var data: ItemPreparePresence?
}

struct ItemPreparePresence: Decodable {
    var data_checkpoint = [Checkpoint]()
    var is_presence_in: String?
    var day: String?
    var date: String?
    var date_formated: String?
    var time: String?
    var shift_start: String?
    var shift_end: String?
    var timezone: String?
    var zoom_maps: String?
}

struct Checkpoint: Decodable {
    var checkpoint_id: String?
    var checkpoint_name: String?
    var checkpoint_radius: String?
    var checkpoint_latitude: String?
    var checkpoint_longitude: String?
}
