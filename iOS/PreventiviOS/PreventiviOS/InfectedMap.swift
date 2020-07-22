//
//  GoogMapView.swift
//  PreventiviOS
//
//  Created by Sai Gurrapu
//  Copyright © 2020 Sai Gurrapu. All rights reserved.
//

import SwiftUI
import UIKit
import GoogleMaps
import GoogleMapsUtils

var mapView: GMSMapView!

struct InfectedMap : UIViewRepresentable {

        let marker : GMSMarker = GMSMarker()
        let mapStyling: String = GMapStyle()

        //Creates a `UIView` instance to be presented.
     func makeUIView(context: Context) -> GMSMapView {
            getUserLocation()

            // Create a GMSCameraPosition
            let camera = GMSCameraPosition.camera(withLatitude: usrCoordinates[0], longitude: usrCoordinates[1], zoom: 16.0)
            mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
            do {
              // Set the map style by passing a valid JSON string.
              mapView.mapStyle = try GMSMapStyle(jsonString: mapStyling)
            } catch {
              NSLog("One or more of the map styles failed to load. \(error)")
            }
            //mapView.setMinZoom(14, maxZoom: 3000)
            mapView.settings.compassButton = true
            mapView.isMyLocationEnabled = true
            mapView.settings.myLocationButton = true
            mapView.settings.scrollGestures = true
            mapView.settings.zoomGestures = true
            mapView.settings.rotateGestures = true
            mapView.settings.tiltGestures = true
            mapView.isIndoorEnabled = false
            mapView.camera = camera

            return mapView
        }

    //Updates the presented `UIView` to the latest configuration.
    func updateUIView(_ mapView: GMSMapView, context: Context) {
        getUserLocation()
        
        // Creates a marker in the center of the map.
        marker.position = CLLocationCoordinate2D(latitude: usrCoordinates[0], longitude: usrCoordinates[1])
        marker.title = "My Location"
        //marker.map = mapView
    }
}
