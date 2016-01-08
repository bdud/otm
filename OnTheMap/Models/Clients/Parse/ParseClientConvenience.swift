//
//  ParseClientConvenience.swift
//  OnTheMap
//
//  Created by Bill Dawson on 12/14/15.
//  Copyright © 2015 Bill Dawson. All rights reserved.
//

import Foundation

extension ParseClient {
    func prepareRequest(url: NSURL) -> NSMutableURLRequest {
        let req = NSMutableURLRequest(URL: url)
        req.setValue(ClientConvenience.HTTPHeaderKeys.Accept, forHTTPHeaderField: ClientConvenience.HTTPHeaderValues.JSON)
        req.setValue(Constants.AppId, forHTTPHeaderField: HeaderFieldNames.AppId)
        req.setValue(Constants.RESTApiKey, forHTTPHeaderField: HeaderFieldNames.RESTApiKey)
        return req
    }

    func preparePOSTRequest(url: NSURL) -> NSMutableURLRequest {
        let req = prepareRequest(url)
        req.HTTPMethod = "POST"
        req.addValue(ClientConvenience.HTTPHeaderValues.JSON, forHTTPHeaderField: ClientConvenience.HTTPHeaderKeys.ContentType)
        return req
    }

    func preparePUTRequest(url: NSURL) -> NSMutableURLRequest {
        let req = preparePOSTRequest(url)
        req.HTTPMethod = "PUT"
        return req
    }

}