//
//  DepartureCity+CoreDataProperties.swift
//  Project
//
//  Created by VLAD on 4/13/16.
//  Copyright © 2016 Vlad. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension DepartureCity {

    @NSManaged var cityId: NSNumber?
    @NSManaged var cityTitle: String?
    @NSManaged var countryTitle: String?
    @NSManaged var date: NSDate?
    @NSManaged var districtTitle: String?
    @NSManaged var regionTitle: String?
    @NSManaged var point: NSManagedObject?
    @NSManaged var stations: NSSet?

}


 