//
//  ParseClient.swift
//  OnTheMap
//
//  Created by Bill Dawson on 12/14/15.
//  Copyright © 2015 Bill Dawson. All rights reserved.
//

import Foundation

class ParseClient {

    func addLocation(location: StudentLocation, completionHandler: (success: Bool, errorString: String?)) {
        
    }

    func fetchLocations(completionHandler: (success: Bool, errorString: String?, data: [StudentLocation]?) -> Void) {

        ClientConvenience.sharedInstance().performDataTaskWithRequest(prepareGETRequest()) { (success, httpStatusCode, errorMessage, responseData) -> Void in
            guard success else {
                if let errorMessage = errorMessage {
                    print(errorMessage)
                    completionHandler(success: success, errorString: errorMessage, data: nil)
                }
                else {
                    let message = "Unknown error fetching locations"
                    print(message)
                    completionHandler(success: success, errorString: message, data: nil)
                }
                return
            }

            guard let data = responseData else {
                print("No data returned when fetching locations")
                completionHandler(success: false, errorString: "No location data found", data: nil)
                return
            }

            guard let result = try? NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions(rawValue: 0)) else {
                print("Unable to convert data to JSON")
                completionHandler(success: false, errorString: "There was a problem reading the data", data: nil)
                return
            }

            guard let dict = result as? [String: AnyObject] else {
                print("Parsed data not as expected: \(String(data: data, encoding: NSUTF8StringEncoding))")
                completionHandler(success: false, errorString: "There was a problem reading the data", data: nil)
                return
            }

            guard let results = dict[Constants.ResultFieldKey] as? [[String: AnyObject]] else  {
                print("\(Constants.ResultFieldKey) is not an array")
                completionHandler(success: false, errorString: "There was a problem reading the data", data: nil)
                return
            }

            let locations = results.map({ (elem: [String: AnyObject]) -> StudentLocation in
                    return StudentLocation(fromDictionary: elem)
            })

            completionHandler(success: true, errorString: nil, data: locations)

        }


    }

    // MARK: Class (static) methods

    class func sharedInstance() -> ParseClient {
        struct Singleton {
            static let instance = ParseClient()
        }
        return Singleton.instance
    }

}