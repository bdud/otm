//
//  UdacityClient.swift
//  OnTheMap
//
//  Created by Bill Dawson on 11/10/15.
//  Copyright © 2015 Bill Dawson. All rights reserved.
//

import Foundation

class UdacityClient {

    func authenticate(emailAddress: String, password: String, completionHandler: (success: Bool, errorString: String?) -> Void) {

        let url = apiUrl(APIEndpoints.Session)
        guard let request = ClientConvenience.sharedInstance().preparePostRequest(url,
        jsonDataDictionary: [JSONKeys.Udacity: [JSONKeys.Username: emailAddress, JSONKeys.Password: password]]) else {
                completionHandler(success: false, errorString: ErrorMessages.Connection)
                return
        }


        performDataTaskWithRequest(request) { (success, httpStatusCode, errorMessage, jsonData) -> Void in
            guard success else {
                guard let httpStatusCode = httpStatusCode else {
                    completionHandler(success: false, errorString: ErrorMessages.Connection)
                    return
                }

                if httpStatusCode == 403 {
                    completionHandler(success: false, errorString: ErrorMessages.Credentials)
                    return
                }

                guard let errorMessage = errorMessage else {
                    print("Error making authentication request, but no message.")
                    completionHandler(success: false, errorString: ErrorMessages.Connection)
                    return
                }

                print(errorMessage);
                completionHandler(success: false, errorString: ErrorMessages.Connection)
                return
            }

            print("Auth Success")
            guard let jsonData = jsonData else {
                print("Success for authentication, but response data empty")
                completionHandler(success: false, errorString: ErrorMessages.Connection)
                return
            }

            print("\(jsonData)")

            let config = UdacityConfig.sharedUdacityConfig()

            guard let accountDict = jsonData[JSONKeys.Account] as? NSDictionary else {
                print("account data missing from response")
                completionHandler(success: false, errorString: ErrorMessages.Connection)
                return
            }

            guard let key = accountDict[JSONKeys.AccountKey] as? String else {
                print("account key missing from response")
                completionHandler(success: false, errorString: ErrorMessages.Connection)
                return
            }

            config.AccountKey = key

            guard let sessionDict = jsonData[JSONKeys.Session] as? NSDictionary else {
                print("session data missing from response")
                completionHandler(success: false, errorString: ErrorMessages.Connection)
                return
            }

            guard let sessionId = sessionDict[JSONKeys.SessionId] as? String else {
                print("Session ID missing from response")
                completionHandler(success: false, errorString: ErrorMessages.Connection)
                return
            }

            config.SessionId = sessionId
            completionHandler(success: true, errorString: nil)
        }

    }

    // MARK: Shared Instance

    class func sharedInstance() -> UdacityClient {

        struct Singleton {
            static var sharedInstance = UdacityClient()
        }
        
        return Singleton.sharedInstance
    }
    
}