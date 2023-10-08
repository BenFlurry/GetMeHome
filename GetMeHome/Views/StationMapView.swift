////
////  ContentView.swift
////  GetMeHome
////
////  Created by Benjamin Alexander on 11/08/2023.
////
//
//import SwiftUI
//import MapKit
//
//@available(iOS 17.0, *)
//struct StationMapView: View {
//    @State var startStation: Station = Data().getStart()
//    @State var destinationStations: [Station] = Data().getDestinations()
//    
//    @StateObject private var viewModel = StationMapViewModel()
//    @State private var cameraPosition: MapCameraPosition = .region(.home)
//
//
//    @State private var showStationSheet: Bool = true
//    @State private var showListSheet: Bool = false
//    
//    var body: some View {
//        Map(position: $cameraPosition) {
//            ForEach(viewModel.destinationMapLocations) { station in
//                Marker(station.name, coordinate: station.coordinate)
//                
//            }
//            Marker("Home", coordinate: .home)
//                .mapOverlayLevel(level: .aboveLabels)
//        }
//
//        .mapStyle(.standard(pointsOfInterest: .including([MKPointOfInterestCategory(rawValue: "publicTransport")])))
//        .sheet(
//            isPresented: $showStationSheet,
//            onDismiss: {
//                Task{ await viewModel.getRouteAndETA(startStation: startStation, destinationStations: destinationStations) }
//            }, content: {
//                FormView(destinationStations: $destinationStations, startStation: $startStation, show: $showStationSheet)
//                
//            }
//        )
//        .sheet(isPresented: $showListSheet,
//               content: {
//            List() {
//                ForEach(viewModel.destinationMapLocations) { station in
//                    if !station.isStart {
//                        VStack {
//                            Text(station.name)
//                                .fontWeight(.bold)
//                                .font(.title3)
//                            HStack {
//                                Spacer()
//                                VStack {
//                                    Text("Travel Time")
//                                        .font(.caption)
//                                    Text(station.etaTime != nil ? "\(station.etaTime!.description) mins" : "Calculating...")
//                                        .fontWeight(.bold)
//                                }
//                                Spacer()
//                                VStack {
//                                    Text("Arrival Time")
//                                        .font(.caption)
//                                    Text(station.timeOfArrival?.description ?? "Calculating...")
//                                        .fontWeight(.bold)
//                                }
//                                Spacer()
//                            }
//                            .padding()
//                            Button(action: {
//                                let mapItem = MKMapItem(placemark: MKPlacemark(coordinate: station.coordinate))
//                                mapItem.name = station.name
//                                mapItem.openInMaps(launchOptions: [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeTransit])
//                            }, label: {
//                                Text("Open In Maps")
//                                    .foregroundColor(.white)
//                                    .font(.title3)
//                                    .fontWeight(.bold)
//                            })
//                            .padding()
//                            .background(Color.blue)
//                            .cornerRadius(15)
//                        }
//                        
//                    }
//                }
//            }
//        })
//        .overlay(alignment: .topLeading, content: {
//            Button(action: {
//                showStationSheet.toggle()
//            }, label: {
//                Text("   < Edit")
//                    .foregroundStyle(Color(.blue))
//                    .fontWeight(.bold)
//                    .shadow(radius: 15)
//            })
//        })
//        .safeAreaInset(edge: .bottom,
//                       content: {
//            Button(action: {
//                showListSheet.toggle()
//            }, label: {
//                Text("Show List")
//                    .foregroundStyle(Color(.white))
//                    .fontWeight(.bold)
//                    .font(.title)
//                    .shadow(radius: 15)
//                    .padding()
//                    .background(Color(.gray).opacity(0.7).cornerRadius(15))
//            })
//
//        })
//        
//        
//        
//    }
//    
//}
//
//@available(iOS 17.0, *)
//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        StationMapView()
//    }
//}
//
////let formatter = DateComponentsFormatter()
////formatter.unitsStyle = .abbreviated
////formatter.allowedUnits = [.hour, .minute]
////return formatter.string(from: route.expectedTravelTime)
