//
//  SavedPlaces.swift
//  GetMeHome
//
//  Created by Benjamin Alexander on 11/08/2023.
//

import Foundation
import MapKit

struct Home {
    var lat: Double = 51.658539
    var long: Double = -0.703750
    var zoom: Double = 0.5
    var location = CLLocationCoordinate2D(latitude: 51.658539, longitude: -0.703750)
    var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 51.658539, longitude: -0.703750),
        span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5))
}

