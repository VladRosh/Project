//
//  ArrivalStationPoint+CoreDataProperties.swift
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

extension ArrivalStationPoint {

    @NSManaged var latitude: NSNumber?
    @NSManaged var longitude: NSNumber?
    @NSManaged var station: ArrivalStation?

}
