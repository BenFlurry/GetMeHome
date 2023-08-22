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
                    // possible calculate here, and pass all the info in as its own struct into stationmapview
                    // need to have a button here, and an if statement, if the processign of the data has finished, then the navigation link will be there, if not then it wont
                    // navigation link will stay as is like this (except passing in the processed stations), but the button will trigger process stations function
                    NavigationLink(destination: StationMapView(startStation: $startStation, destinationStations: $destinationStations)) {
                        Text("Go!")
                            .font(.title)
                            .fontWeight(.bold)
                    }
                    .padding()
                }
            } // toolbar
        } // NavigationView
    }
}

//struct FormView_Previews: PreviewProvider {
//    static var previews: some View {
//        FormView()
//    }
//}
