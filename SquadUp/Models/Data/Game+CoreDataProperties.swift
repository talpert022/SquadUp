//
//  Game+CoreDataProperties.swift
//  SquadUp-v4
//
//  Created by Tommy Alpert on 11/6/20.
//
//

import Foundation
import CoreData

extension Game {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Game> {
        return NSFetchRequest<Game>(entityName: "Game")
    }

    @NSManaged public var latitude: Double
    @NSManaged public var longitude: Double
    @NSManaged public var title: String?
    @NSManaged public var date: Date?
    @NSManaged public var eventDescription : String?

}

extension Game : Identifiable {

}
