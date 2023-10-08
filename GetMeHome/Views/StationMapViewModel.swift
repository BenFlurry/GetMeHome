//
//  StationMapViewModel.swift
//  GetMeHome
//
//  Created by Benjamin Alexander on 28/08/2023.
//

import Foundation
import MapKit

class LocationManager: NSObject, ObservableObject {
    private var locationManager = CLLocationManager()
    @Published var location: CLLocation?
    
    override init() {
        super.init()
        self.locationManager.delegate = self
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        location = locations.last
        print(location?.description ?? "None")
    }
}

extension LocationManager: CLLocationManagerDelegate {
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
            case .notDetermined:
                print("undetermined")
                
            case .restricted:
                print("restricted")
            case .denied:
                print("denied")
            case .authorizedAlways:
                print("authorised always")
                manager.requestLocation()
            case .authorizedWhenInUse:
                print("when in use")
                manager.startUpdatingLocation()
                
            @unknown default:
                print("unknown case")
        }
    }
}

@MainActor
final class StationMapViewModel: ObservableObject {
    @Published var region = MKCoordinateRegion.home
    
    private var startMapLocation: MapLocation?
    @Published var destinationMapLocations: [MapLocation] = []
    private var locationManager = LocationManager()
    
    
    func getMapCoordinates(destinationStations: [String]) async -> Void {
        for station in destinationStations {
            let coordinate = await getCoordinateFromStationName(name: station)
            self.destinationMapLocations.append(MapLocation(name: station, coordinate: coordinate))
        }
    }
    
    func getRouteAndETA(destinationStations: [String]) async -> Void {
        await getMapCoordinates(destinationStations: destinationStations)
        
        for (index, location) in destinationMapLocations.enumerated() {
            var modifiedLocation = location
         
            let request = MKDirections.Request()

            if let userLocation = locationManager.location {
                print("got location")
                request.source = MKMapItem(placemark: MKPlacemark(coordinate: userLocation.coordinate))
            } else {
                print("failed to get location")
                request.source = MKMapItem(placemark: MKPlacemark(coordinate: .home))
            }
            request.transportType = .transit
            request.destination = MKMapItem(placemark: MKPlacemark(coordinate: location.coordinate))

            let directionsRequest = MKDirections(request: request)
            
            guard let response = try? await directionsRequest.calculateETA() else { return }
            
            let eta = Int(round(response.expectedTravelTime/60))
            modifiedLocation.etaTime = eta
            modifiedLocation.timeOfArrival = response.expectedArrivalDate.formatted(date: .omitted, time: .shortened)
            modifiedLocation.timeOfStart = response.expectedDepartureDate.formatted(date: .omitted, time: .shortened)
            
            destinationMapLocations[index] = modifiedLocation
        }
    }
    
    private func getCoordinateFromStationName(name: String) async -> CLLocationCoordinate2D {
        let searchRequest = MKLocalSearch.Request()
        searchRequest.naturalLanguageQuery = name + " Station"
        searchRequest.region = region
        searchRequest.pointOfInterestFilter = MKPointOfInterestFilter(including: [MKPointOfInterestCategory(rawValue: "publicTransport")])
        
        let results = try? await MKLocalSearch(request: searchRequest).start()

        let item = results?.mapItems.first!
        let coordinate = (item?.placemark.coordinate)!
        return coordinate
        
    }
}
