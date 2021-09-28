//
//  sportsCell.swift
//  SquadUp-v4
//
//  Created by Tommy Alpert on 11/5/20.
//

import UIKit

class sportsCell: UICollectionViewCell {
    
    static let reuseIdentifier = String(describing: sportsCell.self)
    
    // MARK: - Outlets
    
    @IBOutlet weak var sportImage: ImageViewWithGradient!
    @IBOutlet weak var sportText: UILabel!
    @IBOutlet weak var checkImage: UIImageView!
    
    
    func displayCell() {
        sportImage.layer.cornerRadius = 10
    }
    
    func selectCell() {
        checkImage.isHidden = !checkImage.isHidden
        if !checkImage.isHidden {
            sportImage.checkLayer()
        } else {
            sportImage.regularLayer()
        }
    }

}
