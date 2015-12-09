//
//  UdacityConstants.swift
//  OnTheMap
//
//  Created by Bill Dawson on 11/10/15.
//  Copyright © 2015 Bill Dawson. All rights reserved.
//

import Foundation

extension UdacityClient {

    struct Constants {
        static let APIBaseUrl = "https://www.udacity.com/api/"
    }

    struct ErrorMessages {
        static let Connection = "Connection to Udacity failed. Please be sure you are connected to the Internet and try again."
        static let Credentials = "Invalid email address or password."
    }

    struct APIEndpoints {
        static let Session = "session"
    }

    struct JSONKeys {
        static let Udacity = "udacity"
        static let Username = "username"
        static let Password = "password"
        static let Account = "account"
        static let AccountKey = "key"
        static let Session = "session"
        static let SessionId = "id"
    }
}