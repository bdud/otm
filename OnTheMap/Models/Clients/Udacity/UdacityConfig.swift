//
//  UdacityConfig.swift
//  OnTheMap
//
//  Created by Bill Dawson on 11/23/15.
//  Copyright © 2015 Bill Dawson. All rights reserved.
//

import UIKit

class UdacityConfig: NSObject {

    var AccountKey: String?

    var SessionId: String?

    

    // MARK: Class methods

    class func sharedUdacityConfig() -> UdacityConfig {
        struct Singleton {
            static var sharedInstance = UdacityConfig()
        }
        return Singleton.sharedInstance
    }
}
