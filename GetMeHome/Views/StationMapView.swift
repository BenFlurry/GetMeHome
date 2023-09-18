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
    @State private var mapSelection: MKMapItem?
    @State private var showDetails: Bool = false
    
    
    
    var body: some View {
        Map(position: $cameraPosition, selection: $mapSelection) {
            ForEach(viewModel.destinationMapLocations) { station in
                Marker(station.name, coordinate: station.coordinate)
            }
            Marker("Home", coordinate: .home)
        }
        .ignoresSafeArea(.all)
        .onAppear { Task{await viewModel.getRouteAndETA(startStation: startStation, destinationStations: destinationStations)} }
        .mapStyle(.standard(
            pointsOfInterest: .including([MKPointOfInterestCategory(rawValue: "publicTransport")])))
        .onChange(of: mapSelection, { oldValue, newValue in
            print(mapSelection?.description ?? "Nothing Selected")
            showDetails = newValue != nil
        })
        .sheet(isPresented: $showDetails, content: {
            StationDetails(selection: $mapSelection, show: $showDetails)
                .presentationDetents([.height(340)])
                .presentationBackgroundInteraction(.enabled(upThrough: .height(340)))
        })
    }
    
}

//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        StationMapView()
//    }
//}
