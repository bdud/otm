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
        return NSURL(string: "\(Constants.APIBaseUrl)\(endpoint)")!
    }

    func performDataTaskWithRequest(request: NSURLRequest, andCompletionHandler handler: (success: Bool, errorMessage: String?, jsonData: AnyObject?) -> Void) {
        ClientConvenience.sharedInstance().performDataTaskWithRequest(request) { (success, errorMessage, responseData) -> Void in
            if !success {
                handler(success: false, errorMessage: errorMessage, jsonData: nil)
                return
            }

            guard let responseData = responseData else {
                handler(success: false, errorMessage: "No data returned", jsonData: nil)
                return
            }

            // subset data per Udacity API guidelines
            let newData = responseData.subdataWithRange(NSMakeRange(5, responseData.length - 5))

            guard let jsonObject = try? NSJSONSerialization.JSONObjectWithData(newData, options: NSJSONReadingOptions(rawValue: 0)) else {
                handler(success: false, errorMessage: "Unable to parse result", jsonData: nil)
                return
            }

            handler(success: true, errorMessage: nil, jsonData: jsonObject)

        }
    }

}