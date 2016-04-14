//
//  InfoStationViewController.swift
//  Project
//
//  Created by VLAD on 4/13/16.
//  Copyright © 2016 Vlad. All rights reserved.
//

import UIKit
import Foundation
import CoreData


class InfoStationViewController: UIViewController, NSFetchedResultsControllerDelegate {
    
    private var fetchedResultController: NSFetchedResultsController!
    var departureStation: DepartureStation!
    var arrivalStation: ArrivalStation!
    private let appDelegate = (UIApplication.sharedApplication().delegate as! AppDelegate)
    private var managedObjectContext: NSManagedObjectContext {
        return appDelegate.managedObjectContext
    }
    
    // MARK: - IBOutlet

    @IBOutlet weak var stationLabel: UILabel!
    @IBOutlet weak var districtLabel: UILabel!
    @IBOutlet weak var regionLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var countryLabel: UILabel!
    
    
    // MARK: - Lificycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.definesPresentationContext = true
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        setLabels()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - functions
    private func setLabels() {
        if departureStation != nil {
            guard let stationTitle = departureStation.stationTitle else { return }
            stationLabel.text = "Станция: \(stationTitle)"
            stationLabel.adjustsFontSizeToFitWidth = true
            guard let districtTitle = departureStation.districtTitle else { return }
            districtLabel.text = "Район: \(districtTitle)"
            districtLabel.adjustsFontSizeToFitWidth = true
            guard let regionTitle = departureStation.regionTitle else { return }
            regionLabel.text = "Регион: \(regionTitle)"
            regionLabel.adjustsFontSizeToFitWidth = true
            guard let cityTitle = departureStation.cityTitle else { return }
            cityLabel.text = "Город: \(cityTitle)"
            cityLabel.adjustsFontSizeToFitWidth = true
            guard let countryTitle = departureStation.countryTitle else { return }
            countryLabel.text = "Страна: \(countryTitle)"
            countryLabel.adjustsFontSizeToFitWidth = true
        } else {
            guard let stationTitle = arrivalStation.stationTitle else { return }
            stationLabel.text = "Станция: \(stationTitle)"
            stationLabel.adjustsFontSizeToFitWidth = true
            guard let districtTitle = arrivalStation.districtTitle else { return }
            districtLabel.text = "Район: \(districtTitle)"
            districtLabel.adjustsFontSizeToFitWidth = true
            guard let regionTitle = arrivalStation.regionTitle else { return }
            regionLabel.text = "Регион: \(regionTitle)"
            regionLabel.adjustsFontSizeToFitWidth = true
            guard let cityTitle = arrivalStation.cityTitle else { return }
            cityLabel.text = "Город: \(cityTitle)"
            cityLabel.adjustsFontSizeToFitWidth = true
            guard let countryTitle = arrivalStation.countryTitle else { return }
            countryLabel.text = "Страна: \(countryTitle)"
            countryLabel.adjustsFontSizeToFitWidth = true
        }
    }

    // MARK: - IBAction
    
    @IBAction func selectStation(sender: UIButton) {
        if departureStation != nil {
            saveDepartureStation()
        } else {
            saveArrivalStation()
        }
    }
    
    
    
    
    private func saveDepartureStation() {
        removeDepartureStation()
        let selectedDepartureStation = NSEntityDescription.insertNewObjectForEntityForName("SelectedDepartureStation", inManagedObjectContext: managedObjectContext) as! SelectedDepartureStation
        let selectedDepartureStationPoint = NSEntityDescription.insertNewObjectForEntityForName("SelectedDepartureStationPoint", inManagedObjectContext: managedObjectContext) as! SelectedDepartureStationPoint
        selectedDepartureStation.cityId = departureStation.cityId
        selectedDepartureStation.cityTitle = departureStation.cityTitle
        selectedDepartureStation.countryTitle = departureStation.countryTitle
        selectedDepartureStation.districtTitle = departureStation.districtTitle
        selectedDepartureStation.regionTitle = departureStation.regionTitle
        selectedDepartureStation.stationId = departureStation.stationId
        selectedDepartureStation.stationTitle = departureStation.stationTitle
        
        selectedDepartureStationPoint.latitude = departureStation.point?.latitude
        selectedDepartureStationPoint.longitude = departureStation.point?.longitude
        
        selectedDepartureStation.point = selectedDepartureStationPoint
        
        do {
            try managedObjectContext.save()
            navigationController?.popToRootViewControllerAnimated(true)
        } catch let error as NSError {
            print(error.localizedDescription, error.userInfo)
            let alertController = UIAlertController(title: nil, message: "Произошла ошибка, сохранение не возможно", preferredStyle: .Alert)
            alertController.addAction(UIAlertAction(title: "Ок", style: .Cancel, handler: { (alert) -> Void in
                self.navigationController?.popToRootViewControllerAnimated(true)
            }))
            presentViewController(alertController, animated: true, completion: nil)
        }
    }
    
