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
    public var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(
            latitude: Home().lat,
            longitude: Home().long),
        span: MKCoordinateSpan(
            latitudeDelta: Home().zoom,
            longitudeDelta: Home().zoom))
    
    
    func getMapLocations(startStation: Station, destinationStations: [Station]) -> Void {
        for station in destinationStations {
            getLocationFromName(name: station.name) { coordinates in
                if let coordinates = coordinates {
                    
                    let stationWithCoordinates = MapLocation(name: station.name, coordinate: coordinates)
                    self.stationMapLocations.append(stationWithCoordinates)
                }
            }
        }
        // problem is that it returns the function before the async requests have come in, resulting in the default being displayed
        
        // okay this needs to be in the other file, and run before trying ot make the map. it will have a function trigger here, which only tries to make the map once all the stations have been processed so it doesnt return early.
    }
    
    
    
    func getLocationFromName(name: String, completion: @escaping (CLLocationCoordinate2D?) -> Void) {
        let searchRequest = MKLocalSearch.Request()
        searchRequest.naturalLanguageQuery = name + " Station"
        searchRequest.region = region
        searchRequest.pointOfInterestFilter = MKPointOfInterestFilter(including: [MKPointOfInterestCategory(rawValue: "publicTransport")])
        
        
        let search = MKLocalSearch(request: searchRequest)
        search.start { response, error in
            guard let item = response?.mapItems.first, let location = item.placemark.location else {
                completion(nil)
                return
            }
            completion(location.coordinate)
        }
    }
}
