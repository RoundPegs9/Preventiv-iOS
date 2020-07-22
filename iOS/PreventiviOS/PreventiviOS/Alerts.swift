//
//  Alerts.swift
//  PreventiviOS
//
//  Created by Sai Gurrapu
//  Copyright © 2020 Sai Gurrapu. All rights reserved.
//

import SwiftUI

struct Alerts: View {
    let address: String
    let date: String

    var body: some View {
        NavigationView{
        ZStack{
            Color(red: 248/255, green: 251/255, blue: 255/255)
            .edgesIgnoringSafeArea(.all)
            AlertCard(address: \(address), date: \(date)).background(Color.white).cornerRadius(15).padding(.all,30).shadow(radius: 2)
                Spacer()
            }.navigationBarTitle(Text("Nearby Alerts"))
        }
    }
}

struct Alerts_Previews: PreviewProvider {
    static var previews: some View {
        Alerts(address: "", date: "")
    }
}
