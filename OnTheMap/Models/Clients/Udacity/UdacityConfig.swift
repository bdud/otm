//
//  UdacityConfig.swift
//  OnTheMap
//
//  Created by Bill Dawson on 11/23/15.
//  Copyright © 2015 Bill Dawson. All rights reserved.
//

import UIKit

class UdacityConfig: NSObject {

    let UserDefaultsAccountKey = "UdacityAccountKey"
    let UserDefaultsSessionIDKey = "UdacitySessionID"
    let UserDefaultsSessionExpirationKey = "UdacitySessionExpiration"
    let UserDefaultsFirstNameKey = "UdacityUserFirstName"
    let UserDefaultsLastNameKey = "UdacityUserLastName"

    var AccountKey: String?
    var SessionId: String?
    var SessionExpiration: NSDate?
    var FirstName: String?
    var LastName: String?

    
    override init() {
        let store = NSUserDefaults.standardUserDefaults()
        self.AccountKey = store.stringForKey(UserDefaultsAccountKey)
        self.SessionId = store.stringForKey(UserDefaultsSessionIDKey)
        self.SessionExpiration = store.valueForKey(UserDefaultsSessionExpirationKey) as? NSDate
        self.FirstName = store.stringForKey(UserDefaultsFirstNameKey)
        self.LastName = store.stringForKey(UserDefaultsLastNameKey)
    }

    // MARK: Class methods

    class func sharedUdacityConfig() -> UdacityConfig {
        struct Singleton {
            static var sharedInstance = UdacityConfig()
        }
        return Singleton.sharedInstance
    }

    // MARK: Instance methods

    func persist() {
        let store = NSUserDefaults.standardUserDefaults()
        store.setObject(AccountKey, forKey: UserDefaultsAccountKey)
        store.setObject(SessionId, forKey: UserDefaultsSessionIDKey)
        store.setObject(SessionExpiration, forKey: UserDefaultsSessionExpirationKey)
        store.setObject(FirstName, forKey: UserDefaultsFirstNameKey)
        store.setObject(LastName, forKey: UserDefaultsLastNameKey)
        store.synchronize()
    }

    func clear() {
        AccountKey = nil
        SessionId = nil
        SessionExpiration = nil
        FirstName = nil
        LastName = nil
        persist()
    }

}
