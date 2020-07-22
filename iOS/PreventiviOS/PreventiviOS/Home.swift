//
//  Home.swift
//  PreventiviOS
//
//  Created by Sai Gurrapu
//  Copyright © 2020 Sai Gurrapu. All rights reserved.
//

import SwiftUI
import CoreBluetooth
import Firebase

struct Home: View {
    private let ble = BLEConnection() // Must always be a strong local member when calling
    @State var exposedCovid = false
    @State var selectedPos = false
    @State var selectedNeg = false
    @State var selectedSymp = false
    @State var selectedNoTest = false
    @State var bleStatusOn = false
    @State var selectedBtn = 4
    @State private var showBLEMessage = false
    @ObservedObject private var datas = firebaseData
    @ObservedObject private var addUsersToDb = firebaseUsersData

    //Local Storage
    let defaults = UserDefaults.standard

    var body: some View {
        NavigationView{
            ZStack{
                Color(red: 248/255, green: 251/255, blue: 255/255)
                    .edgesIgnoringSafeArea(.all)
                VStack {
                    if covidDevices.count == 0 && !selectedPos{

                        Image("healthyClock").resizable().aspectRatio(contentMode: .fit).padding(.top,-55).padding(.bottom, -5).overlay(toggleBLEBtn, alignment: .topTrailing)

                    }
                    else{
                        Image("infectedClock").resizable().aspectRatio(contentMode: .fit).padding(.top,-55).padding(.bottom, -5).overlay(toggleBLEBtn, alignment: .topTrailing)
                    }

                    HStack(alignment: .center){
                        Button(action: {
                            userStatus = "1"
                            self.defaults.set(1, forKey: "UserStatus")

                            self.selectedNeg = false
                            self.selectedSymp = false
                            self.selectedNoTest = false
                            self.selectedPos.toggle()

                        }) {
                            Text("Tested\nPositive")
                                .fontWeight(.semibold)
                                .font(.headline)
                                .frame(width: 150, height: 85, alignment: .center)
                                .foregroundColor(.white)
                                .background(selectedPos ? Color(red: 0/255, green: 168/255, blue: 107/255) : Color(red: 61/255, green: 139/255, blue: 255/255) )
                                .cornerRadius(20)
                                .shadow(radius: 2)
                                .multilineTextAlignment(.center)

                        }
                        //                .buttonStyle(PlainButtonStyle())

                        Button(action: {
                            userStatus = "0"
                            self.defaults.set(0, forKey: "UserStatus")

                            self.selectedPos = false
                            self.selectedSymp = false
                            self.selectedNoTest = false
                            self.selectedNeg.toggle()

                        }) {
                            Text("Tested\nNegative")
                                .fontWeight(.semibold)
                                .font(.headline)
                                .frame(width: 150, height: 85, alignment: .center)
                                .foregroundColor(.white)
                                .background(selectedNeg ? Color(red: 0/255, green: 168/255, blue: 107/255) : Color(red: 61/255, green: 139/255, blue: 255/255) )
                                .cornerRadius(20)
                                .shadow(radius: 2)
                                .multilineTextAlignment(.center)

                        }

                    }
                    .padding(.bottom, 20)
                    HStack(alignment: .center){

                        Button(action: {
                        }) {
                            NavigationLink(destination: Symptoms().onAppear{
                                userStatus = "1"
                                self.defaults.set(1, forKey: "UserStatus")

                                self.selectedPos = false
                                self.selectedNeg = false
                                self.selectedNoTest = false
                                self.selectedSymp.toggle()
                            }){
                                Text("Feeling\nSymptoms")
                                    .fontWeight(.semibold)
                                    .font(.headline)
                                    .frame(width: 150, height: 85, alignment: .center)
                                    .foregroundColor(.white)
                                    .background(selectedSymp ? Color(red: 0/255, green: 168/255, blue: 107/255) : Color(red: 61/255, green: 139/255, blue: 255/255) )
                                    .cornerRadius(20)
                                    .shadow(radius: 2)
                                    .multilineTextAlignment(.center)


                            }
                        }
                        //                .buttonStyle(PlainButtonStyle())

                        Button(action: {
                            userStatus = "0"
                            self.defaults.set(0, forKey: "UserStatus")

                            self.selectedPos = false
                            self.selectedNeg = false
                            self.selectedSymp = false
                            self.selectedNoTest.toggle()

                            getUserLocation()
                            firebaseData.createData(lati: usrCoordinates[0], longi: usrCoordinates[1])

                        }) {
                            Text("Not Been\nTested")
                                .fontWeight(.semibold)
                                .font(.headline)
                                .frame(width: 150, height: 85, alignment: .center)
                                .foregroundColor(.white)
                                .background(selectedNoTest ? Color(red: 0/255, green: 168/255, blue: 107/255) : Color(red: 61/255, green: 139/255, blue: 255/255) )
                                .cornerRadius(20)
                                .shadow(radius: 2)
                                .multilineTextAlignment(.center)

                        }

                    }
                    .padding(.bottom, 20)
                    Text("Total Connections: \(covidDevices.count)\nInfected Connections: \(covidDevices.count) ")
                        .fontWeight(.semibold)
                        .font(.headline)
                        .frame(width: 312, height: 85, alignment: .center)
                        .foregroundColor(.white)
                        .background(exposedCovid ? Color(red: 255/255, green: 122/255, blue: 122/255) : Color(red: 0/255, green: 168/255, blue: 107/255))
                        .cornerRadius(20)
                        .shadow(radius: 2)
                        .multilineTextAlignment(.center)
                    Spacer()

                }
            }.onAppear{
                self.viewLoaded()
                getUserLocation()
            }.alert(isPresented: $showBLEMessage, content: { self.alert })
        }

    }
    

