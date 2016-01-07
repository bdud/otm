//
//  LoginViewController.swift
//  OnTheMap
//
//  Created by Bill Dawson on 11/10/15.
//  Copyright © 2015 Bill Dawson. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {

    let tabBarSegueId = "ToTabBar"
    let textFieldHNudge : CGFloat = 0.03
    let emailPlaceholderText = "Email"
    let passwordPlaceholderText = "Password"
    let signupUrl = NSURL(string: "https://www.udacity.com/account/auth#!/signup")!
    var tapRecognizer : UIGestureRecognizer?

    var keyboardUp : Bool = false


    // MARK: - Outlets

    @IBOutlet weak var emailField: NudgeTextField!
    @IBOutlet weak var passwordField: NudgeTextField!
    @IBOutlet weak var loginButton: UIButton!

    // MARK: - UIViewController

    override func viewDidLoad() {
        tapRecognizer = UITapGestureRecognizer(target: self, action: "tapWasRecognized:")
        tapRecognizer!.cancelsTouchesInView = false
        view.addGestureRecognizer(tapRecognizer!)
        passwordField.delegate = self
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        passwordField.text = ""
        styleControls()
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        if sessionAlreadyAvailable() {
            performSegueWithIdentifier(tabBarSegueId, sender: self)
        }
    }

    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
    }

    // MARK: - Other

    func showLoginAlert(message: String) {
        dispatch_async(dispatch_get_main_queue()) { () -> Void in
            self.loginButton.enabled = true
            let controller = UIAlertController(title: "Login Failure", message: message, preferredStyle: UIAlertControllerStyle.Alert)
            let action = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil)
            controller.addAction(action)
            self.presentViewController(controller, animated: true, completion: nil)
        }
    }

    func styleControls() {
        emailField.nudgeFactorH = textFieldHNudge
        passwordField.nudgeFactorH = textFieldHNudge
        emailField.attributedPlaceholder = NSAttributedString(string: emailPlaceholderText, attributes: [NSForegroundColorAttributeName: UIColor.whiteColor()])
        passwordField.attributedPlaceholder = NSAttributedString(string: passwordPlaceholderText, attributes: [NSForegroundColorAttributeName: UIColor.whiteColor()])

    }

    func sessionAlreadyAvailable() -> Bool {
        let config = UdacityConfig.sharedUdacityConfig()
        if let _ = config.SessionId, sessionExpiration = config.SessionExpiration {
            if sessionExpiration.laterDate(NSDate()).isEqualToDate(sessionExpiration) {
                return true
            }
        }

        return false
    }

    func tapWasRecognized(sender: UITapGestureRecognizer) {
        if sender.state == .Ended {
            view.endEditing(true)
        }
    }

    // MARK: - Actions

    @IBAction func loginTouchUp(sender: AnyObject) {
        loginButton.enabled = false
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
                        self.loginButton.enabled = true
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

    @IBAction func signupTouchUp(sender: AnyObject) {
        UIApplication.sharedApplication().openURL(signupUrl)
    }


    // MARK: - UITextFieldDelegate
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if textField == passwordField && textField.hasText() && emailField.hasText() {
            textField.resignFirstResponder()
            loginTouchUp(self)
            return false
        }
        return true
    }


}
