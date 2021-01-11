//
//  ContentView.swift
//  MakeTheTrip
//
//  Created by Camille Mince on 1/11/21.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        Preferences(start: "", end: "", numStops: 0, preferences: [])    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
