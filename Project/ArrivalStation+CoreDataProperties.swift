//
//  ArrivalStation+CoreDataProperties.swift
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

extension ArrivalStation {

    @NSManaged var cityId: NSNumber?
    @NSManaged var cityTitle: String?
    @NSManaged var countryTitle: String?
    @NSManaged var districtTitle: String?
    @NSManaged var regionTitle: String?
    @NSManaged var stationId: NSNumber?
    @NSManaged var stationTitle: String?
    @NSManaged var city: ArrivalCity?
    @NSManaged var point: ArrivalStationPoint?

}

 