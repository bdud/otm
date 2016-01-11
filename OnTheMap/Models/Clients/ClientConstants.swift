//
//  ClientConstants.swift
//  OnTheMap
//
//  Created by Bill Dawson on 11/10/15.
//  Copyright © 2015 Bill Dawson. All rights reserved.
//

import Foundation

extension ClientConvenience {
    struct HTTPHeaderKeys {
        static let Accept = "Accept"
        static let ContentType = "Content-Type"
    }

    struct HTTPHeaderValues {
        static let JSON = "application/json"
    }

    struct Errors {
        static let Connection = "The network appears to be offline. Please check your network connection and try again."
    }
}