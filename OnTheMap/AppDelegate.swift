//
//  AppDelegate.swift
//  OnTheMap
//
//  Created by Bill Dawson on 10/29/15.
//  Copyright © 2015 Bill Dawson. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func applicationDidEnterBackground(application: UIApplication) {
        UdacityConfig.sharedUdacityConfig().persist()
    }

    func applicationWillTerminate(application: UIApplication) {
        UdacityConfig.sharedUdacityConfig().persist()
    }


}

