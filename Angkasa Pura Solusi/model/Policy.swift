//
//  Policy.swift
//  Angkasa Pura Solusi
//
//  Created by Arief Zainuri on 16/01/20.
//  Copyright © 2020 Gama Techno. All rights reserved.
//

import Foundation

struct Policy: Decodable {
    var status: Int
    var message: String
    var data: PolicyData?
}

struct PolicyData: Decodable {
    var total_page: Int
    var policy = [PolicyDataItem]()
}

struct PolicyDataItem: Decodable {
    var id: String?
    var name: String?
    var date: String?
    var files = [PolicyDataFilesItem]()
}

struct PolicyDataFilesItem: Decodable {
    var file_name: String?
    var file: String?
}

struct PolicyDataListItem {
    var id: String?
    var name: String?
    var date: String?
    var files = [PolicyDataFilesItem]()
    var isExpanded = false
}
