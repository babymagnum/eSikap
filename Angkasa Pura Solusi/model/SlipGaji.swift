//
//  SlipGaji.swift
//  Angkasa Pura Solusi
//
//  Created by Arief Zainuri on 05/09/19.
//  Copyright © 2019 Gama Techno. All rights reserved.
//

import Foundation

struct SlipGaji: Decodable {
    var status: Int?
    var message: String?
    var data = [ItemSlipGaji]()
}

struct ItemSlipGaji: Decodable {
    var payroll_id: String?
    var month: String?
    var date_range: String?
}
