//
//  HelpView.swift
//  Roadtripping4U
//
//  Created by Camille Mince on 1/8/21.
//

import SwiftUI

struct HelpView: View {
    var body: some View {
        
        ZStack {
            Image("roadtripbackground")
                .resizable()
                .edgesIgnoringSafeArea(.all)
                .scaledToFill()
            
            VStack{
                
                VStack {
                Text("Your next roadtrip,")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .scaleEffect(1.3)
                Text("planned for you in seconds...")
                    .font(.title)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.leading)
                }
                .padding([.top, .bottom], 30.0)
                VStack {
                    Text("How it works: ")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .padding(.bottom, 5.0)
                        .scaleEffect(1.2)
                    Text("1. You tell us a little bit about you and your trip")
                        .font(.body)
                        .padding(.bottom, 2)
                    Text("2. That's it - We'll take care of the rest! ")
                        .padding(.bottom, 20.0)
                    HStack {
                        Text("Swipe to Step 1")
                        Image(systemName: "arrow.forward")
                            .padding(.horizontal, 30.0)
                            .scaleEffect(3)
                    }
                    
                }
                .padding(.vertical, 30.0)
                Spacer()
                Spacer()
                Spacer()
                Spacer()
            }.foregroundColor(.white)
        }
    }
}

struct HelpView_Previews: PreviewProvider {
    static var previews: some View {
        HelpView()
    }
}

