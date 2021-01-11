//
//  ContentView.swift
//  MakeTheTrip
//
//  Created by Camille Mince on 1/11/21.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        Button(action: {
            let trip = Trip(start: "29.7604,-95.3698", end: "37.7749,-122.4194", waypoints: [], preferences: ["campground", "park", "museum"], numStops: 2)
            trip.generateTrip()
        }) {
            Text("Test Trip Generation")
        }
        .padding()
        .cornerRadius(20)
        .background(Color.green.opacity(0.3))
        .accentColor(.white)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
