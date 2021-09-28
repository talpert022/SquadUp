//
//  GameView.swift
//  SquadUp-v4
//
//  Created by Tommy Alpert on 11/7/20.
//

import Foundation
import MapKit

class GameView: MKAnnotationView {
    override var annotation: MKAnnotation? {
        willSet {
            guard let game = newValue as? Game else {
                return
            }
            
            canShowCallout = true
            calloutOffset = CGPoint(x: -5, y: 5)
            
            let mapsButton = UIButton(frame: CGRect(
              origin: CGPoint.zero,
              size: CGSize(width: 48, height: 48)))
            mapsButton.setBackgroundImage(#imageLiteral(resourceName: "Map"),for: .normal)
            
            rightCalloutAccessoryView = mapsButton

            image = game.image
            }
    }
    
}
