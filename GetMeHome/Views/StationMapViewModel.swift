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
//    @Published var region: MKCoordinateRegion?
    
    
    func getMapLocations(startStation: Station, destinationStations: [Station]) async -> Void {
        for station in destinationStations {
            let coordinate = await getCoordinateFromStationName(name: station.name)
            // put on the main thread since the ui has to operate on the main thread when running async
            DispatchQueue.main.async {
                self.stationMapLocations.append(MapLocation(name: station.name, coordinate: coordinate))
                self.region.center = coordinate
            }
        }
    }
    
    
    
    
    private func getCoordinateFromStationName(name: String) async -> CLLocationCoordinate2D {
        let searchRequest = MKLocalSearch.Request()
        searchRequest.naturalLanguageQuery = name + " Station"
        searchRequest.region = region
        searchRequest.pointOfInterestFilter = MKPointOfInterestFilter(including: [MKPointOfInterestCategory(rawValue: "publicTransport")])
        
        let results = try? await MKLocalSearch(request: searchRequest).start()
        let item = results?.mapItems.first!
        let coordinate = (item?.placemark.coordinate)!
        return coordinate
     
    }
}
