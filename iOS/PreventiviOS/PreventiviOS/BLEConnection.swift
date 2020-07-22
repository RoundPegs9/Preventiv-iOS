//
//  BLEConnection.swift
//  PreventiviOS
//
//  Created by Sai Gurrapu
//  Copyright © 2020 Sai Gurrapu. All rights reserved.
//

import CoreBluetooth
import SwiftUI

var userStatus: String = ""
var covidDevices = [String]()

class BLEConnection: NSObject, CBCentralManagerDelegate, CBPeripheralManagerDelegate {
    let defaults = UserDefaults.standard
    var service: CBMutableService!
    var centralManager: CBCentralManager!
    var myPeripheral: CBPeripheralManager!
    //Peripheral Identifiers
    var characteristic: CBMutableCharacteristic!
    static let serviceIdentifier = "CCD442AC-A851-4AEB-AD44-E587B88D506B" //Temp Identifier
    static let characteristicIdentifier = "3EBAC3A2-10B5-4F0A-A3BE-CE3A6AA2DA2B" //Temp Identifier
    @State var UserUUID = ""


    /*
     // MARK: - Peripheral Manager Broadcasting Services
     */
    func startPeripheralBroadcast() {
        self.myPeripheral = CBPeripheralManager(delegate: self, queue: nil)
    }

    func setup() {
        let characteristicUUID = CBUUID(string: BLEConnection.self.characteristicIdentifier)

        characteristic = CBMutableCharacteristic(type: characteristicUUID, properties: [.read, .notify], value: nil, permissions: [.readable])

        let descriptor = CBMutableDescriptor(type: CBUUID(string: CBUUIDCharacteristicUserDescriptionString), value: "BLESensor prototype")
        characteristic.descriptors = [descriptor]

        let serviceUUID = CBUUID(string: BLEConnection.self.serviceIdentifier)
        let service = CBMutableService(type: serviceUUID, primary: true)

        service.characteristics = [characteristic]

        myPeripheral.add(service)
    }

    func peripheralManagerDidUpdateState(_ peripheral: CBPeripheralManager) {
        print("peripheralManagerDidUpdateState \(peripheral.state.rawValue)")

        if peripheral.state == .poweredOn {
            setup()
        }else {
            print("peripheral is not available: \(peripheral.state.rawValue)")
        }
    }

    // MARK: Generates a random UUID String For User Upon App Install
    func generateUniqueUUID() -> String{


        if !defaults.bool(forKey: "UUIDSet"){

        defaults.set(true, forKey: "UUIDSet")
        defaults.set("\(randomUUIDString(length: 10))", forKey: "UserUUID")
        }

        print("Unique UUID -> \(defaults.object(forKey: "UserUUID") as? String ?? "")")
        return defaults.object(forKey: "UserUUID") as? String ?? ""
    }

    func peripheralManager(_ peripheral: CBPeripheralManager, didAdd service: CBService, error: Error?) {
        if let error = error {
            print("Could not add service: \(error.localizedDescription)")
        } else {
            print("peripheral added service. Start advertising")
            let advertisementData: [String: Any] = [
                CBAdvertisementDataServiceUUIDsKey: [CBUUID(string: BLEConnection.serviceIdentifier)],
                CBAdvertisementDataLocalNameKey: "\(generateUniqueUUID())-\(defaults.integer(forKey: "UserStatus"))"
                
            ]
            myPeripheral.startAdvertising(advertisementData)
        }
    }

    func peripheralManagerDidStartAdvertising(_ peripheral: CBPeripheralManager, error: Error?) {
        if let error = error {
            print("Could not start advertising: \(error.localizedDescription)")
        } else {
            print("peripheral started advertising")
        }
    }

    func stopPeripheralAdvt(){
        self.myPeripheral.stopAdvertising()
    }


    /*
     // MARK: - Central Manager Scanning Services
     */
    func startCentralManager() {
        self.centralManager = CBCentralManager(delegate: self, queue: nil)
    }

    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        switch (central.state) {
        case .unsupported:
            print("BLE is Unsupported")
            break
        case .unauthorized:
            print("BLE is Unauthorized")
            break
        case .unknown:
            print("BLE is Unknown")
            break
        case .resetting:
            print("BLE is Resetting")
            break
        case .poweredOff:
            print("BLE is Powered Off")
            break
        case .poweredOn:
            print("BLE powered on")
            centralManager.scanForPeripherals(withServices: nil)
            break
        @unknown default:
            break
        }
    }

    func stopScanning(){
        self.centralManager.stopScan()
    }

    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        if (peripheral.name?.contains("-0"))! || ((peripheral.name?.contains("-1")) != nil){
            covidDevices.append(peripheral.name ?? "")
            print(covidDevices)
        }
        //print(peripheral)

    }
}
