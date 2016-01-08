//
//  LoginViewController.swift
//  OnTheMap
//
//  Created by Bill Dawson on 11/10/15.
//  Copyright © 2015 Bill Dawson. All rights reserved.
//

import UIKit
import FBSDKLoginKit

class LoginViewController: UIViewController, UITextFieldDelegate, FBSDKLoginButtonDelegate {

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
    @IBOutlet weak var signupButton: UIButton!
    @IBOutlet weak var facebookButton: FBSDKLoginButton!

    // MARK: - UIViewController

    override func viewDidLoad() {
        tapRecognizer = UITapGestureRecognizer(target: self, action: "tapWasRecognized:")
        tapRecognizer!.cancelsTouchesInView = false
        view.addGestureRecognizer(tapRecognizer!)
        passwordField.delegate = self
        facebookButton.delegate = self
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

    // MARK: - Login

    func showLoginAlert(message: String) {
        dispatch_async(dispatch_get_main_queue()) { () -> Void in
            self.loginButton.enabled = true
            let controller = UIAlertController(title: "Login Failure", message: message, preferredStyle: UIAlertControllerStyle.Alert)
            let action = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil)
            controller.addAction(action)
            self.presentViewController(controller, animated: true, completion: nil)
        }
    }

    func enableLoginButton(enable: Bool) {
        dispatch_async(dispatch_get_main_queue()) { () -> Void in
            self.loginButton.enabled = enable
            self.facebookButton.enabled = enable
        }
    }

    func performLogin(facebookToken: String?) {
        enableLoginButton(false)

        let callback = { (success: Bool, errorString: String?) -> Void in
            self.enableLoginButton(true)
            guard success else {
                self.enableLoginButton(true)
                if let errorString = errorString {
                    print(errorString)
                    self.showLoginAlert(errorString)
                }
                else {
                    print("An unknown error occurred while attempting to authenticate with Udacity")
                    self.showLoginAlert(UdacityClient.ErrorMessages.Connection)
                }
                return
            }

            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.performSegueWithIdentifier(self.tabBarSegueId, sender: self)
            })

        }

        let client = UdacityClient.sharedInstance()

        if let facebookToken = facebookToken {
            client.authenticateFB(facebookToken, completionHandler: callback)
        }
        else {
            client.authenticate(emailField.text!, password: passwordField.text!, completionHandler: callback)
        }

    }

    // MARK: - Actions

    @IBAction func loginTouchUp(sender: AnyObject) {
        performLogin(nil)
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

    // MARK: - FBSDKLoginButtonDelegate

    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        if error != nil {
            showLoginAlert(error.localizedDescription)
            return
        }

        if result == nil {
            showLoginAlert(UdacityClient.ErrorMessages.Connection)
            return
        }

        if result.isCancelled {
            return
        }

        self.performLogin(result.token.tokenString)
    }
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        UdacityClient.sharedInstance().deleteSession()
    }
    
}
