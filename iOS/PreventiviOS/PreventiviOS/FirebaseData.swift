//
//  FirebaseData.swift
//  PreventiviOS
//
//  Created by Sai Gurrapu
//  Copyright © 2020 Sai Gurrapu. All rights reserved.
//

import Firebase
import FirebaseFirestore
import SwiftUI

let dbCollection = Firestore.firestore().collection("gps")
let firebaseData = FirebaseData()

// MARK: Geocoordinates Data
class FirebaseData: ObservableObject {

    @Published var data = [CoordinatesStruct]()

    init() {
        readData()
    }

    func updateFirestoreData(){
        readData()
    }

    // MARK: Firestore CRUD Operations

    // https://firebase.google.com/docs/firestore/manage-data/add-data
    func createData(lati: Double, longi: Double) {
        // To create or overwrite a single document
        dbCollection.document().setData(["latitude":lati, "longitude": longi]) { (err) in
            if err != nil {
                print((err?.localizedDescription)!)
                return
            }else {
                print("Geo coordinates added to Firebase")
            }
        }
    }

    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)

        return paths[0]
    }

    func readData(){
        let docRef = Firestore.firestore().collection("gps")

        docRef.getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                let emptyStr = ""
                let url = self.getDocumentsDirectory().appendingPathComponent("infections.json")
                do {
                    try emptyStr.write(to: url, atomically: true, encoding: .utf8)
                    //let input = try String(contentsOf: url)
                    //print(input)
                } catch {
                    print(error.localizedDescription)
                }

                var jsonFinal = "["
                for document in querySnapshot!.documents {
                    //print("\(document.data())")
                    var jsonString = "\(document.data())"
                    jsonString = jsonString.replacingOccurrences(of: "[", with: "{")
                    jsonString = jsonString.replacingOccurrences(of: "]", with: "}")
                    jsonFinal = jsonFinal + "\(jsonString) ,"
                }

                jsonFinal += "]"


                do {
                    try jsonFinal.write(to: url, atomically: true, encoding: .utf8)
                    //let input = try String(contentsOf: url)
                    //print(input)
                } catch {
                    print(error.localizedDescription)
                }
                
            }
        }
    }

    // https://firebase.google.com/docs/firestore/manage-data/delete-data
    //    func deleteData(datas: FirebaseData ,index: IndexSet) {
    //        let id = datas.data[index.first!].id
    //        dbCollection.document(id).delete { (err) in
    //            if err != nil {
    //                print((err?.localizedDescription)!)
    //                return
    //            }else {
    //                print("delete data success")
    //            }
    //            datas.data.remove(atOffsets:index)
    //        }
    //    }
    //
    //    // https://firebase.google.com/docs/firestore/manage-data/add-data
    //    func updateData(id: String, txt: String) {
    //        dbCollection.document(id).updateData(["id":txt]) { (err) in
    //            if err != nil {
    //                print((err?.localizedDescription)!)
    //                return
    //            }else {
    //                print("update data success")
    //            }
    //        }
    //    }
}
