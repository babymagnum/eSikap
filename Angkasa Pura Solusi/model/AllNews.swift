//
//  AllNews.swift
//  Angkasa Pura Solusi
//
//  Created by Arief Zainuri on 01/08/19.
//  Copyright © 2019 Gama Techno. All rights reserved.
//

import Foundation

struct AllNews: Decodable {
    var status: Int?
    var message: String?
    var data: ItemAllNews?
}

struct ItemAllNews: Decodable {
    var total_page: Int?
    var news = [News]()
}
