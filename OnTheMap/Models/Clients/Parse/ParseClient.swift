//
//  ParseClient.swift
//  OnTheMap
//
//  Created by Bill Dawson on 12/14/15.
//  Copyright © 2015 Bill Dawson. All rights reserved.
//

import Foundation

class ParseClient {

    var locations: [StudentLocation]?

    func addLocation(location: StudentLocation, completionHandler: (success: Bool, errorString: String?) -> Void) {
        guard let data = location.jsonData() else {
            print("No JSON data for location")
            completionHandler(success: false, errorString: Errors.General)
            return
        }

        var req : NSMutableURLRequest

        if let uniqueId = location.uniqueKey {
            if let existing = locationWithUniqueKey(uniqueId), objectId = existing.parseObjectId {
                req = preparePUTRequest(objectId)
            }
            else {
                req = preparePOSTRequest()
            }
        }
        else {
            req = preparePOSTRequest()
        }

        req.HTTPBody = data

        ClientConvenience.sharedInstance().performDataTaskWithRequest(req) { (success, httpStatusCode, errorMessage, responseData) -> Void in
            guard success else {
                if let data = responseData {
                    if let dataString = NSString(data: data, encoding: NSUTF8StringEncoding) {
                        print("Data String from failed attempt: \(dataString)")
                    }
                }
                guard let _ = httpStatusCode else {
                    // no http status code, no network connection?
                    completionHandler(success: false, errorString: Errors.Network)
                    return
                }
                guard let errorMessage = errorMessage else {
                    print("Unknown error from performDataTaskWithRequest")
                    completionHandler(success: false, errorString: Errors.General)
                    return
                }
                print("Error string from performDataTaskWithRequest: \(errorMessage)")
                completionHandler(success: false, errorString: Errors.General)
                return
            }

            completionHandler(success: true, errorString: nil)
        }


    }

    func deleteLocationWithUniqueId(id: String, completionHandler: (success: Bool, errorMessage: String?) -> Void) {
        guard let location = locationWithUniqueKey(id), objectId = location.parseObjectId else {
            completionHandler(success: false, errorMessage: "No existing location with that ID")
            return
        }
        let urlString = "\(Constants.ApiUrl)/\(objectId)"
        guard let url =  NSURL(string: urlString) else {
            print("Bad url: \(urlString)")
            return
        }

        let req = prepareRequest()
        req.HTTPMethod = "DELETE"
        req.URL = url

        ClientConvenience.sharedInstance().performDataTaskWithRequest(req) { (success, httpStatusCode, errorMessage, responseData) -> Void in
            guard success else {
                if let code = httpStatusCode {
                    print("DELETE failed with status code \(code)")
                }
                else {
                    print("DELETE failed with no http status code")
                }
                if let msg = errorMessage {
                    print("Error message: \(msg)")
                }
                else {
                    print("No error message")
                }
                if let data = responseData {
                    let str = String(data: data, encoding: NSUTF8StringEncoding)
                    print("Did receive data in failed request's response: \(str)")
                }
                completionHandler(success: false, errorMessage: errorMessage)
                return
            }
            print("Deletion successful")
            completionHandler(success: true, errorMessage: nil)
        }

    }

    func fetchLocations(completionHandler: (success: Bool, errorString: String?, data: [StudentLocation]?) -> Void) {

        ClientConvenience.sharedInstance().performDataTaskWithRequest(prepareRequest()) { (success, httpStatusCode, errorMessage, responseData) -> Void in
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

            let locations = results.map({ (elem: [String: AnyObject]) ->
                StudentLocation in
                return StudentLocation(fromDictionary: elem)
            })

            self.locations = locations

            completionHandler(success: true, errorString: nil, data: locations)

        }
    }

    func locationExistsWithUniqueKey(uniqueKey: String) -> Bool {
        if let _ = locationWithUniqueKey(uniqueKey) {
            return true
        }
        else {
            return false
        }
    }

    func locationWithUniqueKey(uniqueKey: String) -> StudentLocation? {
        if let locations = self.locations {
            for l in locations {
                if l.uniqueKey == uniqueKey {
                    return l
                }
            }
        }
        return nil
    }

    // MARK: Class (static) methods

    class func sharedInstance() -> ParseClient {
        struct Singleton {
            static let instance = ParseClient()
        }
        return Singleton.instance
    }
    
}