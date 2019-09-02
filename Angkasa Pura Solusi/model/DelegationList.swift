//
//  DelegationList.swift
//  Angkasa Pura Solusi
//
//  Created by Arief Zainuri on 02/09/19.
//  Copyright © 2019 Gama Techno. All rights reserved.
//

import Foundation

struct DelegationList: Decodable {
    var status: Int?
    var message: String?
    var data: DataDelegationList?
}

struct DataDelegationList: Decodable {
    var total_page: Int?
    var leave = [ItemDelegation]()
}

struct ItemDelegation: Decodable {
    var id: String?
    var date: String?
    var number: String?
    var type_name: String?
    var emp_name: String?
    var photo: String?
    var dates: String?
}
