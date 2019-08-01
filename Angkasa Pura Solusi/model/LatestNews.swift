//
//  LatestNews.swift
//  Angkasa Pura Solusi
//
//  Created by Arief Zainuri on 01/08/19.
//  Copyright © 2019 Gama Techno. All rights reserved.
//

import Foundation

struct LatestNews: Decodable {
    var status: Int?
    var message: String?
    var data = [News]()
}

struct News: Decodable {
    var id: String?
    var title: String?
    var date: String?
    var img: String?
}
