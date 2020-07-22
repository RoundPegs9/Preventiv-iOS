//
//  Symptoms.swift
//  PreventiviOS
//
//  Created by Sai Gurrapu
//  Copyright © 2020 Sai Gurrapu. All rights reserved.
//

import SwiftUI

struct Symptoms: View {

    var body: some View {

        ZStack{
            Color(red: 248/255, green: 251/255, blue: 255/255)
            .edgesIgnoringSafeArea(.all)
            ScrollView(.vertical, showsIndicators: false){
            VStack{
                VStack(alignment: .leading){
                Text("Symptoms")
                    .font(.largeTitle)
                    .bold()
                }

                HStack{
                SymptomCard(image: "fever", symptom:"Fever/Chills").background(Color.white).cornerRadius(15).shadow(radius: 2)
                    SymptomCard(image: "nausea", symptom:"Nausea").background(Color.white).cornerRadius(15).shadow(radius: 2)
                }.padding(.leading,15).padding(.trailing,15).padding(.top,20)

                HStack{
                SymptomCard(image: "fatigue", symptom:"Fatigue").background(Color.white).cornerRadius(15).shadow(radius: 2)
                    SymptomCard(image: "runnynose", symptom:"Runny Nose").background(Color.white).cornerRadius(15).shadow(radius: 2)
                }.padding(.leading,15).padding(.trailing,15).padding(.top,20)
                HStack{
                SymptomCard(image: "cough", symptom:"Cough").background(Color.white).cornerRadius(15).shadow(radius: 2)
                    SymptomCard(image: "bodyache", symptom:"Body Aches").background(Color.white).cornerRadius(15).shadow(radius: 2)
                }.padding(.leading,15).padding(.trailing,15).padding(.top,20)
                HStack{
                SymptomCard(image: "sorethroat", symptom:"Sore Throat").background(Color.white).cornerRadius(15).shadow(radius: 2)
                    SymptomCard(image: "headache", symptom:"Headache").background(Color.white).cornerRadius(15).shadow(radius: 2)
                }.padding(.leading,15).padding(.trailing,15).padding(.top,20)


            }.padding(.top,30).padding(.bottom,50)
        }
        }
    }
}

struct Symptoms_Previews: PreviewProvider {
    static var previews: some View {
        Symptoms()
    }
}
