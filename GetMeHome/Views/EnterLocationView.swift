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
        return [
            Station(name: "Amersham"),
            Station(name: "Chalfont & Latimer"),
            Station(name: "Beaconsfield"),
            Station(name: "High Wycombe")
        ]
    }
    func getStart() -> Station {
        return Station(name: "Great Portland Street")
    }
}


struct EnterLocationView: View {
    
    @State var destinationStations: [Station] = Data().getDestinations()
    @State var startStation: Station = Data().getStart()
    
    var body: some View {
        FormView(startStation: $startStation, destinationStations: $destinationStations)
            .ignoresSafeArea()
    }
    
}




struct EnterLocationView_Previews: PreviewProvider {
    static var previews: some View {
        EnterLocationView()
    }
}
