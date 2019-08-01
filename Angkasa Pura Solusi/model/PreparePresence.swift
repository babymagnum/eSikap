//
//  PreparePresence.swift
//  Angkasa Pura Solusi
//
//  Created by Arief Zainuri on 31/07/19.
//  Copyright © 2019 Gama Techno. All rights reserved.
//

import Foundation
import SwiftyJSON

struct PreparePresence {
    var checkpoints = [Checkpoint]()
    var is_presence_in: String?
    var day: String?
    var date: String?
    var time: String?
    var shift_start: String?
    var shift_end: String?
    var timezone: String?
    var zoom_maps: String?
    
    mutating func convertJSON(_ jsonObject: JSON) -> PreparePresence {
        let data = jsonObject["data"]
        is_presence_in = data["is_presence_in"].string ?? ""
        day = data["day"].string ?? ""
        date = data["date"].string ?? ""
        time = data["time"].string ?? ""
        shift_start = data["shift_start"].string ?? ""
        shift_end = data["shift_end"].string ?? ""
        timezone = data["timezone"].string ?? ""
        zoom_maps = data["zoom_maps"].string ?? ""
        
        let checkpointsArray = data["data_checkpoint"].array
        
        if let checkpointsArray = checkpointsArray {
            for checkpoint in checkpointsArray {
                
                let checkpointObj = Checkpoint(checkpoint_id: checkpoint["checkpoint_id"].string ?? "", checkpoint_name: checkpoint["checkpoint_name"].string ?? "", checkpoint_radius: checkpoint["checkpoint_radius"].string ?? "", checkpoint_latitude: checkpoint["checkpoint_latitude"].string ?? "", checkpoint_longitude: checkpoint["checkpoint_longitude"].string ?? "")
                
                self.checkpoints.append(checkpointObj)
            }
        }
        
        return self
    }
}
