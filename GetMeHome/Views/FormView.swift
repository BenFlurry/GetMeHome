//
//  FormView.swift
//  GetMeHome
//
//  Created by Benjamin Alexander on 21/08/2023.
//

import SwiftUI

@available(iOS 17.0, *)
struct FormView: View {
    // need to add app storage for this
    @State var destinationStations: [Station] = Data().getDestinations()
    @State var startStation: Station = Data().getStart()
    @State var showDestinationForm: Bool = false
    
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
                    Button {
                        showDestinationForm.toggle()
                    } label: {
                        Text("Go!")
                            .font(.title)
                            .fontWeight(.bold)
                    }
//                    .padding()
                }
            } // toolbar
        } // NavigationView
        .sheet(isPresented: $showDestinationForm, content: {
            DestinationSheet(destinations: destinationStations)
        })
    }
}

struct FormView_Previews: PreviewProvider {
    static var previews: some View {
        FormView()
    }
}
