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
    // setup the place marker
    // setup the coordinate region
    @State var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(
            latitude: Home().lat,
            longitude: Home().long),
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
        var stationMapLocations: [MapLocation] = []
        for station in destinationStations {
            getLocationFromName(name: station.name) { coordinates in
                if let coordinates = coordinates {
                    let stationWithCoordinates = MapLocation(name: station.name, coordinate: coordinates)
                    print(stationWithCoordinates)
                    stationMapLocations.append(stationWithCoordinates)
                }
            }
        }
        print(stationMapLocations)
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
