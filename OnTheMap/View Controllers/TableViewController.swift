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
    var locations: [StudentInformation]?

    override func viewDidLoad() {
        super.viewDidLoad()
        locations = ParseClient.sharedInstance().locations
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let locations = locations {
            return locations.count
        }
        else {
            return 0
        }
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(CellReuseId, forIndexPath: indexPath)

        if let locations = locations {
            let loc = locations[indexPath.row]
            cell.textLabel?.text = "\(loc.firstName!) \(loc.lastName!)"
            cell.detailTextLabel?.text = "\(loc.mediaUrl!)"
            cell.imageView?.image = UIImage(named: "pin")
        }

        return cell
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if let locations = locations {
            let location = locations[indexPath.row]
            if let mediaUrlString = location.mediaUrl, url = NSURL(string: mediaUrlString) {
                UIApplication.sharedApplication().openURL(url)
            }
        }
    }

    // MARK: - LocationCollectionViewController

    func refreshLocations(completion: (() -> Void)?) {
        locations = ParseClient.sharedInstance().locations
        dispatch_async(dispatch_get_main_queue()) { () -> Void in
            self.tableView.reloadData()
        }

        if let completion = completion {
            completion()
        }
    }

    func locationWasAdded(location: StudentInformation) {
        refreshLocations(nil)
        focusLocation(location)
    }

    // MARK: - Misc


    func moveToRow(rowNumber: Int) {
        dispatch_async(dispatch_get_main_queue()) { () -> Void in
            self.tableView.selectRowAtIndexPath(NSIndexPath(forRow: rowNumber, inSection: 0), animated: true, scrollPosition: .Middle)
        }
    }

    func focusLocation(location: StudentInformation) {
        if let uniqueKey = location.uniqueKey, locations = locations {
            if let index = locations.indexOf({ (location: StudentInformation) -> Bool in
                return location.uniqueKey == uniqueKey
            }) {
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.moveToRow(index)
                })
            }
        }
    }

}
