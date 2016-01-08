//
//  TabBarController.swift
//  OnTheMap
//
//  Created by Bill Dawson on 12/10/15.
//  Copyright © 2015 Bill Dawson. All rights reserved.
//

import UIKit
import FBSDKLoginKit

class TabBarController: UITabBarController, AddLocationViewControllerDelegate {
    let addLocationStoryboardID = "addLocationView"

    // MARK: Outlets

    @IBOutlet weak var refreshButton: UIBarButtonItem!
    @IBOutlet weak var trashButton: UIBarButtonItem!
    @IBOutlet weak var addButton: UIBarButtonItem!

    // MARK: Actions

    @IBAction func logoutButtonTap(sender: AnyObject) {
        
        UdacityClient.sharedInstance().deleteSession()
        FBSDKAccessToken.setCurrentAccessToken(nil)
        dismissViewControllerAnimated(true, completion: nil)
    }

    @IBAction func addButtonTap(sender: AnyObject) {
        if let accountKey = UdacityConfig.sharedUdacityConfig().AccountKey {
            if ParseClient.sharedInstance().locationExistsWithUniqueKey(accountKey) {
                let avc = UIAlertController(title: nil, message: "You Have Already Posted a Student Location. Would You Like to Overwrite Your Current Location?", preferredStyle: .Alert)
                let over = UIAlertAction(title: "Overwrite", style: .Destructive, handler: { (action) -> Void in
                    self.showAddLocationViewController()
                })
                let cancel = UIAlertAction(title: "Cancel", style: .Default, handler: nil)
                avc.addAction(over)
                avc.addAction(cancel)
                self.presentViewController(avc, animated: true, completion: nil)
            }
            else {
                self.showAddLocationViewController()
            }
        }
        else {
            self.showAddLocationViewController()
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


    @IBAction func deleteLocationTap(sender: AnyObject) {
        if let id = UdacityConfig.sharedUdacityConfig().AccountKey {
            let parse = ParseClient.sharedInstance()
            if !parse.locationExistsWithUniqueKey(id) {
                return
            }
            ParseClient.sharedInstance().deleteLocationWithUniqueId(id, completionHandler: { (success, errorMessage) -> Void in
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.refreshTap(self)
                })
            })
        }
    }

    // MARK: - UIViewController
    override func viewDidLoad() {
        guard let _ = UdacityConfig.sharedUdacityConfig().AccountKey else {
            // One time user info fetch
            fetchUserInfo()
            return
        }
    }

    // MARK: AddLocationViewControllerDelegate

    func createdLocation(location: StudentLocation) {
        let parse = ParseClient.sharedInstance()

        parse.addLocation(location) { (success, errorString) -> Void in
            guard success else {
                guard let msg = errorString else {
                    self.showError(ParseClient.Errors.General)
                    return
                }
                self.showError(msg)
                return
            }

            for controller in self.viewControllers! {
                if let controller = controller as? LocationCollectionViewController {
                    controller.locationWasAdded(location)
                }

            }
        }
    }

    // MARK: Miscellaneous

    func showAddLocationViewController() {
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
    
    func showError(message: String) {
        Alert.sharedInstance().ok(message, owner: self, completion: nil)
    }

    func fetchUserInfo() {
        addButton.enabled = false
        UdacityClient.sharedInstance().fetchUserInfo({ (success, errorString) -> Void in
            guard success else {
                if let errorString = errorString {
                    print(errorString)
                    self.showError(errorString)
                }
                else {
                    print("An unknown error occurred while attempting to fetch Udacity user info")
                    self.showError(UdacityClient.ErrorMessages.Connection)
                }
                return
            }
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.addButton.enabled = true
            })
        })

    }

}
