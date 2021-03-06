//
//  UdacityClientConvenience.swift
//  OnTheMap
//
//  Created by Bill Dawson on 11/10/15.
//  Copyright © 2015 Bill Dawson. All rights reserved.
//

import Foundation

extension UdacityClient {

    func apiUrl(endpoint: String) -> NSURL {
        var resolved = endpoint
        if let accountKey = UdacityConfig.sharedUdacityConfig().AccountKey {
            resolved = endpoint.stringByReplacingOccurrencesOfString("[user]", withString: accountKey)
        }
        return NSURL(string: "\(Constants.APIBaseUrl)\(resolved)")!
    }

    func performDataTaskWithRequest(request: NSURLRequest, andCompletionHandler handler: (success: Bool, httpStatusCode: Int?, errorMessage: String?, jsonData: AnyObject?) -> Void) {
        ClientConvenience.sharedInstance().performDataTaskWithRequest(request) { (success, httpStatusCode, errorMessage, responseData) -> Void in
            if !success {
                handler(success: false, httpStatusCode: httpStatusCode, errorMessage: errorMessage, jsonData: nil)
                return
            }

            guard let responseData = responseData else {
                handler(success: false, httpStatusCode: httpStatusCode, errorMessage: "No data returned", jsonData: nil)
                return
            }

            // subset data per Udacity API guidelines
            let newData = responseData.subdataWithRange(NSMakeRange(5, responseData.length - 5))

            guard let jsonObject = try? NSJSONSerialization.JSONObjectWithData(newData, options: NSJSONReadingOptions(rawValue: 0)) else {
                handler(success: false, httpStatusCode: httpStatusCode, errorMessage: "Unable to parse result", jsonData: nil)
                return
            }

            handler(success: true, httpStatusCode: httpStatusCode, errorMessage: nil, jsonData: jsonObject)

        }
    }

}