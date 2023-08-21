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
    
    @State var destinationStations: [Station] = Data().getDestinations()
    @State var startStation: Station = Data().getStart()

    @State var stationMapLocations: [MapLocation] = []
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
//                Map(coordinateRegion: $region).ignoresSafeArea().opacity(1)
                FormView(startStation: $startStation, destinationStations: $destinationStations)
            }
    
        } // Screen ZStack
    } // var View
    
    // MIGHT WANT TO USE MKLOCALSEARCHCOMPLETER TO AUTOCOMPLETE THE START AND DESTINATION
    


struct EnterLocationView_Previews: PreviewProvider {
    static var previews: some View {
        EnterLocationView()
    }
}
