//
//  destinationList.swift
//  GetMeHome
//
//  Created by Benjamin Alexander on 07/10/2023.
//

import SwiftUI
import MapKit

struct DestinationSheet: View {
    
    @StateObject private var viewModel = StationMapViewModel()
    @State var destinations = [String]()
    
    var body: some View {
        List() {
            ForEach(viewModel.destinationMapLocations) { station in
                VStack {
                    Text(station.name)
                        .fontWeight(.bold)
                        .font(.title3)
                    HStack {
                        Spacer()
                        VStack {
                            Text("Departure Time")
                                .font(.caption)
                            Text(station.timeOfStart?.description ?? "...")
                                .fontWeight(.bold)
                        }
                        Spacer()
                        VStack {
                            Text("Travel Time")
                                .font(.caption)
                            Text(station.etaTime != nil ? "\(station.etaTime!.description) mins" : "...")
                                .fontWeight(.bold)
                        }
                        Spacer()
                        VStack {
                            Text("Arrival Time")
                                .font(.caption)
                            Text(station.timeOfArrival?.description ?? "...")
                                .fontWeight(.bold)
                        }
                        Spacer()
                    }
                    .padding()
                    Button(action: {
                        let mapItem = MKMapItem(placemark: MKPlacemark(coordinate: station.coordinate))
                        mapItem.openInMaps(launchOptions: [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeTransit])
                    }, label: {
                        Text("Open In Maps")
                            .foregroundColor(.white)
                            .font(.title3)
                            .fontWeight(.bold)
                    })
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(15)
                }
                
                
            }
        }
        .task { await viewModel.getRouteAndETA(destinationStations: destinations) }
    }
}

//#Preview {
//    DestinationSheet()
//}
