//
//  StudentInformation.swift
//  OnTheMap
//
//  Created by Bill Dawson on 12/14/15.
//  Copyright © 2015 Bill Dawson. All rights reserved.
//

import Foundation
import MapKit

struct StudentInformation {
    var uniqueKey: String?
    var firstName: String?
    var lastName: String?
    var mapString: String?
    var mediaUrl: String?
    var latitude: Double?
    var longitude: Double?
    var parseObjectId: String?

    init() {
        
    }
    
    init(fromDictionary dict: [String: AnyObject]) {
        self.uniqueKey = dict[ParseClient.StudentLocationKeys.UniqueKey] as? String
        self.firstName = dict[ParseClient.StudentLocationKeys.FirstName] as? String
        self.lastName = dict[ParseClient.StudentLocationKeys.LastName] as? String
        self.mapString = dict[ParseClient.StudentLocationKeys.MapString] as? String
        self.mediaUrl = dict[ParseClient.StudentLocationKeys.MediaUrl] as? String
        self.latitude = dict[ParseClient.StudentLocationKeys.Latitude] as? Double
        self.longitude = dict[ParseClient.StudentLocationKeys.Longitude] as? Double
        self.parseObjectId = dict[ParseClient.StudentLocationKeys.ObjectId] as? String
    }

    func dictionary() -> [String: AnyObject] {
        var dict = [String: AnyObject]()
        if let uniqueKey = uniqueKey {
            dict[ParseClient.StudentLocationKeys.UniqueKey] = uniqueKey
        }

        if let firstName = self.firstName {
            dict[ParseClient.StudentLocationKeys.FirstName] = firstName
        }

        if let lastName = self.lastName {
            dict[ParseClient.StudentLocationKeys.LastName] = lastName
        }

        if let mapString = self.mapString {
            dict[ParseClient.StudentLocationKeys.MapString] = mapString
        }

        if let mediaUrl = self.mediaUrl {
            dict[ParseClient.StudentLocationKeys.MediaUrl] = mediaUrl
        }

        if let latitude = self.latitude {
            dict[ParseClient.StudentLocationKeys.Latitude] = latitude
        }

        if let longitude = self.longitude {
            dict[ParseClient.StudentLocationKeys.Longitude] = longitude
        }

        if let objectId = self.parseObjectId {
            dict[ParseClient.StudentLocationKeys.ObjectId] = objectId
        }

        return dict

    }

    func jsonData() -> NSData? {
        guard let json = try? NSJSONSerialization.dataWithJSONObject(dictionary(), options: NSJSONWritingOptions(rawValue: 0)) else {
            print("Unable to convert Location dictionary data to JSON")
            return nil
        }
        return json

    }

    func coordinate2D() -> CLLocationCoordinate2D? {
        guard let latdbl = self.latitude else {
            return nil
        }

        guard let londbl = self.longitude else {
            return nil
        }

        let lat = CLLocationDegrees(latdbl)
        let lon = CLLocationDegrees(londbl)
        return CLLocationCoordinate2D(latitude: lat, longitude: lon)
    }
    
}