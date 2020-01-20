//
//  Bonus.swift
//  Angkasa Pura Solusi
//
//  Created by Arief Zainuri on 20/01/20.
//  Copyright © 2020 Gama Techno. All rights reserved.
//

import Foundation

struct Bonus: Decodable {
    var status: Int?
    var message: String?
    var data = [BonusItem]()
}

struct BonusItem: Decodable {
    var id: String?
    var type: String?
    var name: String?
    var month: String?
}
