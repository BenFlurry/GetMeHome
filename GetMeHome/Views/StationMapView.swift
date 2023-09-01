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
    @State var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(
            latitude: Home().lat,
            longitude: Home().long),
        span: MKCoordinateSpan(
            latitudeDelta: Home().zoom,
            longitudeDelta: Home().zoom))
    
    @StateObject private var viewModel = StationMapViewModel()
    
    var body: some View {
//        Map(coordinateRegion: $viewModel.region,
//            annotationItems: viewModel.stationMapLocations) { place in
//            MapMarker(coordinate: place.coordinate, tint: .red)
//
//        }
//
//            .ignoresSafeArea()
//            .task {
//                await viewModel.getMapCoordinates(startStation: startStation, destinationStations: destinationStations)
//            }
        MapView(startStation: startStation, destinationStations: destinationStations)

    }
    
    
}

struct MapView: UIViewRepresentable {
    @StateObject private var viewModel = StationMapViewModel()
    @State var startStation: Station?
    @State var destinationStations: [Station]
    
    func makeUIView(context: Context) -> MKMapView {
//        viewModel.getPolyline(startStation: startStation!, destinationStations: destinationStations)
        let map = MKMapView()
        map.region = viewModel.region
        viewModel.getMapCoordinates(startStation: startStation!, destinationStations: destinationStations)
//        for line in viewModel.routePolylines {
//            map.addOverlay(line)
//        }
        for station in viewModel.stationMapLocations {
            let marker = MapMarker(coordinate: <#T##CLLocationCoordinate2D#>)
            map.a
        }
        return map
    }
    
    
    func updateUIView(_ uiView: MKMapView, context: Context) {
        
    }
    
    typealias UIViewType = MKMapView
    
    
}






//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        StationMapView()
//    }
//}
