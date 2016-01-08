//
//  ParseClient.swift
//  OnTheMap
//
//  Created by Bill Dawson on 12/14/15.
//  Copyright © 2015 Bill Dawson. All rights reserved.
//

import Foundation

class ParseClient {

    var locations: [StudentInformation]?

    func addLocation(location: StudentInformation, completionHandler: (success: Bool, errorString: String?) -> Void) {

        guard let data = location.jsonData() else {
            print("No JSON data for location")
            completionHandler(success: false, errorString: Errors.General)
            return
        }

        guard let uniqueKey = location.uniqueKey else {
            print("No unique key in location object. This shouldn't happen")
            completionHandler(success: false, errorString: Errors.General)
            return
        }

        fetchLocationWithUniqueKey(uniqueKey) { (location, errorMessage) in
            guard errorMessage == nil else {
                completionHandler(success: false, errorString: errorMessage!)
                return
            }

            let req: NSMutableURLRequest
            if let location = location, objectId = location.parseObjectId {
                // Update existing entry
                req = self.preparePUTRequest(Endpoint.LocationOfObject(objectId).url())
            }
            else {
                // Create all new entry
                req = self.preparePOSTRequest(Endpoint.PostLocation.url())
            }

            print("URL: \(req.URL!)")
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
    }

    func fetchLocations(completionHandler: (success: Bool, errorString: String?, data: [StudentInformation]?) -> Void) {

        let req = prepareRequest(Endpoint.GetLocations(100, "-updatedAt").url())

        ClientConvenience.sharedInstance().performDataTaskWithRequest(req) { (success, httpStatusCode, errorMessage, responseData) -> Void in
            self.evaluateFetchLocationResponse(success, httpStatusCode: httpStatusCode, errorMessage: errorMessage, responseData: responseData, completionHandler: { (success, errorString, data) -> Void in

                self.locations = data
                completionHandler(success: success, errorString: errorMessage, data: data)
            })
        }
    }

    func evaluateFetchLocationResponse(success: Bool,
        httpStatusCode: Int?,
        errorMessage: String?,
        responseData: NSData?,
        completionHandler: (success: Bool, errorString: String?, data: [StudentInformation]?) -> Void)   {
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

            guard let resultsObject = dict[Constants.ResultFieldKey] else {
                print("\(Constants.ResultFieldKey) not found in returned data")
                completionHandler(success: false, errorString: "There was a problem reading the data.", data: nil)
                return
            }

            guard let results = resultsObject as? [[String: AnyObject]] else  {
                print("Results empty")
                // Not an error, just return nil for data.
                completionHandler(success: true, errorString: nil, data: nil)
                return
            }

            let locations = results.map({ (elem: [String: AnyObject]) ->
                StudentInformation in
                return StudentInformation(fromDictionary: elem)
            })

            completionHandler(success: true, errorString: nil, data: locations)
    }

    func fetchLocationWithUniqueKey(uniqueKey: String, completionHandler: (location: StudentInformation?, errorMessage: String?) -> Void) {

        let req = prepareRequest(Endpoint.LocationOfKey(uniqueKey).url())

        ClientConvenience.sharedInstance().performDataTaskWithRequest(req) { (success, httpStatusCode, errorMessage, responseData) -> Void in
            
            self.evaluateFetchLocationResponse(success, httpStatusCode: httpStatusCode, errorMessage: errorMessage, responseData: responseData, completionHandler: { (success, errorString, data) -> Void in

                guard let locations = data else {
                    completionHandler(location: nil, errorMessage: errorString)
                    return
                }

                if locations.count > 0 {
                    completionHandler(location: locations[0], errorMessage: nil)
                }
                else {
                    completionHandler(location: nil, errorMessage: nil)
                }
            })
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