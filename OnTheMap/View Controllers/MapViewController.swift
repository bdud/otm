//
//  MapViewController.swift
//  OnTheMap
//
//  Created by Bill Dawson on 11/10/15.
//  Copyright © 2015 Bill Dawson. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate, LocationCollectionViewController {

    let annotationViewReuseId = "aview"

    // MARK: Outlets

    @IBOutlet weak var mapView: MKMapView!

    // MARK: UIViewController

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        mapView.delegate = self
        self.refreshLocations(nil)
    }


    // MARK: Instance

    func makePin(location: StudentLocation) -> MKPointAnnotation? {
        guard let latdbl = location.latitude else {
            return nil
        }

        let pin = MKPointAnnotation()
        let lat = CLLocationDegrees(latdbl)
        let lon = CLLocationDegrees(location.longitude!)
        let coord = CLLocationCoordinate2D(latitude: lat, longitude: lon)
        pin.coordinate = coord
        pin.title = "\(location.firstName!) \(location.lastName!)"
        pin.subtitle = "\(location.mediaUrl!)"
        return pin

    }

    func dropPins(locations: [StudentLocation]) {
        var annotations = [MKAnnotation]()
        for loc in locations {

            if let pin = makePin(loc) {
                annotations.append(pin)
            }

        }
        if annotations.count > 0 {
            mapView.addAnnotations(annotations)
        }
    }

    func showError(error: String) {
        let alertController = UIAlertController(title: "Error", message: error, preferredStyle: .Alert)
        let okButton = UIAlertAction(title: "OK", style: .Default, handler: nil)
        alertController.addAction(okButton)
        presentViewController(alertController, animated: true, completion: nil)
    }


    // MARK: MKMapViewDelegate

    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        var pinView = mapView.dequeueReusableAnnotationViewWithIdentifier(annotationViewReuseId) as? MKPinAnnotationView
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: annotationViewReuseId)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = UIColor.redColor()
            pinView!.rightCalloutAccessoryView = UIButton(type: .DetailDisclosure)
        }
        else {
            pinView?.annotation = annotation
        }

        return pinView
    }

    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if let subtitle = view.annotation?.subtitle {
            if let url = NSURL(string: subtitle!) {
                UIApplication.sharedApplication().openURL(url)
            }
        }
    }

    // MARK: LocationViewController

    func refreshLocations(completion: (() -> Void)?) {
        let existingAnnotations = mapView.annotations
        if (existingAnnotations.count > 0) {
            mapView.removeAnnotations(existingAnnotations)
        }

        ParseClient.sharedInstance().fetchLocations { (success, errorString, data) -> Void in
            dispatch_async(dispatch_get_main_queue()) {
                guard success else {
                    if let errorString = errorString {
                        self.showError(errorString)
                    }
                    else {
                        self.showError("An unknown error occurred")
                    }
                    if let completion = completion {
                        completion()
                    }
                    return
                }
                self.dropPins(data!)
                if let completion = completion {
                    completion()
                }
            }
        }
    }

    func addLocation(location: StudentLocation) {
        if let pin = makePin(location) {
            mapView.addAnnotation(pin)
        }
    }

}
