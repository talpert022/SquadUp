//
//  ImageViewWithGradient.swift
//  SquadUp-v4
//
//  Created by Tommy Alpert on 11/5/20.
//

import Foundation
import UIKit
import AVFoundation


class ImageViewWithGradient: UIImageView
{
    let myGradientLayer: CAGradientLayer
    
    override init(frame: CGRect)
    {
        myGradientLayer = CAGradientLayer()
        super.init(frame: frame)
        self.setup()
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        myGradientLayer = CAGradientLayer()
        super.init(coder: aDecoder)
        self.setup()
    }
    
    func setup()
    {
        myGradientLayer.startPoint = CGPoint(x: 0.5, y: 0)
        myGradientLayer.endPoint = CGPoint(x: 0.5, y: 1)
        let colors: [CGColor] = [
            UIColor.clear.cgColor,
            UIColor.black.cgColor ]
        myGradientLayer.colors = colors
        myGradientLayer.isOpaque = false
        myGradientLayer.locations = [0.0, 1.0]
        self.layer.addSublayer(myGradientLayer)
    }
    
    func checkLayer() {
        
        myGradientLayer.startPoint = CGPoint(x: 0.5, y: 0)
        myGradientLayer.endPoint = CGPoint(x: 0.5, y: 1)
        let colors: [CGColor] = [
            UIColor.green.cgColor,
            UIColor.clear.cgColor,
            UIColor.black.cgColor ]
        myGradientLayer.colors = colors
        myGradientLayer.isOpaque = false
        myGradientLayer.locations = [0.0, 0.4, 1.0]
        self.layer.replaceSublayer((self.layer.sublayers?[0])!, with: myGradientLayer)
    }
    
    func regularLayer() {
        
        myGradientLayer.startPoint = CGPoint(x: 0.5, y: 0)
        myGradientLayer.endPoint = CGPoint(x: 0.5, y: 1)
        let colors: [CGColor] = [
            UIColor.clear.cgColor,
            UIColor.black.cgColor ]
        myGradientLayer.colors = colors
        myGradientLayer.isOpaque = false
        myGradientLayer.locations = [0.0, 1.0]
        self.layer.replaceSublayer((self.layer.sublayers?[0])!, with: myGradientLayer)
        
    }
    
    override func layoutSubviews()
    {
        myGradientLayer.frame = self.layer.bounds
    }
}
