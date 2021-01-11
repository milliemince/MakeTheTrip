 //
 //  PreferencesButtonStyle.swift
 //  Roadtripping4U
 //
 //  Created by Camille Mince on 1/8/21.
 //

 import SwiftUI

 struct PreferencesButtonStyle: ButtonStyle {
     
     func makeBody(configuration: Self.Configuration) -> some View {
         configuration.label
             .foregroundColor(Color.white)
             .padding(.all, 10)
             .background(configuration.isPressed ? Color.gray : Color.green.opacity(0.7))
             .cornerRadius(15.0)
         
     }
 }


