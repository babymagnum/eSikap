//
//  OvertimeApprovalList.swift
//  Angkasa Pura Solusi
//
//  Created by Arief Zainuri on 30/01/20.
//  Copyright © 2020 Gama Techno. All rights reserved.
//

import Foundation

struct OvertimeApprovalList: Decodable {
    var status: Int
    var message: String
    var data: OvertimeApprovalListData?
}

struct OvertimeApprovalListData: Decodable {
    var total_page: Int
    var overtime = [OvertimeApprovalListDataItem]()
}

struct OvertimeApprovalListDataItem: Decodable {
    var id: String?
    var date: String?
    var number: String?
    var photo: String?
    var dates: String?
}
