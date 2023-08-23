//
//  ContentView.swift
//  GetMeHome
//
//  Created by Benjamin Alexander on 11/08/2023.
//

import SwiftUI
import MapKit

struct StationMapView: View {

    @State var stationMapLocations: [MapLocation]
    @State var region: MKCoordinateRegion
    
    init(stationMapLocations: [MapLocation], region: MKCoordinateRegion) {
        self.stationMapLocations = stationMapLocations
        self.region = region
        print("initialised")
        print(stationMapLocations)
        print(region)
    }
    
    var body: some View {
        Map(coordinateRegion: $region,
            annotationItems: stationMapLocations) { place in
            MapMarker(coordinate: place.coordinate, tint: .red)
        }
            .ignoresSafeArea()
        
    }
    
    
    
}






//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        StationMapView()
//    }
//}
