//
//  CheckVersion.swift
//  Angkasa Pura Solusi
//
//  Created by Arief Zainuri on 08/04/20.
//  Copyright © 2020 Gama Techno. All rights reserved.
//

import Foundation

struct CheckVersion: Decodable {
    var status: Int
    var message: String
    var data: CheckVersionData?
}

struct CheckVersionData: Decodable {
    var current_version: String?
    var latest_version: String?
    var must_update: Bool?
}
