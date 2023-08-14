//
//  Place.swift
//  GetMeHome
//
//  Created by Benjamin Alexander on 11/08/2023.
//

import Foundation
import MapKit

struct MapLocation: Identifiable {
    let id = UUID()
    let name: String
    let coordinate: CLLocationCoordinate2D
    
    init(name: String, lat: Double, long: Double) {
        self.name = name
        self.coordinate = CLLocationCoordinate2D(
            latitude: lat,
            longitude: long)
    }
    
    init(name: String, coordinate: CLLocationCoordinate2D) {
        self.name = name
        self.coordinate = coordinate
    }
}
