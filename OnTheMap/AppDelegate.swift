//
//  AppDelegate.swift
//  OnTheMap
//
//  Created by Bill Dawson on 10/29/15.
//  Copyright © 2015 Bill Dawson. All rights reserved.
//

import UIKit
import FBSDKCoreKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject : AnyObject]?) -> Bool {
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        return true
    }

    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject) -> Bool {
        return FBSDKApplicationDelegate.sharedInstance().application(application, openURL: url, sourceApplication: sourceApplication, annotation: annotation)
    }

    func applicationDidEnterBackground(application: UIApplication) {
        UdacityConfig.sharedUdacityConfig().persist()
    }

    func applicationWillTerminate(application: UIApplication) {
        UdacityConfig.sharedUdacityConfig().persist()
    }

    func applicationDidBecomeActive(application: UIApplication) {
        FBSDKAppEvents.activateApp()
    }

}

