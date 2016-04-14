//
//  DataManager.swift
//  Project
//
//  Created by VLAD on 4/13/16.
//  Copyright © 2016 Vlad. All rights reserved.
//

import UIKit
import Foundation
import MBProgressHUD
import CoreData


public class DataManager {
    
    // MARK: - var and let
    private let bundle = NSBundle.mainBundle()
    private let appDelegate = (UIApplication.sharedApplication().delegate as! AppDelegate)
    
    // здесь передаю view как параметер, для использование с MBProgressHUD
    public func saveData(view: UIView?) {
        if let _view = view {
            let progress = MBProgressHUD.showHUDAddedTo(_view, animated: true)
            progress.mode = .Indeterminate
            progress.removeFromSuperViewOnHide = true
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                // здесь сделал, сохранение данных один раз при первом запуске, так как знаю, что эти данные сейчас не будут изменяться. зделал, чтобы всегда при загрузке приложения появлялся MBProgressHUD, так как понимаю, что в настоящем приложение данные получали бы с сервера и поэтому сделал для видимости обновление.
                let firstLaunch = NSUserDefaults.standardUserDefaults().boolForKey("firstLaunch")
                if firstLaunch == false {
                    self.save()
                    NSUserDefaults.standardUserDefaults().setBool(true, forKey: "firstLaunch")
                }
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    progress.hide(true)
                })
            })
        }
    }
    // эта функция извлекает данные из файла и сохраняет их в CoreData
    private func save() {
        guard let jsonPath = bundle.pathForResource("allStations", ofType: "json") else { return }
        guard let jsonData = NSData(contentsOfFile: jsonPath) else { return }
        let managedObjectContext = appDelegate.managedObjectContext
        
        let json = try! NSJSONSerialization.JSONObjectWithData(jsonData, options: .AllowFragments) as! [String : AnyObject]
        
        if let departureCities = json["citiesFrom"] as? [[String: AnyObject]] {
            for city in departureCities {
                let departureCityEntity = entity("DepartureCity", managedObjectContext: managedObjectContext) as! DepartureCity
                let departureCityPointEntity = entity("DeparturePoint", managedObjectContext: managedObjectContext) as! DeparturePoint
                guard let countryTitle = city["countryTitle"] as? String else { break }
                guard let point = city["point"] as? [String : AnyObject] else { break }
                guard let longitude = point["longitude"] as? Double else { break } // city point
                guard let latitude = point["latitude"] as? Double else { break } // city point
                guard let districtTitle = city["districtTitle"] as? String else { break }
                guard let cityId = city["cityId"] as? NSNumber else { break }
                guard let cityTitle = city["cityTitle"] as? String else { break }
                guard let regionTitle = city["regionTitle"] as? String else { break }
                guard let stations = city["stations"] as? [[String : AnyObject]] else { break }
                // один раз сохраняем город и его точку
                departureCityEntity.cityId = cityId
                departureCityEntity.cityTitle = cityTitle
                departureCityEntity.countryTitle = countryTitle
                departureCityEntity.districtTitle = districtTitle
                departureCityEntity.regionTitle = regionTitle
                departureCityEntity.date = NSDate()
                // create city point
                departureCityPointEntity.latitude = latitude
                departureCityPointEntity.longitude = longitude
                departureCityEntity.point = departureCityPointEntity
                
                for station in stations {
                    let departureStationEntity = entity("DepartureStation", managedObjectContext: managedObjectContext) as! DepartureStation
                    let departureStationPointEntity = entity("DepartureStationPoint", managedObjectContext: managedObjectContext) as! DepartureStationPoint
                    
                    guard let countryStationTitle = station["countryTitle"] as? String else { break }
                    guard let stationStationPoint = station["point"] as? [String : AnyObject] else { break }
                    guard let stationLongitude = stationStationPoint["longitude"] as? Double else { break }
                    guard let stationLatitude = stationStationPoint["latitude"] as? Double else { break }
                    guard let districtStationTitle = station["districtTitle"] as? String  else { break }
                    guard let cityStationId = station["cityId"] as? NSNumber else { break }
                    guard let cityStationTitle = station["cityTitle"] as? String else { break }
                    guard let regionStationTitle = station["regionTitle"] as? String else { break }
                    guard let stationId = station["stationId"] as? NSNumber else { break }
                    guard let stationTitle = station["stationTitle"] as? String else { break }
                    
                    departureStationEntity.cityId = cityStationId
                    departureStationEntity.cityTitle = cityStationTitle
                    departureStationEntity.countryTitle = countryStationTitle
                    departureStationEntity.districtTitle = districtStationTitle
                    departureStationEntity.regionTitle = regionStationTitle
                    departureStationEntity.stationId = stationId
                    departureStationEntity.stationTitle = stationTitle
                    
                    // need to add point and city
                    // add point
                    departureStationPointEntity.latitude = stationLatitude
                    departureStationPointEntity.longitude = stationLongitude
                    departureStationEntity.point = departureStationPointEntity
                    // add city
                    departureStationEntity.city = departureCityEntity
                    
                    do {
                        try managedObjectContext.save()
                    } catch let error as NSError {
                        print(error.localizedDescription, error.userInfo)
                    }
                }
            }
        } else {
            print("there is an error in departureCity")
        }
        
        if let arrivalCities = json["citiesTo"] as? [[String : AnyObject]] {
            for city in arrivalCities {
                let departureCityEntity = entity("ArrivalCity", managedObjectContext: managedObjectContext) as! ArrivalCity
                let departureCityPointEntity = entity("ArrivalPoint", managedObjectContext: managedObjectContext) as! ArrivalPoint
                guard let countryTitle = city["countryTitle"] as? String else { break }
                guard let point = city["point"] as? [String : AnyObject] else { break }
                guard let longitude = point["longitude"] as? Double else { break } // city point
                guard let latitude = point["latitude"] as? Double else { break } // city point
                guard let districtTitle = city["districtTitle"] as? String else { break }
                guard let cityId = city["cityId"] as? NSNumber else { break }
                guard let cityTitle = city["cityTitle"] as? String else { break }
                guard let regionTitle = city["regionTitle"] as? String else { break }
                guard let stations = city["stations"] as? [[String : AnyObject]] else { break }
                // один раз сохраняем город и его точку
                departureCityEntity.cityId = cityId
                departureCityEntity.cityTitle = cityTitle
                departureCityEntity.countryTitle = countryTitle
                departureCityEntity.districtTitle = districtTitle
                departureCityEntity.regionTitle = regionTitle
                departureCityEntity.date = NSDate()
                // create city point
                departureCityPointEntity.latitude = latitude
                departureCityPointEntity.longitude = longitude
                departureCityEntity.point = departureCityPointEntity
                
                for station in stations {
                    let departureStationEntity = entity("ArrivalStation", managedObjectContext: managedObjectContext) as! ArrivalStation
                    let departureStationPointEntity = entity("ArrivalStationPoint", managedObjectContext: managedObjectContext) as! ArrivalStationPoint
                    
                    guard let countryStationTitle = station["countryTitle"] as? String else { break }
                    guard let stationStationPoint = station["point"] as? [String : AnyObject] else { break }
                    guard let stationLongitude = stationStationPoint["longitude"] as? Double else { break }
                    guard let stationLatitude = stationStationPoint["latitude"] as? Double else { break }
                    guard let districtStationTitle = station["districtTitle"] as? String  else { break }
                    guard let cityStationId = station["cityId"] as? NSNumber else { break }
                    guard let cityStationTitle = station["cityTitle"] as? String else { break }
                    guard let regionStationTitle = station["regionTitle"] as? String else { break }
                    guard let stationId = station["stationId"] as? NSNumber else { break }
                    guard let stationTitle = station["stationTitle"] as? String else { break }
                    
                    departureStationEntity.cityId = cityStationId
                    departureStationEntity.cityTitle = cityStationTitle
                    departureStationEntity.countryTitle = countryStationTitle
                    departureStationEntity.districtTitle = districtStationTitle
                    departureStationEntity.regionTitle = regionStationTitle
                    departureStationEntity.stationId = stationId
                    departureStationEntity.stationTitle = stationTitle
                    
                    // need to add point and city
                    // add point
                    departureStationPointEntity.latitude = stationLatitude
                    departureStationPointEntity.longitude = stationLongitude
                    departureStationEntity.point = departureStationPointEntity
                    // add city
                    departureStationEntity.city = departureCityEntity
                    
                    do {
                        try managedObjectContext.save()
                    } catch let error as NSError {
                        print(error.localizedDescription, error.userInfo)
                    }
                }
            }
        } else {
            print("there is an error in arrival city")
        }
    }
    
    private func entity(name: String, managedObjectContext: NSManagedObjectContext) -> NSManagedObject {
        return NSEntityDescription.insertNewObjectForEntityForName(name, inManagedObjectContext: managedObjectContext)
    }
}