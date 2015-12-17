//
//  ParseClientConvenience.swift
//  OnTheMap
//
//  Created by Bill Dawson on 12/14/15.
//  Copyright © 2015 Bill Dawson. All rights reserved.
//

import Foundation

extension ParseClient {
    func prepareGETRequest() -> NSMutableURLRequest {
        let url = NSURL(string: Constants.ApiUrl)!
        let req = NSMutableURLRequest(URL: url)
        req.setValue(ClientConvenience.HTTPHeaderKeys.Accept, forHTTPHeaderField: ClientConvenience.HTTPHeaderValues.JSON)
        req.setValue(Constants.AppId, forHTTPHeaderField: HeaderFieldNames.AppId)
        req.setValue(Constants.RESTApiKey, forHTTPHeaderField: HeaderFieldNames.RESTApiKey)
        return req
    }

}