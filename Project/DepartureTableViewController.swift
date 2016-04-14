//
//  DepartureTableViewController.swift
//  Project
//
//  Created by VLAD on 4/13/16.
//  Copyright © 2016 Vlad. All rights reserved.
//

import UIKit
import Foundation
import CoreData


class DepartureTableViewController: UITableViewController, NSFetchedResultsControllerDelegate {
    
    
    private var fetchedResultController: NSFetchedResultsController!
    private let appDelegate = (UIApplication.sharedApplication().delegate as! AppDelegate)
    private var managedObjectContext: NSManagedObjectContext! {
        return appDelegate.managedObjectContext
    }
    
    private var cities = [DepartureCity]()
    private var searchController = UISearchController()
    private var searchResults: [DepartureStation]? = nil
    private var searchPredicate: NSPredicate!
    

    // MARK: - Lifycycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.definesPresentationContext = true
        setSearchController()
        setFetchedResultController()
    }
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        self.definesPresentationContext = true
        setUISetting()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit {
        searchResults?.removeAll()
    }
    
    
    // MARK: - UITableViewDataSource
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if !searchController.active {
            return cities.count ?? 0
        } else {
            return 1 ?? 0
        }
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if !searchController.active {
            return cities[section].stations!.count ?? 0
        } else {
            return searchResults?.count ?? 0
        }
    }

    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if !searchController.active {
            if let cityTitle = cities[section].cityTitle, let countryTitle = cities[section].countryTitle {
                return "\(cityTitle) \(countryTitle)"
            } else {
                return cities[section].cityTitle ?? ""
            }
        } else {
            return nil
        }
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("departureCell", forIndexPath: indexPath) as! DepartureTableViewCell
        if !searchController.active {
            let stations = Array(cities[indexPath.section].stations!) as! [DepartureStation]
            let station = stations[indexPath.row]
            // Configure the cell...
            cell.stationLabel.text = station.stationTitle
            cell.countryLabel.text = station.countryTitle
            cell.cityLabel.text = station.cityTitle
        } else {
            let station = searchResults![indexPath.row]
            cell.stationLabel.text = station.stationTitle
            cell.countryLabel.text = station.countryTitle
            cell.cityLabel.text = station.cityTitle
        }
        return cell
    }
    
    
    // MARK: - functions
    private func setUISetting() {
        navigationController?.navigationBarHidden = false
        tabBarController?.tabBar.hidden = true
    }
    
    private func setFetchedResultController() {
        fetchedResultController = NSFetchedResultsController(fetchRequest: cityFetchResult(), managedObjectContext: managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultController.delegate = self
        do {
            try fetchedResultController.performFetch()
        } catch let error as NSError {
            print(error.localizedDescription, error.userInfo)
        }
        cities = fetchedResultController.fetchedObjects as! [DepartureCity]
        var numberOfcityStations = 0
        for city in cities {
            numberOfcityStations += (city.stations?.count)!
        }
        print("numberOfcityStations", numberOfcityStations)
    }
    
    private func fetchStations() {
        fetchedResultController = NSFetchedResultsController(fetchRequest: stationFetchResult(), managedObjectContext: managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultController.delegate = self
        do {
            try fetchedResultController.performFetch()
        } catch let error as NSError {
            print(error.localizedDescription, error.userInfo)
        }
    }

    // MARK: - fetchRequests
    
    private func cityFetchResult() -> NSFetchRequest {
        let fetchRequest = NSFetchRequest(entityName: "DepartureCity")
        let sortDescriptor = NSSortDescriptor(key: "cityTitle", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        return fetchRequest
    }
    
    private func stationFetchResult() -> NSFetchRequest {
        let fetchRequest = NSFetchRequest(entityName: "DepartureStation")
        let sortDescriptor = NSSortDescriptor(key: "stationTitle", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        return fetchRequest
    }
}

// MARK: - delegate functions

extension DepartureTableViewController {
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let infoController = UIUtilits.mainStoryboard.instantiateViewControllerWithIdentifier("InfoStationViewController") as! InfoStationViewController
        if !searchController.active {
            guard let stations = Array(cities[indexPath.section].stations!) as? [DepartureStation] else { return }
            let currentStation = stations[indexPath.row]
            print(currentStation.stationTitle, currentStation.cityTitle, currentStation.countryTitle)
            infoController.departureStation = currentStation
        } else {
            guard let currentStation = searchResults?[indexPath.row] else { return }
            print(currentStation.stationTitle, currentStation.cityTitle, currentStation.countryTitle)
            infoController.departureStation = currentStation
        }
        showViewController(infoController, sender: self)
        
    }
    
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        tableView.endUpdates()
    }
    
    func controllerWillChangeContent(controller: NSFetchedResultsController) {
        tableView.beginUpdates()
    }
}



// MARK: - searchController and searchBar and their functions

extension DepartureTableViewController: UISearchControllerDelegate, UISearchBarDelegate, UISearchResultsUpdating  {
    
    private func setSearchController() {
        searchController = UISearchController(searchResultsController: nil)
        searchController.delegate = self
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchResultsUpdater = self
        searchController.searchBar.sizeToFit()
        searchController.searchBar.delegate = self
        tableView.tableHeaderView = searchController.searchBar
    }
    
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        fetchStations()
        searchResults?.removeAll()
        guard let searchText = searchController.searchBar.text else { return }
        searchPredicate = NSPredicate(format: "stationTitle contains [cd] %@ OR cityTitle contains [cd] %@", searchText, searchText)
        searchResults = fetchedResultController.fetchedObjects?.filter() {
            return searchPredicate.evaluateWithObject($0)
            } as? [DepartureStation]
        tableView.reloadData()
    }
    
    func didPresentSearchController(searchController: UISearchController) {
        tableView.reloadData()
    }
    
    func didDismissSearchController(searchController: UISearchController) {
        searchPredicate = nil
        searchResults?.removeAll()
        tableView.reloadData()
    }
    
    func searchBar(searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        updateSearchResultsForSearchController(searchController)
    }
}




