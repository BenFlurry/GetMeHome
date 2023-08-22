//
//  ContentView.swift
//  GetMeHome
//
//  Created by Benjamin Alexander on 11/08/2023.
//

import SwiftUI
import MapKit

struct StationMapView: View {
    // THESE ARE HARDCODED FOR NOW
    @Binding var startStation: Station
    @Binding var destinationStations: [Station]
    @State var stationMapLocations: [MapLocation] = []
    // setup the place marker
    // setup the coordinate region
    @State var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(
            latitude: 0,
            longitude: 0),
        span: MKCoordinateSpan(
            latitudeDelta: Home().zoom,
            longitudeDelta: Home().zoom))
    
    //    @State var stationMapLocations: [MapLocation] = []
    
    var body: some View {
        Map(coordinateRegion: $region,
            annotationItems: processStationNames()) { place in
            MapMarker(coordinate: place.coordinate, tint: .red)
        }
            .ignoresSafeArea()
        
    }
    
    func processStationNames() -> [MapLocation] {
        for station in destinationStations {
            getLocationFromName(name: station.name) { coordinates in
                if let coordinates = coordinates {
                    
                    let stationWithCoordinates = MapLocation(name: station.name, coordinate: coordinates)
                    stationMapLocations.append(stationWithCoordinates)
                }
            }
        }
        // problem is that it returns the function before the async requests have come in, resulting in the default being displayed
        
        // okay this needs to be in the other file, and run before trying ot make the map. it will have a function trigger here, which only tries to make the map once all the stations have been processed so it doesnt return early.
        return stationMapLocations
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






//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        StationMapView()
//    }
//}
