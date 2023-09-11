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
    @Published var routeLines: [MKRoute] = []
    @Published var etaTime: [TimeInterval] = []
    
    private var startPlacemark: MKPlacemark?
    private var destinationPlacemarks: [MKPlacemark] = []
    
    
    func getMapCoordinates(startStation: Station, destinationStations: [Station]) async -> Void {
        for station in destinationStations {
            let coordinate = await getCoordinateFromStationName(name: station.name)
            
            self.stationMapLocations.append(MapLocation(name: station.name, coordinate: coordinate))
            self.destinationPlacemarks.append(MKPlacemark(coordinate: coordinate))
            
        }
        let coordinate = await getCoordinateFromStationName(name: startStation.name)
        
        self.stationMapLocations.append(MapLocation(name: startStation.name, coordinate: coordinate, isStart: true))
        self.startPlacemark = MKPlacemark(coordinate: coordinate)
        
    }
    
    func getRouteAndETA(startStation: Station, destinationStations: [Station]) async -> Void {
        await getMapCoordinates(startStation: startStation, destinationStations: destinationStations)
        
        for placemark in destinationPlacemarks {
            let request = MKDirections.Request()
            request.source = MKMapItem(placemark: startPlacemark!)

            request.transportType = .automobile
            request.requestsAlternateRoutes = false
            request.destination = MKMapItem(placemark: placemark)
            

            let directionsRequest = MKDirections(request: request)
            
            guard let response = try? await directionsRequest.calculate() else { return }
            let route = response.routes.first!
            self.etaTime.append(route.expectedTravelTime)
            self.routeLines.append(route)

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
