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

    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
//        self.refreshLocations(nil)
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        refreshLocations(nil)
    }


    // MARK: Instance

    func makePin(location: StudentLocation) -> MKPointAnnotation? {
        guard let coord = location.coordinate2D() else {
            return nil
        }
        let pin = MKPointAnnotation()
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
        Alert.sharedInstance().ok(error, owner: self, completion: nil)
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

    func locationWasAdded(location: StudentLocation) {
        dispatch_async(dispatch_get_main_queue()) { () -> Void in
            self.refreshLocations({ () -> Void in
                if let coord = location.coordinate2D() {
                    self.mapView.setCenterCoordinate(coord, animated: true)
                }
            })
        }
    }

}