    var alert: Alert {
        if bleStatusOn{
            return Alert(title: Text("Preventiv BLE is On"),
                         message: Text("Preventiv is actively scanning your environment."),
                         dismissButton: .default(Text("OK")) )
        }else{
            return Alert(title: Text("Preventiv BLE is Off"),
                         message: Text("Preventiv is NOT scanning your environment. Please take proper precautions when outdoors."),
                         dismissButton: .default(Text("OK")) )
        }
    }

    var toggleBLEBtn: some View{
        return Button(action: {
            self.bleStatusOn.toggle()
            self.showBLEMessage = true
            self.toggleBLE()

        }) {
            if bleStatusOn == false{
                HStack{
                    // FIXME: Come up with a better place to put Preventiv Name
                    //                    Text("Preventiv").font(.system(size: 38)).bold().foregroundColor(Color.white).padding(.trailing,5)

                    Image(systemName: "wifi.slash")
                        .foregroundColor(Color.gray)
                        .font(.system(size: 28))
                        .padding(.all, 20)
                        .padding(.top, -5)
                        .background(Color.white)
                        .clipShape(Circle())
                }

            }else{
                HStack{
                    //                Text("Preventiv").font(.system(size:          38)).bold().foregroundColor(Color.white).padding(.trailing,5)

                    Image(systemName: "wifi")
                        .foregroundColor(Color(red: 0/255, green: 168/255, blue: 107/255))
                        .font(.system(size: 28))
                        .padding(.all, 18)
                        .background(Color.white)
                        .clipShape(Circle())
                }
            }

        }.padding(.top, 5).padding(.leading, 70).padding(.trailing, 40)
    }

    func toggleBLE(){

        if bleStatusOn{
            print("Initializing BLE")
            ble.startCentralManager()
            ble.startPeripheralBroadcast()
        } else{
            storeDevicesLocally()
            print("BLE Turned Off")
            ble.stopScanning()
            ble.stopPeripheralAdvt()
        }
    }

    func storeDevicesLocally(){
        let currDevices = defaults.object(forKey: "CovidDevicesList") as? [String] ?? [String]()

        if currDevices.count != 0{
            for uuid in covidDevices{
                addUsersToDb.createData(userID: "\(uuid)")
            }
        }
        
        let newDevices = currDevices + covidDevices
        defaults.set(newDevices, forKey: "CovidDevicesList")
        print(defaults.object(forKey: "CovidDevicesList") as? [String] ?? [String]())
    }

    // Multi-threading operation for background BLE
    func viewLoaded(){
        //        DispatchQueue.main.async {
        //            self.ble.startCentralManager()
        //        }

    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}





//Extra Modifiers
/*
 GreenBox: Color(red: 0/255, green: 168/255, blue: 107/255).frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height/2)
 .padding(.top,-430)

 */
