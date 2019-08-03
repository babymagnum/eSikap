//
//  DetailNews.swift
//  Angkasa Pura Solusi
//
//  Created by Arief Zainuri on 03/08/19.
//  Copyright © 2019 Gama Techno. All rights reserved.
//

import Foundation

struct DetailNews: Decodable {
    var status: Int?
    var message: String?
    var data = [ItemDetailNews]()
}

struct ItemDetailNews: Decodable {
    var id: String?
    var title: String?
    var content: String?
    var date: String?
    var img: String?
}
