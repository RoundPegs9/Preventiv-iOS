//
//  FirebaseUsers.swift
//  PreventiviOS
//
//  Created by Sai Gurrapu
//  Copyright © 2020 Sai Gurrapu. All rights reserved.
//

import Firebase
import FirebaseFirestore
import SwiftUI

let firebaseUsersData = FirebaseUsers()

// MARK: Infected Users Data
class FirebaseUsers: ObservableObject {
    let userDBCollection = Firestore.firestore().collection("hashes")

    // MARK: Firestore CRUD Operations
    func createData(userID: String) {
        // To create or overwrite a single document
        dbCollection.document().setData(["hash":userID]) { (err) in
            if err != nil {
                print((err?.localizedDescription)!)
                return
            }else {
                print("Connection added to Firebase")
            }
        }
    }

    
}
