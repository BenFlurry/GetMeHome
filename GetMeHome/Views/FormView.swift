//
//  FormView.swift
//  GetMeHome
//
//  Created by Benjamin Alexander on 21/08/2023.
//

import SwiftUI

struct FormView: View {
    @Binding var startStation: Station
    @Binding var destinationStations: [Station]
    var body: some View {
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
                            TextField("Enter Start Station", text: $startStation.name)
                        }
                    Section(header: Text("Destinations")
                        .fontWeight(.bold)
                        .font(.title)
                    ) {
                        ForEach($destinationStations) { $station in
                            TextField("Enter Destination Station", text: $station.name)
                        }
                        .onDelete { destinationStations.remove(atOffsets: $0) }
                        .onMove { destinationStations.move(fromOffsets: $0, toOffset: $1) }
                    } // Section
                } // List
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        EditButton().font(.title3).fontWeight(.semibold)
                    } // ToolbarItem
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button {
                            destinationStations.append(Station(name:""))
                        } label: {
                            Text("Add").font(.title3).fontWeight(.semibold)
                        }
                    } // ToolbarItem
                    ToolbarItem(placement: .bottomBar) {
                        NavigationLink(destination: StationMapView(startStation: $startStation, destinationStations: $destinationStations)) {
                            Text("Go!")
                                .font(.title)
                                .fontWeight(.bold)
                        }
                        .padding()
                    }
                } // toolbar
//                HStack {
//                    Spacer().padding()
//
//                    NavigationLink(destination: StationMapView(startStation: $startStation, destinationStations: $destinationStations)) {
//                        Text("Go!")
//                            .font(.title)
//                            .fontWeight(.bold)
//                            .foregroundColor(.black)
//                        }
//                        .foregroundColor(.white)
//                        .padding()
//                        .frame(minWidth: 0, maxWidth: .infinity)
//                        .background(Color.white)
//                        .cornerRadius(20)
//                        .shadow(radius: 5)
//
//
//                    Spacer().padding()
//
//                } // HStack Go Button
            } // NavigationView
            .cornerRadius(15.0)
            .shadow(radius: 30)
            .padding(.horizontal)
        } // Screen VStack
    }
}

//struct FormView_Previews: PreviewProvider {
//    static var previews: some View {
//        FormView()
//    }
//}
