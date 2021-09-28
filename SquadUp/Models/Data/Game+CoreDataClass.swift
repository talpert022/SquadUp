//
//  Game+CoreDataClass.swift
//  SquadUp-v4
//
//  Created by Tommy Alpert on 11/6/20.
//
//

import Foundation
import CoreData
import CoreLocation
import MapKit
import Contacts

public class Game: NSManagedObject, MKAnnotation {
    
    public var coordinate : CLLocationCoordinate2D {
        get {return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)}
        set {}
    }
    
    public var subtitle: String? {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
        dateFormatter.timeZone = TimeZone(abbreviation: "EST")
        let localDate = dateFormatter.date(from: date!.description)
        
        guard localDate != nil else {
                assert(false, "no date from string")
                return ""
            }
        // Add Date
        dateFormatter.dateFormat = "MMM dd"
        dateFormatter.timeZone = TimeZone(abbreviation: "EST")
        var subTitle = "Event on \(dateFormatter.string(from: localDate!))"
        
        // Add Time
        dateFormatter.dateFormat = "h:mm a"
        dateFormatter.timeZone = TimeZone(abbreviation: "EST")
        subTitle += " at \(dateFormatter.string(from: localDate!))"
        
        if eventDescription != nil {
            subTitle += "\n\(String(describing: eventDescription!))"
            return subTitle
        } else {
            return subTitle
        }
    }
    
    var location : CLLocation {
        return CLLocation(latitude: latitude, longitude: longitude)
    }
    
    var mapItem: MKMapItem? {
      guard let location = title else {
        return nil
      }

      let addressDict = [CNPostalAddressStreetKey: location]
      let placemark = MKPlacemark(
        coordinate: coordinate,
        addressDictionary: addressDict)
      let mapItem = MKMapItem(placemark: placemark)
      mapItem.name = title
      return mapItem
    }
    
    var image : UIImage {
        guard let name = title else { return UIImage() }
        
        var image = UIImage(named: "\(name)Icon")!
        image = resizeImage(image: image, targetSize: CGSize(width: 50, height: 50))
        return image
    }
    
    func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
        let size = image.size

        let widthRatio  = targetSize.width  / size.width
        let heightRatio = targetSize.height / size.height

        // Figure out what our orientation is, and use that to form the rectangle
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
        }

        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)

        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return newImage!
    }

}
