//
//  DetailOvertimeRealizationApproval.swift
//  Angkasa Pura Solusi
//
//  Created by Arief Zainuri on 30/01/20.
//  Copyright © 2020 Gama Techno. All rights reserved.
//

import Foundation

struct DetailOvertimeRealizationApproval: Decodable {
    var status: Int
    var message: String
    var data: DetailOvertimeRealizationApprovalData?
}

struct DetailOvertimeRealizationApprovalData: Decodable {
    var id: String?
    var number: String?
    var date: String?
    var emp_name: String?
    var unit_id: String?
    var unit_name: String?
    var overtime_emp_id: String?
    var photo: String?
    var real_approval_id: String?
    var real_reason: String?
    var real_overtimestat_id: String?
    var real_status: String?
    var real_status_icon: String?
    var real_status_date: String?
    var real_status_notes: String?
    var attachment: String?
    var attachment_name: String?
    var url_attachment: String?
    var real_status_color: String?
    var datetimes_start = [String]()
    var datetimes_start_show = [String]()
    var datetimes_end = [String]()
    var datetimes_end_show = [String]()
    var datetimes_real_start = [String]()
    var datetimes_real_end = [String]()
    var datetime_id = [String]()
    var is_processed: String?
}
