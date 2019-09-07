//
//  DetailDelegationList.swift
//  Angkasa Pura Solusi
//
//  Created by Arief Zainuri on 02/09/19.
//  Copyright © 2019 Gama Techno. All rights reserved.
//

import Foundation

struct DetailDelegationList: Decodable {
    var status: Int?
    var message: String?
    var data: DataDetailDelegation?
}

struct DataDetailDelegation: Decodable {
    var leave = [ItemDataDelegation]()
}

struct ItemDataDelegation: Decodable {
    var id: String?
    var date: String?
    var number: String?
    var emp_name: String?
    var unit_id: String?
    var unit_name: String?
    var type_name: String?
    var reason: String?
    var status: String?
    var status_icon: String?
    var status_color: String?
    var photo: String?
    var dates: String?
    var attachment_name: String?
    var attachment: String?
    var date_show = [ItemDateShow]()
    var cancel_notes: String?
    var last_insert: String?
    var last_update: String?
    var approval = [ItemApproval]()
    var is_processed: String?
}
