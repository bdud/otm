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
        static let Connection = ClientConvenience.Errors.Connection
        static let Credentials = "Invalid email address or password."
    }

    struct APIEndpoints {
        static let Session = "session"
        static let User = "users/[user]"
    }

    struct JSONKeys {
        static let Udacity = "udacity"
        static let Username = "username"
        static let Password = "password"
        static let Account = "account"
        static let AccountKey = "key"
        static let Session = "session"
        static let SessionId = "id"
        static let SessionExpiration = "expiration"
        static let User = "user"
        static let FirstName = "first_name"
        static let LastName = "last_name"
        static let Facebook = "facebook_mobile"
        static let AccessToken = "access_token"
    }
}