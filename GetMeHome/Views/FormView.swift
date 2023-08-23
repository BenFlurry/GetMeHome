//
//  FormView.swift
//  GetMeHome
//
//  Created by Benjamin Alexander on 21/08/2023.
//

import SwiftUI
import MapKit

struct FormView: View {
    @Binding var startStation: Station
    @Binding var destinationStations: [Station]
    @State var stationMapLocations: [MapLocation] = []
    @State var stationsRecieved: Bool = false
    @State var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(
            latitude: Home().lat,
            longitude: Home().long
        ),
        span: MKCoordinateSpan(
            latitudeDelta: Home().zoom,
            longitudeDelta: Home().zoom)
    )
    
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
                        processStationNames()
                    } label: {
                        Text("Go!")
                            .font(.title)
                            .fontWeight(.bold)
                    }
                    .padding()

                    if stationsRecieved {
                        NavigationLink(destination: StationMapView(stationMapLocations: stationMapLocations,
                                                                   region: region),
                                       isActive: $stationsRecieved,
                                       label: { EmptyView() }
                        )

                    }
                    

                }
            } // toolbar
        } // NavigationView
    }
    
    func processStationNames() -> Void {
        stationsRecieved = false
        stationMapLocations = []
        
        let dispatchGroup = DispatchGroup()
        
        for station in destinationStations {
            dispatchGroup.enter()
            getLocationFromName(name: station.name) { coordinates in
                if let coordinates = coordinates {
                    let stationWithCoordinates = MapLocation(name: station.name, coordinate: coordinates)
                    stationMapLocations.append(stationWithCoordinates)
                }
                dispatchGroup.leave()
            }
        }
        
        dispatchGroup.notify(queue: .main) {
            if !stationMapLocations.isEmpty {
                stationsRecieved = true
                print("wooooo")
                print(stationMapLocations)
                print("Stations Recieved = \(stationsRecieved)")
            }
        }


    }
    
    
    
    func getLocationFromName(name: String, completion: @escaping (CLLocationCoordinate2D?) -> Void) {
        let searchRequest = MKLocalSearch.Request()
        searchRequest.naturalLanguageQuery = name + " Station"
        searchRequest.region = region
        searchRequest.pointOfInterestFilter = MKPointOfInterestFilter(including: [MKPointOfInterestCategory(rawValue: "publicTransport")])
        
        let search = MKLocalSearch(request: searchRequest)
        search.start { response, error in
            guard let item = response?.mapItems.first, let location = item.placemark.location else {
                completion(nil)
                return
            }
            completion(location.coordinate)
        }
    }
}

//struct FormView_Previews: PreviewProvider {
//    static var previews: some View {
//        FormView()
//    }
//}
