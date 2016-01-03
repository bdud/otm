//
//  AddLocationViewController.swift
//  OnTheMap
//
//  Created by Bill Dawson on 12/16/15.
//  Copyright © 2015 Bill Dawson. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

protocol AddLocationViewControllerDelegate {
    func createdLocation(location: StudentLocation)
}

class AddLocationViewController: UIViewController, UITextFieldDelegate {

    var delegate: AddLocationViewControllerDelegate?

    let LocationPlaceholderText = "Enter Your Location Here"
    let LinkPlaceholderText = "Enter a Link to Share Here"
    let PlaceholderForegroundColor = UIColor(red:0.6, green:0.68, blue:0.79, alpha:1)

    // MARK: Outlets
    @IBOutlet weak var topLabel: UILabel!
    @IBOutlet weak var findButton: UIButton!
    @IBOutlet weak var locationTextField: VNudgeTextField!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var bottomContainer: UIView!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var linkTextField: VNudgeTextField!

    // MARK: Actions

    @IBAction func cancelTap(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }

    @IBAction func findOnMapTap(sender: AnyObject) {
        let text = locationTextField.text!
        if text.characters.count == 0 || text == "Enter Your Location Here" {
            showErrorMessage("You must enter a location")
            return
        }
        findButton.enabled = false
        locationTextField.resignFirstResponder()
        locationTextField.enabled = false

        findEnteredLocation { (success, placemark) -> Void in
            guard success, let coordinate = placemark?.location?.coordinate else {
                self.showErrorMessage("No matching location was found.")
                dispatch_async(dispatch_get_main_queue()) {
                    self.findButton.enabled = true
                    self.locationTextField.enabled = true
                    self.locationTextField.becomeFirstResponder()
                }
                return
            }

            self.linkTextField.becomeFirstResponder()
            dispatch_async(dispatch_get_main_queue()) {
                self.showMapWithPinAtCoordinate(coordinate)
                self.findButton.enabled = true
            }
        }
    }

    @IBAction func submitTap(sender: AnyObject) {
        guard let linkText = linkTextField.text where linkText.characters.count > 0 else {
            showErrorMessage("Please enter a link.")
            return
        }
        linkTextField.resignFirstResponder()
        linkTextField.enabled = false

        var location = StudentLocation()
        let config = UdacityConfig.sharedUdacityConfig()
        location.firstName = config.FirstName
        location.lastName = config.LastName
        location.uniqueKey = config.AccountKey
        location.mapString = locationTextField.text
        location.mediaUrl = linkText
        location.latitude = mapView.annotations[0].coordinate.latitude
        location.longitude = mapView.annotations[0].coordinate.longitude
        if let delegate = delegate {
            delegate.createdLocation(location)
        }
        dismissViewControllerAnimated(true, completion: nil)
    }

    // MARK: UIViewController

    override func viewDidLoad() {
        locationTextField.delegate = self
        linkTextField.delegate = self
    }

    override func viewWillAppear(animated: Bool) {
        styleControls()
        locationTextField.becomeFirstResponder()
    }

    // MARK: UITextFieldDelegate

    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }


    // MARK: Instance

    func styleControls() {
        findButton.layer.cornerRadius = 10.0
        findButton.clipsToBounds = true

        submitButton.layer.cornerRadius = 10.0
        submitButton.clipsToBounds = true

        topLabel.numberOfLines = 0
        topLabel.lineBreakMode = NSLineBreakMode.ByWordWrapping

        let lighterLabelColor = UIColor(red:0.47, green:0.51, blue:0.53, alpha:1)
        let boldFont = UIFont.boldSystemFontOfSize(topLabel.font.pointSize)
        let locationLabelAttrString = NSMutableAttributedString(string: "Where are you\n", attributes: [NSForegroundColorAttributeName: lighterLabelColor])
        locationLabelAttrString.appendAttributedString(NSAttributedString(string: "studying", attributes: [NSForegroundColorAttributeName: UIColor(red:0.15, green:0.18, blue:0.23, alpha:1), NSFontAttributeName: boldFont]))
        locationLabelAttrString.appendAttributedString(NSAttributedString(string: "\ntoday?", attributes: [NSForegroundColorAttributeName: lighterLabelColor]))
        topLabel.attributedText = locationLabelAttrString
        locationTextField.nudgeFactor = 0.2
        linkTextField.nudgeFactor = 0.45

        locationTextField.attributedPlaceholder = NSAttributedString(string: LocationPlaceholderText, attributes: [NSForegroundColorAttributeName: PlaceholderForegroundColor])
        linkTextField.attributedPlaceholder = NSAttributedString(string: LinkPlaceholderText, attributes: [NSForegroundColorAttributeName: PlaceholderForegroundColor])

    }


    func findEnteredLocation(completion: (success: Bool, placemark: CLPlacemark?) -> Void) {
        let geocoder = CLGeocoder()

        geocoder.geocodeAddressString(locationTextField.text!) { (placemarks: [CLPlacemark]?, error: NSError?) -> Void in
            guard error == nil else {
                print(error?.localizedDescription)
                completion(success: false, placemark: nil)
                return
            }

            guard let placemarks = placemarks else {
                print("No placemarks returned from geocode search")
                completion(success: false, placemark: nil)
                return
            }

            completion(success: true, placemark: placemarks[0])
        }

    }

    func showMapWithPinAtCoordinate(coordinate: CLLocationCoordinate2D) {
        mapView.alpha = 0.0
        submitButton.alpha = 0.0
        linkTextField.alpha = 0.0
        submitButton.hidden = false
        mapView.hidden = false
        linkTextField.hidden = false
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        mapView.addAnnotation(annotation)


        UIView.animateWithDuration(0.7, animations: { () -> Void in
            self.mapView.alpha = 1.0
            self.submitButton.alpha = 1.0
            self.linkTextField.alpha = 1.0
            self.locationTextField.alpha = 0.0
            self.topLabel.alpha = 0.0
            self.bottomContainer.alpha = 0.0

            }) { (completed: Bool) -> Void in

                self.mapView.alpha = 1.0
                self.mapView.alpha = 1.0
                self.linkTextField.alpha = 1.0
                self.locationTextField.hidden = true
                self.bottomContainer.hidden = true
                self.topLabel.hidden = true
                self.mapView.setCenterCoordinate(coordinate, animated: true)
        }
    }

    func showErrorMessage(message: String) {
        dispatch_async(dispatch_get_main_queue()) {
            let av = UIAlertController(title: "On The Map", message: message, preferredStyle: .Alert)
            let action = UIAlertAction(title: "OK", style: .Default, handler: nil)
            av.addAction(action)
            self.presentViewController(av, animated: true, completion: nil)
        }
    }
}
