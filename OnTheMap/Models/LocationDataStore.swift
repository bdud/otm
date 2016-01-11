//
//  LocationDataStore.swift
//  OnTheMap
//
//  Created by Bill Dawson on 1/10/16.
//  Copyright © 2016 Bill Dawson. All rights reserved.
//

import UIKit

class LocationDataStore: NSObject {

    let genericErrorMessage = "An unexpected error occurred while communicating with the location data service."

    var cachedLocations: [StudentInformation]?
    let parse = ParseClient.sharedInstance()
    
    func queryLocations(completionHandler: (locations: [StudentInformation]?, errorMessage: String?) -> Void) {
        parse.fetchLocations { (success, errorString, data) -> Void in
            guard success else {
                completionHandler(locations: nil, errorMessage: errorString ?? self.genericErrorMessage)
                return
            }
            self.cachedLocations = data
            completionHandler(locations: data, errorMessage: errorString)
        }

    }

    func locationWithUniqueKey(uniqueKey: String, completionHandler: (location: StudentInformation?, errorMessage: String?) -> Void) {
        parse.fetchLocationWithUniqueKey(uniqueKey) { (location, errorMessage) -> Void in
            completionHandler(location: location, errorMessage: errorMessage)
        }

    }

    func saveLocation(location: StudentInformation, completionHandler: (errorMessage: String?) -> Void) {
        parse.addLocation(location) { (success, errorString) -> Void in
            guard success else {
                completionHandler(errorMessage: errorString ?? self.genericErrorMessage)
                return
            }
            completionHandler(errorMessage: errorString)
        }

    }

    // MARK: - Singleton

    class func sharedInstance() -> LocationDataStore {
        struct Singleton {
            static let instance = LocationDataStore()
        }
        return Singleton.instance
    }
}
