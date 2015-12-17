//
//  TabBarController.swift
//  OnTheMap
//
//  Created by Bill Dawson on 12/10/15.
//  Copyright © 2015 Bill Dawson. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController, AddLocationViewControllerDelegate {
    let addLocationStoryboardID = "addLocationView"

    // MARK: Outlets

    @IBOutlet weak var refreshButton: UIBarButtonItem!

    // MARK: Actions

    @IBAction func logoutButtonTap(sender: AnyObject) {
        UdacityConfig.sharedUdacityConfig().clear()
        dismissViewControllerAnimated(true, completion: nil)
    }

    @IBAction func addButtonTap(sender: AnyObject) {
        guard let addVCNav = storyboard?.instantiateViewControllerWithIdentifier(addLocationStoryboardID) as? UINavigationController else {
            print("Unable to create nav controller for AddLocationViewController")
            return
        }

        presentViewController(addVCNav, animated: true) {
            guard let addVC = addVCNav.topViewController as? AddLocationViewController else {
                print("Unable to create AddLocationViewController")
                return
            }
            addVC.delegate = self
        }

    }

    @IBAction func refreshTap(sender: AnyObject) {
        if let vc = selectedViewController as? LocationCollectionViewController {
            refreshButton.enabled = false
            vc.refreshLocations() {
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.refreshButton.enabled = true
                })
            }
        }
    }

    // MARK: AddLocationViewControllerDelegate
    func createdLocation(location: StudentLocation) {
        print("Got a location: \(location)")
        if let selectedController = selectedViewController as? LocationCollectionViewController  {
            selectedController.addLocation(location)
        }

    }
}
