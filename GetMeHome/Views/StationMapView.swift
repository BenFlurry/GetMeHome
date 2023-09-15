//
//  ContentView.swift
//  GetMeHome
//
//  Created by Benjamin Alexander on 11/08/2023.
//

import SwiftUI
import MapKit

@available(iOS 17.0, *)
struct StationMapView: View {
    // THESE ARE HARDCODED FOR NOW
    @Binding var startStation: Station
    @Binding var destinationStations: [Station]
    
    @StateObject private var viewModel = StationMapViewModel()
    @State private var cameraPosition: MapCameraPosition = .region(.home)
    
    
    var body: some View {
        VStack {
            Map(position: $cameraPosition) {
                ForEach(viewModel.destinationMapLocations) { station in
                    Annotation(station.name, coordinate: station.coordinate) {
                        ZStack() {
                            Text(station.etaTime?.description ?? "Calculating")
                        }
                    }
                    
                    
                    
                }
            }
            .ignoresSafeArea()
            .onAppear { Task{await viewModel.getRouteAndETA(startStation: startStation, destinationStations: destinationStations)} }
            .mapStyle(.standard(emphasis: .muted,
                                pointsOfInterest: .including([MKPointOfInterestCategory(rawValue: "publicTransport")])))
            
        }
        
    }
}

//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        StationMapView()
//    }
//}
