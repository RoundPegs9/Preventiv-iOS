//
//  UserLocation.swift
//  PreventiviOS
//
//  Created by Sai Gurrapu
//  Copyright © 2020 Sai Gurrapu. All rights reserved.
//

import SwiftUI
import MapKit

var usrCoordinates = [Double]()

public func getUserLocation(){

    usrCoordinates = [Double]()
    let locManager = CLLocationManager()
    locManager.requestWhenInUseAuthorization()

    var currentLocation: CLLocation!

    if( CLLocationManager.authorizationStatus() == .authorizedWhenInUse ||
        CLLocationManager.authorizationStatus() ==  .authorizedAlways){

      currentLocation = locManager.location

    }

    var longitude = String(currentLocation.coordinate.longitude)
    var latitude = String(currentLocation.coordinate.latitude)

    //Round the Coordinates to Thousandths place
    longitude = String(longitude.prefix(7))
    latitude = String(latitude.prefix(6))

    usrCoordinates.append(Double(latitude) ?? 0.0)
    usrCoordinates.append(Double(longitude) ?? 0.0)
}
