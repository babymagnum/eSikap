//
//  DetailRequestCar.swift
//  Angkasa Pura Solusi
//
//  Created by Arief Zainuri on 16/01/20.
//  Copyright © 2020 Gama Techno. All rights reserved.
//

import Foundation

struct DetailRequestCar: Decodable {
    var status: Int
    var message: String
    var data: DetailRequestCarData?
}

struct DetailRequestCarData: Decodable {
    var id: String?
    var number: String?
    var emp_id: String?
    var emp_name: String?
    var date_use: String?
    var time_use_start: String?
    var time_use_end: String?
    var type: String?
    var dest_id: String?
    var dest_name: String?
    var address: String?
    var state_id: String?
    var state_name: String?
    var city_id: String?
    var city_name: String?
    var purpose: String?
    var category_id: String?
    var category_name: String?
    var passenger_qty: String?
    var vehicle_id: String?
    var vehicle_name: String?
    var vehicle_nopol: String?
    var vehicle_capacity: String?
    var driver_user_id: String?
    var driver_name: String?
    var invitation: String?
    var status_id: String?
    var status_name: String?
    var insert_timestamp: String?
    var update_timestamp: String?
    var vehicle: String?
    var status_color: String?
    var participants = [DetailRequestCarParticipantItem]()
    var approval = [DetailRequestCarApprovalItem]()
}

struct DetailRequestCarParticipantItem: Decodable {
    var emp_id: String
    var emp_name: String
}

struct DetailRequestCarApprovalItem: Decodable {
    var emp_name: String
    var status_id: String
    var status: String
    var status_color: String
}
