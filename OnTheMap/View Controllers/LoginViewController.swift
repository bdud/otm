//
//  LoginViewController.swift
//  OnTheMap
//
//  Created by Bill Dawson on 11/10/15.
//  Copyright © 2015 Bill Dawson. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    // MARK: - Outlets

    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!


    // MARK: - Overrides

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */

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
                self.performSegueWithIdentifier("ToTabBar", sender: self)
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
