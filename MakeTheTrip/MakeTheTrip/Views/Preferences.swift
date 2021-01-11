//
//  Preferences.swift
//  MakeTheTrip
//
//  Created by Camille Mince on 1/11/21.
//

import SwiftUI

struct Preferences: View {
    
    @State var start: String
    @State var end: String
    @State var numStops: Int
    @State var preferences: [String]
    @State var done: Bool = true
    
    
    func buttonAction(text: String) {
        if self.preferences.contains(text) {
                preferences = removePref(array: &preferences, elt: text)
                    } else {
                        preferences.append(text)
    }
    }
    
    var body: some View {
        VStack{
            HStack {
                Spacer()
                NavigationLink(destination: HelpView()) {
                    Text("Help")
                        .padding([.leading, .top, .bottom], 10)
                    Image(systemName: "lightbulb.fill")
                        .padding([.trailing, .top, .bottom], 10)
                }.background(Color.yellow.opacity(0.7))
                .foregroundColor(.white)
                .cornerRadius(20)
                .padding(.trailing, 10)
            }
            
            HStack {
                Text("Where are you starting?")
                    .padding(.leading, 10)
                TextField("  starting at...", text: $start).background(Color.gray.opacity(0.3))
                    .cornerRadius(20)
                    .padding()
                
            }
            
            HStack {
                Text("Where are you ending?")
                    .padding(.leading, 10)
                TextField("  going to...", text: $end)
                    .background(Color.gray.opacity(0.3))
                    .cornerRadius(20)
                    .padding()
            }
                        
            Stepper(value: $numStops, in: 1...20) {
                Text("I want to stop \(numStops) time\(numStops > 1 ? "s":"") on the route")
                    .padding(.leading, 10)
            }
                        
            
            HStack {
                Text("Your currently selected preferences: ").padding(.top, 10)
                Text(preferencesToString(preferences: preferences)).fixedSize(horizontal: false, vertical: true)
            }
            VStack{
            
                HStack{
                    Button(action: {
                        buttonAction(text: "cafe")
                    }) {
                        Text(" + cafe ")
                    }.buttonStyle(PreferencesButtonStyle())
                                
                    Button(action: {
                        buttonAction(text: "amusement_park")
                    }) {
                        Text(" + amusement park ")
                        }.buttonStyle(PreferencesButtonStyle())
                }
                            
                HStack{
                    Button(action: {
                        buttonAction(text: "tourist_attraction")
                    }) {
                        Text(" + tourist attraction ")
                    }.buttonStyle(PreferencesButtonStyle())
                                
                    Button(action: {
                        buttonAction(text: "aquarium")
                    }) {
                        Text(" + aquarium ")
                    }.buttonStyle(PreferencesButtonStyle())
                }
                            
                HStack{
                    Button(action: {
                        buttonAction(text: "museum")
                    }) {
                        Text(" + museum ")
                    }.buttonStyle(PreferencesButtonStyle())
                                
                    Button(action: {
                        buttonAction(text: "art_gallery")
                    }) {
                        Text(" + art gallery ")
                    }.buttonStyle(PreferencesButtonStyle())
                }
                            
                HStack{
                    Button(action: {
                        buttonAction(text: "bakery")
                    }) {
                        Text(" + bakery ")
                    }.buttonStyle(PreferencesButtonStyle())
                                
                    Button(action: {
                        buttonAction(text: "zoo")
                    }) {
                        Text(" + zoo ")
                    }.buttonStyle(PreferencesButtonStyle())
                }
                            
                            
                HStack{
                    Button(action: {
                        buttonAction(text: "campground")
                    }) {
                        Text(" + campground ")
                    }.buttonStyle(PreferencesButtonStyle())
                                
                    Button(action: {
                        buttonAction(text: "park")
                    }) {
                        Text(" + park ")
                    }.buttonStyle(PreferencesButtonStyle())
                }
                            
                HStack{
                    Button(action: {
                        buttonAction(text: "bar")
                    }) {
                        Text(" + bar ")
                    }.buttonStyle(PreferencesButtonStyle())
                                
                    Button(action: {
                        buttonAction(text: "casino")
                    }) {
                        Text(" + casino ")
                    }.buttonStyle(PreferencesButtonStyle())
                }
                            
                HStack{
                    Button(action: {
                        buttonAction(text: "RV_park")
                    }) {
                        Text(" + RV park ")
                    }.buttonStyle(PreferencesButtonStyle())
                                
                    Button(action: {
                        buttonAction(text: "restaurant")
                    }) {
                        Text(" + restaurant ")
                    }.buttonStyle(PreferencesButtonStyle())
                }
            }
                        
            Button("Generate Itinerary", action: {
                let trip = Trip(start: start, end: end, waypoints: [], preferences: preferences, numStops: numStops)
                trip.generateTrip()
                while !trip.done {}
            })
        }
    }
}

struct Preferences_Previews: PreviewProvider {
    static var previews: some View {
        Preferences(start: "", end: "", numStops: 0, preferences: [], done: false)
    }
}

