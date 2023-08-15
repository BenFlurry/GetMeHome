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
    @Binding var places: [MapLocation]
    // setup the place marker
    // setup the coordinate region
    @State var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(
            latitude: 0.0,
            longitude: 0.0),
        span: MKCoordinateSpan(
            latitudeDelta: Home().zoom,
            longitudeDelta: Home().zoom))
    
    var body: some View {
        Map(coordinateRegion: $region,
            annotationItems: places) { place in
            MapMarker(coordinate: place.coordinate, tint: .cyan)

        }
        .ignoresSafeArea()
    }

    
}

        

//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        StationMapView()
//    }
//}
