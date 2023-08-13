//
//  ContentView.swift
//  GetMeHome
//
//  Created by Benjamin Alexander on 11/08/2023.
//

import SwiftUI
import MapKit





struct MapView: View {
    @State var places = [Place(name: "Home",
                           lat: Home().lat,
                           long: Home().long)]
    // setup the place marker
    // setup the coordinate region
    @State var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(
            latitude: Home().lat,
            longitude: Home().long),
        span: MKCoordinateSpan(
            latitudeDelta: Home().zoom,
            longitudeDelta: Home().zoom))
    
    var body: some View {
        Map(coordinateRegion: $region,
            annotationItems: places) { place in
            MapMarker(coordinate: place.coordinate, tint: .cyan)
//            MapAnnotation(coordinate: place.coordinate, content: { Text(place.name) })
        }
        .ignoresSafeArea()
    }

    
}

        

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        MapView()
    }
}
