//
//  PolocyCategory.swift
//  Angkasa Pura Solusi
//
//  Created by Arief Zainuri on 16/01/20.
//  Copyright © 2020 Gama Techno. All rights reserved.
//

import Foundation

struct PolicyCategory: Decodable {
    var status: Int
    var message: String
    var data: PolicyCategoryData?
}

struct PolicyCategoryData: Decodable {
    var total_page: Int
    var policy_category = [PolicyCategoryDataItem]()
}

struct PolicyCategoryDataItem: Decodable {
    var id: String?
    var name: String?
}
