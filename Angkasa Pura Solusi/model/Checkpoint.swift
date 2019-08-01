//
//  Checkpoint.swift
//  Angkasa Pura Solusi
//
//  Created by Arief Zainuri on 31/07/19.
//  Copyright © 2019 Gama Techno. All rights reserved.
//

import Foundation

struct Checkpoint {
    var checkpoint_id: String?
    var checkpoint_name: String?
    var checkpoint_radius: String?
    var checkpoint_latitude: String?
    var checkpoint_longitude: String?
    
    init(checkpoint_id: String, checkpoint_name: String, checkpoint_radius: String, checkpoint_latitude: String, checkpoint_longitude: String) {
        self.checkpoint_id = checkpoint_id
        self.checkpoint_name = checkpoint_name
        self.checkpoint_radius = checkpoint_radius
        self.checkpoint_latitude = checkpoint_latitude
        self.checkpoint_longitude = checkpoint_longitude
    }
    
}
