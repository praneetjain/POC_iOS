//
//  Location+CoreDataProperties.swift
//  MyLocations
//
//  Created by Praneet Jain on 5/17/16.
//  Copyright © 2016 Razeware. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData
import CoreLocation

extension Location {

    @NSManaged var latitude: Double
    @NSManaged var longitude: Double
    @NSManaged var date: NSDate
    @NSManaged var placemark: CLPlacemark?
    @NSManaged var category: String
    @NSManaged var locationDescription: String

}
