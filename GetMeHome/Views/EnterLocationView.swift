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
    @State var dataRecieved: Bool = false
    
    @State var inputtedStations: [Station] = Data().getDestinations()
    @State var destination: Station = Data().getStart()

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
            
            
            if dataRecieved == false {
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
                            processStationNames()
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
                } // Screen VStack
            }
            if dataRecieved == true {
                Map(coordinateRegion: $region,
                    annotationItems: stationMapLocations) { place in
                    MapMarker(coordinate: place.coordinate, tint: .red)
                }
                    .ignoresSafeArea()
            }
        } // Screen ZStack
    } // var View
    
    // MIGHT WANT TO USE MKLOCALSEARCHCOMPLETER TO AUTOCOMPLETE THE START AND DESTINATION
    func processStationNames() -> [MapLocation] {
        for station in inputtedStations {
            getLocationFromName(name: station.name) { coordinates in
                if let coordinates = coordinates {
                    region.center = coordinates
                    let stationWithCoordinates = MapLocation(name: station.name, coordinate: coordinates)
                    
                    stationMapLocations.append(stationWithCoordinates)
                }
            }
        }
        dataRecieved = true
        return stationMapLocations
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
            region.center = location.coordinate
            completion(location.coordinate)
        }
    }
    
}


struct EnterLocationView_Previews: PreviewProvider {
    static var previews: some View {
        EnterLocationView()
    }
}
