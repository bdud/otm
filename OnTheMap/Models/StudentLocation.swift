//
//  StudentLocation.swift
//  OnTheMap
//
//  Created by Bill Dawson on 12/14/15.
//  Copyright © 2015 Bill Dawson. All rights reserved.
//

import Foundation

struct StudentLocation {
    var uniqueKey: Int?
    var firstName: String?
    var lastName: String?
    var mapString: String?
    var mediaUrl: String?
    var latitude: Double?
    var longitude: Double?

    init() {
        
    }
    init(fromDictionary dict: [String: AnyObject]) {
        self.uniqueKey = dict[ParseClient.StudentLocationKeys.UniqueKey] as? Int
        self.firstName = dict[ParseClient.StudentLocationKeys.FirstName] as? String
        self.lastName = dict[ParseClient.StudentLocationKeys.LastName] as? String
        self.mapString = dict[ParseClient.StudentLocationKeys.MapString] as? String
        self.mediaUrl = dict[ParseClient.StudentLocationKeys.MediaUrl] as? String
        self.latitude = dict[ParseClient.StudentLocationKeys.Latitude] as? Double
        self.longitude = dict[ParseClient.StudentLocationKeys.Longitude] as? Double
    }

    func dictionary() -> [String: AnyObject] {
        var dict = [String: AnyObject]()
        if let uniqueKey = self.uniqueKey {
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

        return dict

    }
    
}