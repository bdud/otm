//
//  TableViewController.swift
//  OnTheMap
//
//  Created by Bill Dawson on 11/10/15.
//  Copyright © 2015 Bill Dawson. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController, LocationCollectionViewController {

    let CellReuseId = "CellReuseId"
    let dataStore = LocationDataStore.sharedInstance()

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let locations = dataStore.cachedLocations {
            return locations.count
        }
        else {
            return 0
        }
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(CellReuseId, forIndexPath: indexPath)

        if let locations = dataStore.cachedLocations {
            let loc = locations[indexPath.row]
            cell.textLabel?.text = "\(loc.firstName!) \(loc.lastName!)"
            cell.detailTextLabel?.text = "\(loc.mediaUrl!)"
            cell.imageView?.image = UIImage(named: "pin")
        }

        return cell
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if let cell = tableView.cellForRowAtIndexPath(indexPath), text = cell.detailTextLabel?.text, url = NSURL(string: text) {
            UIApplication.sharedApplication().openURL(url)
        }
    }

    // MARK: - LocationCollectionViewController

    func refreshLocations(completion: (() -> Void)?) {
        dispatch_async(dispatch_get_main_queue()) { () -> Void in
            self.tableView.reloadData()
            completion?()
        }
    }

    func locationWasSaved(location: StudentInformation) {
        refreshLocations() {
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.focusLocation(location)
            })
        }
    }

    // MARK: - Misc

    func moveToRow(rowNumber: Int) {
        assert(NSThread.isMainThread())
            tableView.selectRowAtIndexPath(NSIndexPath(forRow: rowNumber, inSection: 0), animated: true, scrollPosition: .Middle)
    }

    func focusLocation(location: StudentInformation) {
        assert(NSThread.isMainThread())
        if let uniqueKey = location.uniqueKey, locations = dataStore.cachedLocations {
            if let index = locations.indexOf({ (location: StudentInformation) -> Bool in
                return location.uniqueKey == uniqueKey
            }) {
                self.moveToRow(index)
            }
        }
    }

}
