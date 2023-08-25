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
