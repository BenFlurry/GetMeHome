//
//  FormView.swift
//  GetMeHome
//
//  Created by Benjamin Alexander on 21/08/2023.
//

import SwiftUI

@available(iOS 17.0, *)
struct FormView: View {
    @Binding var destinationStations: [Station]
    @Binding var startStation: Station 
    @Binding var show: Bool
    
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
                        show.toggle()
                    } label: {
                        Text("Go!")
                            .font(.title)
                            .fontWeight(.bold)
                    }
//                    .padding()
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
