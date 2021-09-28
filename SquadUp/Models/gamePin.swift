//
//  gamePin.swift
//  SquadUp-v4
//
//  Created by Tommy Alpert on 11/6/20.
//

import Foundation
import CoreLocation
import MapKit

class gamePin : NSObject, MKAnnotation {
    
    dynamic var coordinate : CLLocationCoordinate2D
    var title : String?
    
    init(coordinate: CLLocationCoordinate2D, title: String) {
        self.coordinate = coordinate
        self.title = title
    }
    
}
