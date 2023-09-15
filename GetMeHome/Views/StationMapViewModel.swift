//
//  StationMapViewModel.swift
//  GetMeHome
//
//  Created by Benjamin Alexander on 28/08/2023.
//

import Foundation
import MapKit

@MainActor
final class StationMapViewModel: ObservableObject {
    @Published var stationMapLocations: [MapLocation] = []
    @Published var region = MKCoordinateRegion.home
//    @Published var routeLines: [MKRoute] = []
//    @Published var etaTime: [MapLocation] = []
    
    private var startMapLocation: MapLocation?
    @Published var destinationMapLocations: [MapLocation] = []
    
    
    func getMapCoordinates(startStation: Station, destinationStations: [Station]) async -> Void {
        for station in destinationStations {
            let coordinate = await getCoordinateFromStationName(name: station.name)
            self.stationMapLocations.append(MapLocation(name: station.name, coordinate: coordinate))
            self.destinationMapLocations.append(MapLocation(name: station.name, coordinate: coordinate))
        }
        let coordinate = await getCoordinateFromStationName(name: startStation.name)
        
        self.stationMapLocations.append(MapLocation(name: startStation.name, coordinate: coordinate, isStart: true))
        self.startMapLocation = MapLocation(name: startStation.name, coordinate: coordinate)
        
    }
    
    func getRouteAndETA(startStation: Station, destinationStations: [Station]) async -> Void {
        await getMapCoordinates(startStation: startStation, destinationStations: destinationStations)
        
        for var location in destinationMapLocations {
            print("heree")
            let request = MKDirections.Request()
            request.source = MKMapItem(placemark: MKPlacemark(coordinate: startMapLocation!.coordinate))
            
            // need to request multiple routes, and see which one is the fastest
            
            request.transportType = .transit
            request.requestsAlternateRoutes = false
            request.destination = MKMapItem(placemark: MKPlacemark(coordinate: location.coordinate))
            // need to offset by an hour the time due to daylight saving time
            
            let directionsRequest = MKDirections(request: request)
            
            print("pre-request")
            guard let response = try? await directionsRequest.calculateETA() else { return }
            let eta = response.expectedTravelTime/60

            location.etaTime = eta
            print("\(eta.description), \(location.name), \(response.expectedDepartureDate.description)")
//            self.etaTime.append(location)
//            self.routeLines.append(route)

        }
    }
    
    private func getCoordinateFromStationName(name: String) async -> CLLocationCoordinate2D {
        let searchRequest = MKLocalSearch.Request()
        searchRequest.naturalLanguageQuery = name + " Station"
        searchRequest.region = region
        searchRequest.pointOfInterestFilter = MKPointOfInterestFilter(including: [MKPointOfInterestCategory(rawValue: "publicTransport")])
        
        // might wanna make this a guard statement
        let results = try? await MKLocalSearch(request: searchRequest).start()

        let item = results?.mapItems.first!
        let coordinate = (item?.placemark.coordinate)!
        return coordinate
        
    }
}
