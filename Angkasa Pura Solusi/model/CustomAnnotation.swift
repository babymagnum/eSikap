//
//  CustomAnnotation.swift
//  Angkasa Pura Solusi
//
//  Created by Arief Zainuri on 30/07/19.
//  Copyright © 2019 Gama Techno. All rights reserved.
//

import Foundation
import MapKit
import Contacts

class CustomAnnotation: NSObject, MKAnnotation {
    let venueName: String?
    let coordinate: CLLocationCoordinate2D
    
    init(_ venueName: String, _ coordinate: CLLocationCoordinate2D) {
        self.venueName = venueName
        self.coordinate = coordinate
        super.init()
    }
    
    var subtitle: String? {
        return venueName
    }
    
    var title: String? {
        return venueName
    }
    
    func mapItem() -> MKMapItem {
        let placeMark = MKPlacemark(coordinate: coordinate)
        let mapItem = MKMapItem(placemark: placeMark)
        mapItem.name = venueName
        return mapItem
    }
}
