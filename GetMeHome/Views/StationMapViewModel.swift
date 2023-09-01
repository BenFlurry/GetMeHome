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
    //    private var startPlacemark: MKPlacemark?
    //    private var destinationPlacemarks: [MKPlacemark] = []
    
    
    func getDestinationCoordinates(startStation: Station, destinationStations: [Station], completion: @escaping ([MapLocation]) -> Void) {
        //        var stations = destinationStations
        //        stations.append(startStation)
        for station in destinationStations {
            getCoordinateFromStationName(name: station.name) { coordinate in
                self.stationMapLocations.append(MapLocation(name: station.name, coordinate: coordinate))
                self.region.center = coordinate
                completion(self.stationMapLocations)
            }
        }
    }
    
    func getStartCoordinates(startStation: Station, completion: @escaping (MapLocation) -> Void) {
        getCoordinateFromStationName(name: startStation.name, completion: { coordinate in
            var start = MapLocation(name: startStation.name, coordinate: coordinate)
            start.isStart = true
            self.region.center = coordinate
            completion(start)
        })
    }
    
    
    
    func getPolyline(startStation: Station, destinationStations: [Station], completion: @escaping ([MKPolyline]) -> Void) {
//        var startPlacemark: MKPlacemark
        var destinationPlacemarks: [MKPlacemark] = []
        getDestinationCoordinates(startStation: startStation, destinationStations: destinationStations) { stations in
            for station in stations {
                destinationPlacemarks.append(
                    MKPlacemark(coordinate: station.coordinate)
                )
            }
        }
        
        var startPlacemark: MKPlacemark?
        print("hello")

        getStartCoordinates(startStation: startStation, completion: { station in
            print("here")
            print(station)
            startPlacemark = MKPlacemark(coordinate: station.coordinate)

        })
        
        let request = MKDirections.Request()
        request.source = MKMapItem(placemark: startPlacemark!)
        request.destination = MKMapItem(placemark: destinationPlacemarks.first!)
        request.transportType = .transit
        request.requestsAlternateRoutes = true
        
        let directions = MKDirections(request: request)
        directions.calculate(completionHandler: { (response, error) in
            guard let response = response else { return }
            for route in response.routes {
                self.routePolylines.append(route.polyline)
                completion(self.routePolylines)
            }
            
        })
    }
    
    
    
    
    
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
