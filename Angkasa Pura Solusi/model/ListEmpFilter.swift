//
//  ListEmpFilter.swift
//  Angkasa Pura Solusi
//
//  Created by Arief Zainuri on 29/08/19.
//  Copyright © 2019 Gama Techno. All rights reserved.
//

import Foundation

struct ListEmpFilter: Decodable {
    var status: Int?
    var message: String?
    var data = [ItemEmp]()
}

struct ItemEmp: Decodable {
    var emp_id: String?
    var emp_nik: String?
    var emp_name: String?
    var value: String?
}
