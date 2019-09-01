//
//  BaseResponse.swift
//  Angkasa Pura Solusi
//
//  Created by Arief Zainuri on 01/09/19.
//  Copyright © 2019 Gama Techno. All rights reserved.
//

import Foundation

struct BaseResponse: Decodable {
    var status: Int?
    var message: String?
}
