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
    @State var region = MKCoordinateRegion.home
    
    @StateObject private var viewModel = StationMapViewModel()
    
    var body: some View {
        Map(coordinateRegion: $viewModel.region,
            annotationItems: viewModel.stationMapLocations) { place in
            MapMarker(coordinate: place.coordinate, tint: .red)
            
            
        }
            .ignoresSafeArea()
            .task { await viewModel.getMapCoordinates(startStation: startStation, destinationStations: destinationStations) }
        
        
    }
    
    
}






//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        StationMapView()
//    }
//}
