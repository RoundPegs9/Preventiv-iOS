//
//  ContentView.swift
//  PreventiviOS
//
//  Created by Sai Gurrapu
//  Copyright © 2020 Sai Gurrapu. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @State private var selection = 0

    var body: some View {

        TabView {
            Home()
               .edgesIgnoringSafeArea([.top, .bottom])
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("Home")
            }
            Alerts()
                .tabItem {
                    Image(systemName: "message.fill")
                    Text("Alerts")
            }
            HeatMap()
                .tabItem {
                    Image(systemName: "flame.fill")
                    Text("Heatmap")
            }
        }   // End of TabView
            .font(.headline)
            .imageScale(.medium)
            .font(Font.title.weight(.regular))

    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
