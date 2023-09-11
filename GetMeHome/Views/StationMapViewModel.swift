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
    @Published var routePolylines: [MKRoute] = []
    @Published var etaTime: [TimeInterval] = []
    //    @Published var region: MKCoordinateRegion?
    private var startPlacemark: MKPlacemark?
    private var destinationPlacemarks: [MKPlacemark] = []
    
    
    func getMapCoordinates(startStation: Station, destinationStations: [Station]) async -> Void {
        for station in destinationStations {
            let coordinate = await getCoordinateFromStationName(name: station.name)
            // put on the main thread since the ui has to operate on the main thread when running async
            
            self.stationMapLocations.append(MapLocation(name: station.name, coordinate: coordinate))
            self.region.center = coordinate
            self.destinationPlacemarks.append(MKPlacemark(coordinate: coordinate))
            
        }
        let coordinate = await getCoordinateFromStationName(name: startStation.name)
        
        self.stationMapLocations.append(MapLocation(name: startStation.name, coordinate: coordinate))
        self.region.center = coordinate
        self.startPlacemark = MKPlacemark(coordinate: coordinate)
        
    }
    
    func getMapDirections(startStation: Station, destinationStations: [Station]) async -> Void {
        await getMapCoordinates(startStation: startStation, destinationStations: destinationStations)
        let request = MKDirections.Request()
        request.source = MKMapItem(placemark: startPlacemark!)
        request.destination = MKMapItem(placemark: destinationPlacemarks.first!)
        request.transportType = .transit
        request.requestsAlternateRoutes = true
        
        let directions = MKDirections(request: request)
        guard let eta = try? await directions.calculateETA() else { return }
        let time = eta.expectedTravelTime
        DispatchQueue.main.async {
            self.etaTime.append(time)
        }
        
        //        let response = try? await directions.calculate()
        guard let response = try? await directions.calculate() else { return }
        DispatchQueue.main.async {
            for route in response.routes {
                self.routePolylines.append(route)
                print(route)
            }
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