    private func removeDepartureStation() {
        fetchedResultController = NSFetchedResultsController(fetchRequest: fetchDepartureRequest(), managedObjectContext: managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultController.delegate = self
        do {
            try fetchedResultController.performFetch()
        } catch let error as NSError {
            print(error.localizedDescription, error.userInfo)
        }
        guard let selectedStation = fetchedResultController.fetchedObjects?.first as? SelectedDepartureStation else { return }
        print(fetchedResultController.fetchedObjects?.count)
        managedObjectContext.deleteObject(selectedStation as NSManagedObject)
        do {
            try managedObjectContext.save()
        } catch let error as NSError {
            print(error.localizedDescription, error.userInfo)
        }
    }
    
    private func fetchDepartureRequest() -> NSFetchRequest {
        let fetchRequest = NSFetchRequest(entityName: "SelectedDepartureStation")
        let sortDescriptor = NSSortDescriptor(key: "stationTitle", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        return fetchRequest
    }
    
    
    // host
    private func saveArrivalStation() {
        removeArrivalStation()
        let selectedHostStation = NSEntityDescription.insertNewObjectForEntityForName("SelectedArrivalStation", inManagedObjectContext: managedObjectContext) as! SelectedArrivalStation
        let selectedHostStationPoint = NSEntityDescription.insertNewObjectForEntityForName("SelectedArrivalStationPoint", inManagedObjectContext: managedObjectContext) as! SelectedArrivalStationPoint
        selectedHostStation.cityId = arrivalStation.cityId
        selectedHostStation.cityTitle = arrivalStation.cityTitle
        selectedHostStation.countryTitle = arrivalStation.countryTitle
        selectedHostStation.districtTitle = arrivalStation.districtTitle
        selectedHostStation.regionTitle = arrivalStation.regionTitle
        selectedHostStation.stationId = arrivalStation.stationId
        selectedHostStation.stationTitle = arrivalStation.stationTitle
        
        selectedHostStationPoint.latitude = arrivalStation.point?.latitude
        selectedHostStationPoint.longitude = arrivalStation.point?.longitude
        
        selectedHostStation.point = selectedHostStationPoint
        
        do {
            try managedObjectContext.save()
            navigationController?.popToRootViewControllerAnimated(true)
        } catch let error as NSError {
            print(error.localizedDescription, error.userInfo)
            let alertController = UIAlertController(title: nil, message: "Произошла ошибка, сохранение не возможно", preferredStyle: .Alert)
            alertController.addAction(UIAlertAction(title: "Ок", style: .Cancel, handler: { (alert) -> Void in
                self.navigationController?.popToRootViewControllerAnimated(true)
            }))
            presentViewController(alertController, animated: true, completion: nil)
        }
    }
    
    private func removeArrivalStation() {
        fetchedResultController = NSFetchedResultsController(fetchRequest: fetchArrivalRequest(), managedObjectContext: managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultController.delegate = self
        
        do {
            try fetchedResultController.performFetch()
        } catch let error as NSError {
            print(error.localizedDescription, error.userInfo)
        }
        guard let selectedStation = fetchedResultController.fetchedObjects?.first as? SelectedArrivalStation else { return }
        managedObjectContext.deleteObject(selectedStation as NSManagedObject)
        do {
            try managedObjectContext.save()
        } catch let error as NSError {
            print(error.localizedDescription, error.userInfo)
        }
    }
    
    private func fetchArrivalRequest() -> NSFetchRequest {
        let fetchRequest = NSFetchRequest(entityName: "SelectedArrivalStation")
        let sortDescriptor = NSSortDescriptor(key: "stationTitle", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        return fetchRequest
    }
    
}

    
    
    
    


