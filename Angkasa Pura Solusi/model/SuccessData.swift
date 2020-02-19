//
//  SuccessData.swift
//  Angkasa Pura Solusi
//
//  Created by Arief Zainuri on 19/02/20.
//  Copyright © 2020 Gama Techno. All rights reserved.
//

import Foundation

struct SuccessData: Decodable {
    var status: Int
    var message: String
    var data = [String]()
}
