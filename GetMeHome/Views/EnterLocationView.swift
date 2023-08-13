//
//  EnterLocationView.swift
//  GetMeHome
//
//  Created by Benjamin Alexander on 11/08/2023.
//

import SwiftUI
import MapKit

struct Station: Identifiable {
    var id = UUID()
    var name: String
}

struct Data {
    func getDestinations() -> [Station] {
        return [Station(name: "Amersham"),
                Station(name: "Chalfont & Latimer")]
    }
    func getStart() -> Station {
        return Station(name: "Great Portland Street")
    }
}


struct EnterLocationView: View {
    @State var inputtedStations: [Station] = Data().getDestinations()
    @State var destination: Station = Data().getStart()
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
        ZStack(alignment: .center) {
            Map(coordinateRegion: $region).ignoresSafeArea().opacity(1)
            
            VStack() {
                Text("Get Me Home")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding()

                NavigationView {
                    List {
                        Section(header: Text("Start")
                            .fontWeight(.bold)
                            .font(.title)) {
                                TextField("Enter Start Station", text: $destination.name)
                            }
                        Section(header: Text("Destinations")
                            .fontWeight(.bold)
                            .font(.title)
                        ) {
                            ForEach($inputtedStations) { $station in
                                TextField("Enter Destination Station", text: $station.name)
                            }
                            .onDelete { inputtedStations.remove(atOffsets: $0) }
                            .onMove { inputtedStations.move(fromOffsets: $0, toOffset: $1) }
                        } // Section
                    } // List
                    .toolbar {
                        ToolbarItem(placement: .navigationBarTrailing) {
                            EditButton().font(.title3).fontWeight(.semibold)
                        } // ToolbarItem
                        ToolbarItem(placement: .bottomBar) {
                            Button {
                                inputtedStations.append(Station(name:""))
                            } label: {
                                Text("Add Destination").font(.title3).fontWeight(.semibold)
                            }
                        } // ToolbarItem
                    } // toolbar
                } // NavigationView
                .cornerRadius(15.0)
                .shadow(radius: 30)
                .padding(.horizontal)

                // Go Button
                HStack {
                    Spacer()
                        .padding()
                    Button {
                        processInputs()
                    } label: {
                        Text("Go!")
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(.black)
                    }
                    .foregroundColor(.white)
                    .padding()
                    .frame(minWidth: 0, maxWidth: .infinity)
                    .background(Color.white)
                    .cornerRadius(20)
                    .shadow(radius: 5)
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(Color.gray, lineWidth: 2)
                    )
                    Spacer()
                        .padding()
                } // HStack Go Button
            }// Screen VStack
        } // Screen ZStack
    } // var View
    
    func processInputs() -> Void {
        // pass the start point into apple maps to find location
        // pass the destinations into apple maps to find location
        // get the coords for the locations, create the Place structs and pass into MapView
    }
    
}

struct EnterLocationView_Previews: PreviewProvider {
    static var previews: some View {
        EnterLocationView()
    }
}
