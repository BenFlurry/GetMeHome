//
//  StationDetails.swift
//  GetMeHome
//
//  Created by Benjamin Alexander on 18/09/2023.
//

import SwiftUI
import MapKit

struct StationDetails: View {
    @Binding var selection: MKMapItem?
    @Binding var show: Bool
    var body: some View {
        VStack() {
            Text(selection?.placemark.name ?? "No")
            Button(action: {
                selection = nil
                show.toggle()
            }, label: {
                Image(systemName: "xmark.circle.fill")
                    .resizable()
                    .foregroundStyle(.gray, Color(.systemGray6))
                    .frame(width: 24, height: 24)
            })
        }
        
    }
}

#Preview {
    StationDetails(selection: .constant(nil), show: .constant(true))
}
