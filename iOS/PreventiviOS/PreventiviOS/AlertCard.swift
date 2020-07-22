//
//  AlertCard.swift
//  PreventiviOS
//
//  Created by Sai Gurrapu
//  Copyright © 2020 Sai Gurrapu. All rights reserved.
//

import SwiftUI

struct AlertCard: View {
    let address: String
    let date: String

    var body: some View {
        HStack{
            Text("\(address)")
            Spacer()
            Text("\(date)")
        }.padding(.all, 20)
    }
}

struct AlertCard_Previews: PreviewProvider {
    static var previews: some View {
        AlertCard(address: "", date: "")
    }
}
