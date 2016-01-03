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

            guard let jsonData = jsonData else {
                print("Success for authentication, but response data empty")
                completionHandler(success: false, errorString: ErrorMessages.Connection)
                return
            }

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

            guard let sessionExpiration = sessionDict[JSONKeys.SessionExpiration] as? String else {
                print("Session Expiration missing from response")
                completionHandler(success: false, errorString: ErrorMessages.Connection)
                return
            }

            let formatter = NSDateFormatter()
            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
            formatter.timeZone = NSTimeZone(forSecondsFromGMT: 0)
            formatter.locale = NSLocale(localeIdentifier: "en_US_POSIX")
            let expDate = formatter.dateFromString(sessionExpiration)
            config.SessionExpiration = expDate

            completionHandler(success: true, errorString: nil)
        }

    }

    func fetchUserInfo(completionHandler: (success: Bool, errorString: String?) -> Void) {

        let url = apiUrl(APIEndpoints.User)

        performDataTaskWithRequest(NSURLRequest(URL: url)) { (success, httpStatusCode, errorMessage, jsonData) -> Void in
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
                    print("Error making user info request, but no message.")
                    completionHandler(success: false, errorString: ErrorMessages.Connection)
                    return
                }

                print(errorMessage);
                completionHandler(success: false, errorString: ErrorMessages.Connection)
                return
            }

            guard let jsonData = jsonData else {
                print("Success for user info request, but response data empty")
                completionHandler(success: false, errorString: ErrorMessages.Connection)
                return
            }

            let config = UdacityConfig.sharedUdacityConfig()

            guard let userDict = jsonData[JSONKeys.User] as? NSDictionary else {
                print("user data missing from response")
                completionHandler(success: false, errorString: ErrorMessages.Connection)
                return
            }

            guard let lastName = userDict[JSONKeys.LastName] as? String else {
                print("last name key missing from response")
                completionHandler(success: false, errorString: ErrorMessages.Connection)
                return
            }

            config.LastName = lastName

            guard let firstName = userDict[JSONKeys.FirstName] as? String else {
                print("first name key missing from response")
                completionHandler(success: false, errorString: ErrorMessages.Connection)
                return
            }

            config.FirstName = firstName
            config.persist()

                        
            completionHandler(success: true, errorString: nil)
        }
        
    }

    func deleteSession() {
        UdacityConfig.sharedUdacityConfig().clear()

        // Be a good citizen and clear the session up at the server.
        let url = apiUrl(APIEndpoints.Session)
        let req = NSMutableURLRequest(URL: url)
        req.HTTPMethod = "DELETE"

        if let cookies = NSHTTPCookieStorage.sharedHTTPCookieStorage().cookies {
            for cookie in cookies {
                if cookie.name == "XSRF-TOKEN" {
                    req.setValue(cookie.value, forKey: "X-XSRF-TOKEN")
                    break
                }
            }
        }

        performDataTaskWithRequest(req) { (success, httpStatusCode, errorMessage, jsonData) -> Void in
            if success {
                print("Session delete success")
            }
            else if let msg = errorMessage {
                print("Failed to delete session: \(msg)")
            }
            else {
                print("Failed to delete session. No error message.")
            }
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