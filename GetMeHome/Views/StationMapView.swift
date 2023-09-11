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
    
    var body: some View {
        VStack {
            Map {
                ForEach(viewModel.stationMapLocations) { station in
                    if station.isStart {
                        Marker(station.name, coordinate: station.coordinate)
                            .tint(.blue)
                    } else {
                        Marker(station.name, coordinate: station.coordinate)
                            .tint(.red)
                    }
                }
                
//                ForEach(viewModel.routePolylines, id: \.self) { route in
//                    MapPolyline(route.polyline)
//                }
                
            }
            .ignoresSafeArea()
            .task { await viewModel.getRouteAndETA(startStation: startStation, destinationStations: destinationStations) }
            .mapStyle(.standard(pointsOfInterest: .including(MKPointOfInterestCategory(rawValue: "publicTransport"))))
            .mapControls {
                MapCompass()
                MapPitchToggle()
            }
            ForEach(viewModel.routePolylines, id: \.self) { route in
                Text(route.polyline.description)
            }
//            ForEach(viewModel.stationMapLocations) { station in
//                Text(station.name)
//            }
        }
        
    }
}

//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        StationMapView()
//    }
//}
