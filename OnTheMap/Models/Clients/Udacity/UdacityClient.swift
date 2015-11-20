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
            jsonDataDictionary: [JSONKeys.Username: emailAddress, JSONKeys.Password: password]) else {
                completionHandler(success: false, errorString: "Unable to create HTTP request")
                return
        }


        performDataTaskWithRequest(request) { (success, errorMessage, jsonData) -> Void in
            // todo
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