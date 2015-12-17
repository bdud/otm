//
//  LocationCollectionViewController.swift
//  OnTheMap
//
//  Created by Bill Dawson on 12/16/15.
//  Copyright © 2015 Bill Dawson. All rights reserved.
//

import Foundation

protocol LocationCollectionViewController {
    func refreshLocations(completion: (() -> Void)?) -> Void
    func addLocation(location: StudentLocation) -> Void
}