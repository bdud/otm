//
//  LoginViewController.swift
//  OnTheMap
//
//  Created by Bill Dawson on 11/10/15.
//  Copyright © 2015 Bill Dawson. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    let tabBarSegueId = "ToTabBar"

    // MARK: - Outlets

    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!


    // MARK: - Overrides

    override func viewDidAppear(animated: Bool) {
        let config = UdacityConfig.sharedUdacityConfig()
        if let _ = config.SessionId, sessionExpiration = config.SessionExpiration {
            if sessionExpiration.laterDate(NSDate()).isEqualToDate(sessionExpiration) {
                performSegueWithIdentifier(tabBarSegueId, sender: self)
                return
            }
        }
    }

    // MARK: - Other

    func showLoginAlert(message: String) {
        dispatch_async(dispatch_get_main_queue()) { () -> Void in
            let controller = UIAlertController(title: "Login Failure", message: message, preferredStyle: UIAlertControllerStyle.Alert)
            let action = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil)
            controller.addAction(action)
            self.presentViewController(controller, animated: true, completion: nil)
        }
    }

    // MARK: - Actions

    @IBAction func loginTouchUp(sender: AnyObject) {
        UdacityClient.sharedInstance().authenticate(emailField.text!, password: passwordField.text!) { (success, errorString) -> Void in
            if (success) {
                UdacityClient.sharedInstance().fetchUserInfo({ (success, errorString) -> Void in
                    guard success else {
                        if let errorString = errorString {
                            print(errorString)
                            self.showLoginAlert(errorString)
                        }
                        else {
                            print("An unknown error occurred while attempting to fetch Udacity user info")
                            self.showLoginAlert(UdacityClient.ErrorMessages.Connection)
                        }
                        return
                    }
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        self.performSegueWithIdentifier(self.tabBarSegueId, sender: self)
                    })

                })
            }
            else if let errorString = errorString {
                print(errorString)
                self.showLoginAlert(errorString)
            }
            else {
                print("An unknown error occurred while attempting to authenticate with Udacity")
                self.showLoginAlert(UdacityClient.ErrorMessages.Connection)
            }
        }
    }
}
