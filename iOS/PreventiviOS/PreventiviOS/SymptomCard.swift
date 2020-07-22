//
//  SymptomCard.swift
//  PreventiviOS
//
//  Created by Sai Gurrapu
//  Copyright © 2020 Sai Gurrapu. All rights reserved.
//

import SwiftUI

struct SymptomCard: View {
    let image: String
    let symptom: String

    var body: some View {
        VStack{
            Image(image).resizable().aspectRatio(contentMode: .fit)
            Text("\(symptom)")
        }.padding(.all, 15)
    }
}

struct SymptomCard_Previews: PreviewProvider {
    static var previews: some View {
        SymptomCard(image: "Test", symptom: "Test")
    }
}
