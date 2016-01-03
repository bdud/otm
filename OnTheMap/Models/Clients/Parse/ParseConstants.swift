//
//  ParseConstants.swift
//  OnTheMap
//
//  Created by Bill Dawson on 12/14/15.
//  Copyright © 2015 Bill Dawson. All rights reserved.
//

import Foundation

extension ParseClient {

    struct Constants {
        static let AppId = "QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr"
        static let RESTApiKey = "QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY"
        static let ApiUrl = "https://api.parse.com/1/classes/StudentLocation"
        static let ResultFieldKey = "results"
    }

    struct HeaderFieldNames {
        static let AppId = "X-Parse-Application-Id"
        static let RESTApiKey = "X-Parse-REST-API-Key"
    }

    struct StudentLocationKeys {
        static let ObjectId = "objectId"
        static let UniqueKey = "uniqueKey"
        static let FirstName = "firstName"
        static let LastName = "lastName"
        static let MapString = "mapString"
        static let MediaUrl = "mediaURL"
        static let Latitude = "latitude"
        static let Longitude = "longitude"
    }

    struct Errors {
        static let Network = "Network Error. Please check your network connection and try again."
        static let General = "Unable to complete operation."
    }
}