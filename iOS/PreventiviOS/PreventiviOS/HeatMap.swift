//
//  HeatMap.swift
//  PreventiviOS
//
//  Created by Sai Gurrapu 
//  Copyright © 2020 Sai Gurrapu. All rights reserved.
//

import SwiftUI
import GoogleMaps
import GoogleMapsUtils

struct HeatMap: View {
    @State var heatmapLayer: GMUHeatmapTileLayer!
    var gradientColors = [UIColor.blue, UIColor.red, UIColor.systemTeal]
    var gradientStartPoints = [0.2,0.5, 1.0] as? [NSNumber]
    var firestoreUpdater = FirebaseData()
    @State private var showRefreshMsg = false

    
    var body: some View {
        NavigationView{
            ZStack{
                Color(red: 248/255, green: 251/255, blue: 255/255)
                    .edgesIgnoringSafeArea(.all)
                InfectedMap().edgesIgnoringSafeArea(.all).onAppear{
                    self.setupHeatMap()
                }.overlay(refreshHeatmap, alignment: .bottomTrailing)
            }.alert(isPresented: $showRefreshMsg, content: { self.updatedHeatmap })//.navigationBarTitle(Text("Alerts").background(Color.white))
        }
    }

    var updatedHeatmap: Alert {
        return Alert(title: Text("Heat Map Updated Successfully!"),dismissButton: .default(Text("OK")) )
    }

    // MARK: Refresh Heat Map Button
    var refreshHeatmap: some View{
        return Button(action: {
            self.firestoreUpdater.updateFirestoreData()
            self.setupHeatMap()
            self.showRefreshMsg = true

        }) {
            Image(systemName: "arrow.clockwise")
                .foregroundColor(Color.white)
                .font(.system(size: 28))
                .padding(.all, 17)
                .background(Color(red: 0/255, green: 168/255, blue: 107/255))
                .clipShape(Circle())
        }.padding(.trailing,8).padding(.bottom,90)
    }

    // MARK: Generating the Heat Map
    func setupHeatMap(){
        heatmapLayer = GMUHeatmapTileLayer()
        heatmapLayer.gradient = GMUGradient(colors: gradientColors,
                                            startPoints: gradientStartPoints!,
                                            colorMapSize: 256)
        heatmapLayer.radius = 40
        heatmapLayer.opacity = 0.90
        self.addHeatmap()
        heatmapLayer.map = mapView
    }

    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)

        return paths[0]
    }

    // MARK: Generate Heat Map Density Layer
    func addHeatmap()  {
        var list = [GMUWeightedLatLng]()
        do {

            // Get the data: latitude/longitude positions
            if let path = self.getDocumentsDirectory().appendingPathComponent("infections.json") ?? Bundle.main.url(forResource: "infections", withExtension: "json") {
                let data = try Data(contentsOf: path)
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                if let object = json as? [[String: Any]] {
                    for item in object {
                        let lat = item["latitude"]
                        let lng = item["longitude"]
                        let coords = GMUWeightedLatLng(coordinate: CLLocationCoordinate2DMake(lat as! CLLocationDegrees, lng as! CLLocationDegrees), intensity: 2.0)
                        list.append(coords)
                    }

                } else {
                    print("Could not read the JSON.")
                }
            }
        } catch {
            print(error.localizedDescription)
        }
        // Add the latlngs to the heatmap layer.
        heatmapLayer.weightedData = list
    }

}



struct HeatMap_Previews: PreviewProvider {
    static var previews: some View {
        HeatMap()
    }
}
