//
//  StationMapViewModel.swift
//  GetMeHome
//
//  Created by Benjamin Alexander on 28/08/2023.
//

import Foundation
import MapKit

final class StationMapViewModel: ObservableObject {
    @Published var stationMapLocations: [MapLocation] = []
    @Published var region = Home().region
    @Published var routePolylines: [MKPolyline] = []
    @Published var etaTime: [TimeInterval] = []
//    @Published var region: MKCoordinateRegion?
    private var startPlacemark: MKPlacemark?
    private var destinationPlacemarks: [MKPlacemark] = []
    
    
    func getMapCoordinates(startStation: Station, destinationStations: [Station], completion: @escaping ([MapLocation]) -> Void) {
        var stations = destinationStations
        stations.append(startStation)
        for station in stations {
            getCoordinateFromStationName(name: station.name) { coordinate in
                self.stationMapLocations.append(MapLocation(name: station.name, coordinate: coordinate))
                self.region.center = coordinate
                self.destinationPlacemarks.append(MKPlacemark(coordinate: coordinate))
                completion(self.stationMapLocations)
            }
            // put on the main thread since the ui has to operate on the main thread when running async
        }
//        getCoordinateFromStationName(name: startStation.name) { coordinate in
//            self.stationMapLocations.append(MapLocation(name: startStation.name, coordinate: coordinate))
//            self.region.center = coordinate
//            self.destinationPlacemarks.append(MKPlacemark(coordinate: coordinate))
//            completion(self.stationMapLocations)
//
    }

    
    
//    func getPolyline(startStation: Station, destinationStations: [Station]) -> Void {
//        getMapCoordinates(startStation: startStation, destinationStations: destinationStations)
//        let request = MKDirections.Request()
//        request.source = MKMapItem(placemark: startPlacemark!)
//        request.destination = MKMapItem(placemark: destinationPlacemarks.first!)
//        request.transportType = .transit
//        request.requestsAlternateRoutes = true
//
//        let directions = MKDirections(request: request)
//        directions.calculate(completionHandler: { (response, error) in
//            guard let response = response else { return }
//            for route in response.routes {
//                self.routePolylines.append(route.polyline)
//            }
//        })
//    }
    
    
    
    
    
    private func getCoordinateFromStationName(name: String, completion: @escaping (CLLocationCoordinate2D) -> Void) {
        let searchRequest = MKLocalSearch.Request()
        searchRequest.naturalLanguageQuery = name + " Station"
        searchRequest.region = region
        searchRequest.pointOfInterestFilter = MKPointOfInterestFilter(including: [MKPointOfInterestCategory(rawValue: "publicTransport")])
        
        // might wanna make this a guard statement
//        let results = try? await MKLocalSearch(request: searchRequest).start()
//        let item = results?.mapItems.first!
//        let coordinate = (item?.placemark.coordinate)!
//        return coordinate
        let request = MKLocalSearch(request: searchRequest)
//        var coordinate: CLLocationCoordinate2D?
        request.start(completionHandler: { response, error in
            guard let response = response else { return }
            let item = response.mapItems.first!
            completion(item.placemark.coordinate)
        })
//        if let coordinate = coordinate {
//            return coordinate
//        } else {
//            print("tried to return before coordinate calculated")
//            return CLLocationCoordinate2D(latitude: Home().lat, longitude: Home().long)
//        }
     
    }
}
