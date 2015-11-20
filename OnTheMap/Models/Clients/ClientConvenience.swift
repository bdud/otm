//
//  NetConvenience.swift
//  OnTheMap
//
//  Created by Bill Dawson on 11/10/15.
//  Copyright © 2015 Bill Dawson. All rights reserved.
//

import Foundation


class ClientConvenience {

    func preparePostRequest(url: NSURL, jsonDataDictionary: [NSString: AnyObject]) -> NSMutableURLRequest? {
        let request: NSMutableURLRequest = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "POST"
        request.setValue(HTTPHeaderValues.JSON, forHTTPHeaderField: HTTPHeaderKeys.Accept)
        request.setValue(HTTPHeaderValues.JSON, forHTTPHeaderField: HTTPHeaderKeys.ContentType)

        guard let jsonData = try? NSJSONSerialization.dataWithJSONObject(jsonDataDictionary, options: NSJSONWritingOptions(rawValue: 0)) else {
            print("Unable to convert POST data to JSON")
            return nil
        }

        request.HTTPBody = jsonData

        return request

    }

    func performDataTaskWithRequest(request: NSURLRequest, andCompletionHandler handler: (success: Bool, errorMessage: String?, responseData: NSData?) -> Void) {
        let session = NSURLSession.sharedSession()
        session.dataTaskWithRequest(request) { (data, response, error) -> Void in
            guard error == nil else {
                handler(success: false, errorMessage: error?.localizedDescription, responseData: nil)
                return
            }

            guard let statusCode = (response as? NSHTTPURLResponse)?.statusCode where statusCode >= 200 && statusCode <= 299 else {
                if let response = response as? NSHTTPURLResponse {
                    handler(success: false, errorMessage: "Your invalid response. Status code: \(response.statusCode)", responseData: nil)
                } else if let response = response {
                    handler(success: false, errorMessage: "No HTTP URL response received. Actual response: \(response)", responseData: nil)
                } else {
                    handler(success: false, errorMessage: "No response received", responseData: nil)
                }
                return
            }

            guard let data = data else {
                handler(success: false, errorMessage: "No data returned", responseData: nil)
                return
            }

            handler(success: true, errorMessage: nil, responseData: data);

        }
    }

    // MARK: Class (static) functions

    class func sharedInstance() -> ClientConvenience {
        struct Singleton {
            static var instance = ClientConvenience()
        }
        return Singleton.instance
    }
}