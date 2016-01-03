//
//  ParseClientConvenience.swift
//  OnTheMap
//
//  Created by Bill Dawson on 12/14/15.
//  Copyright © 2015 Bill Dawson. All rights reserved.
//

import Foundation

extension ParseClient {
    func prepareRequest() -> NSMutableURLRequest {
        let url = NSURL(string: Constants.ApiUrl)!
        let req = NSMutableURLRequest(URL: url)
        req.setValue(ClientConvenience.HTTPHeaderKeys.Accept, forHTTPHeaderField: ClientConvenience.HTTPHeaderValues.JSON)
        req.setValue(Constants.AppId, forHTTPHeaderField: HeaderFieldNames.AppId)
        req.setValue(Constants.RESTApiKey, forHTTPHeaderField: HeaderFieldNames.RESTApiKey)
        return req
    }

    func preparePOSTRequest() -> NSMutableURLRequest {
        let req = prepareRequest()
        req.HTTPMethod = "POST"
        req.addValue(ClientConvenience.HTTPHeaderValues.JSON, forHTTPHeaderField: ClientConvenience.HTTPHeaderKeys.ContentType)
        return req
    }

    func preparePUTRequest(objectId: String) -> NSMutableURLRequest {
        let req = preparePOSTRequest()
        req.HTTPMethod = "PUT"
        let urlString = "\(Constants.ApiUrl)/\(objectId)"
        req.URL = NSURL(string: urlString)!
        return req
    }

}