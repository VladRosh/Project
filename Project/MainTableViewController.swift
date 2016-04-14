//
//  MainTableViewController.swift
//  Project
//
//  Created by VLAD on 4/13/16.
//  Copyright © 2016 Vlad. All rights reserved.
//

import UIKit
import Foundation
import CoreData


class MainTableViewController: UITableViewController, NSFetchedResultsControllerDelegate {
    
    var dataManager: DataManager!
    private var selectedFetchedController: NSFetchedResultsController!
    
    private let appDelegate = (UIApplication.sharedApplication().delegate as! AppDelegate)
    private var managedObjectContext: NSManagedObjectContext {
        return appDelegate.managedObjectContext
    }
    
    
    
     // MARK: - IBOutlet
    
    
    @IBOutlet weak var mainDepartureCell: MainDepartureTableViewCell!
    @IBOutlet weak var mainArrivalCell: MainArrivalTableViewCell!
    @IBOutlet weak var mainDateCell: MainDateTableViewCell!
    
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.definesPresentationContext = true
        dataManager = DataManager()
        dataManager.saveData(view)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        setUISetting()
        updateData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    private func tableViewOpensController(index: NSIndexPath) {
        switch index {
        case NSIndexPath(forRow: 0, inSection: 0):
            performSegueWithIdentifier("showDeparture", sender: self)
        case NSIndexPath(forRow: 0, inSection: 1):
            performSegueWithIdentifier("showArrival", sender: self)
        case NSIndexPath(forRow: 0, inSection: 2):
            performSegueWithIdentifier("showDate", sender: self)
        default: break
        }
    }
    
    // MARK: - UI functions
    private func setUISetting() {
        navigationController?.navigationBarHidden = true
        tabBarController?.tabBar.hidden = false
    }
    
    // MARK: - getting data of selected stations
    private func updateData() {
        selectedFetchedController = NSFetchedResultsController(fetchRequest: departureFetchRequest(), managedObjectContext: managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
        selectedFetchedController.delegate = self
        do {
            try selectedFetchedController.performFetch()
        } catch let error as NSError {
            print(error.localizedDescription, error.localizedDescription)
        }
        
        if let departureStation = selectedFetchedController.fetchedObjects?.first as? SelectedDepartureStation {
            guard let stationTitle = departureStation.stationTitle else {
                mainDepartureCell.stationLabel.text = "Откуда?"
                return
            }
            mainDepartureCell.stationLabel.text = stationTitle
        } else {
            mainDepartureCell.stationLabel.text = "Откуда?"
        }
        
        // arrival
        selectedFetchedController = NSFetchedResultsController(fetchRequest: arrivalFetchRequest(), managedObjectContext: managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
        selectedFetchedController.delegate = self
        do {
            try selectedFetchedController.performFetch()
        } catch let error as NSError {
            print(error.localizedDescription, error.userInfo)
        }
        
        if let hostStation = selectedFetchedController.fetchedObjects?.first as? SelectedArrivalStation {
            guard let stationTitle = hostStation.stationTitle else {
                mainArrivalCell.stationLabel.text = "Куда?"
                return
            }
            mainArrivalCell.stationLabel.text = stationTitle
        } else {
            mainArrivalCell.stationLabel.text = "Куда?"
        }
        
        // date
        
        selectedFetchedController = NSFetchedResultsController(fetchRequest: dateFetchRequest(), managedObjectContext: managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
        selectedFetchedController.delegate = self
        do {
            try selectedFetchedController.performFetch()
        } catch let error as NSError {
            print(error.localizedDescription, error.userInfo)
        }
        
        if let dateEntity = selectedFetchedController.fetchedObjects?.first as? SelectedDate {
            guard let date = dateEntity.date else {
                mainDateCell.dateLabel.text = "Дата отправления"
                return
            }
            mainDateCell.dateLabel.text = transformDate(date)
        } else {
            mainDateCell.dateLabel.text = "Дата отправления"
        }
    }
    
    // MARK: - fetche requests
    
    private func departureFetchRequest() -> NSFetchRequest {
        let fetchRequest = NSFetchRequest(entityName: "SelectedDepartureStation")
        let sortDescriptor = NSSortDescriptor(key: "stationTitle", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        return fetchRequest
    }
    
    private func arrivalFetchRequest() -> NSFetchRequest {
        let fetchRequest = NSFetchRequest(entityName: "SelectedArrivalStation")
        let sortDescriptor = NSSortDescriptor(key: "stationTitle", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        return fetchRequest
    }
    
    private func dateFetchRequest() -> NSFetchRequest {
        let fetchRequest = NSFetchRequest(entityName: "SelectedDate")
        let sortDescriptor = NSSortDescriptor(key: "date", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        return fetchRequest
    }
    
    // MARK: - functions
    private func transformDate(date: NSDate) -> String {
        let dateFormatter = NSDateFormatter()
        dateFormatter.timeStyle = .ShortStyle
        dateFormatter.dateStyle = .MediumStyle
        dateFormatter.timeZone = NSTimeZone.localTimeZone()
        let dateString = dateFormatter.stringFromDate(date)
        return dateString
    }
}
// MARK: - UITableDelegate

extension MainTableViewController {
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableViewOpensController(indexPath)
    }
}
    

    
    


