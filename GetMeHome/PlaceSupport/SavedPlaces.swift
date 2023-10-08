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

extension MKCoordinateRegion {
    static let home = MKCoordinateRegion(
        center: .home,
        span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5)
    )
}

extension CLLocationCoordinate2D {
    static let home = CLLocationCoordinate2D(latitude: 51.52196, longitude: -0.14032)
}

struct Data {
    func getDestinations() -> [String] {
        return ["Amersham",
                "Chalfont & Latimer",
                "High Wycombe",
                "Beaconsfield"]
    }
}

struct MapLocation: Identifiable {
    
    let id = UUID()
    let name: String
    let coordinate: CLLocationCoordinate2D
    var isStart: Bool = false
    var etaTime: Int?
    var timeOfArrival: String?
    var timeOfStart: String?
    
    init(name: String, lat: Double, long: Double, isStart: Bool) {
        self.name = name
        self.coordinate = CLLocationCoordinate2D(
            latitude: lat,
            longitude: long)
    }
    
    init(name: String, coordinate: CLLocationCoordinate2D, isStart: Bool) {
        self.name = name
        self.coordinate = coordinate
        self.isStart = true

    }
    
    init(name: String, coordinate: CLLocationCoordinate2D) {
        self.name = name
        self.coordinate = coordinate
    }
}


