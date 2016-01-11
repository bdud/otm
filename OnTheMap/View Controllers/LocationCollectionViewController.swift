//
//  LocationCollectionViewController.swift
//  OnTheMap
//
//  Created by Bill Dawson on 12/16/15.
//  Copyright © 2015 Bill Dawson. All rights reserved.
//

import Foundation

protocol LocationCollectionViewController {
    // Caller (only TabBarController in this case)
    // guarantees that data store's location cache has been
    // updated already by the time this is called. Implementations
    // of this method therefore do not need to ask the data
    // store to udpate and can simply use dataStore.cachedLocations.
    func refreshLocations(completion: (() -> Void)?) -> Void

    // Caller (only TabBarController in this case)
    // guarantees that this new location is already in
    // the data store's cache. Implementations of this
    // method do not need to ask the data store to update
    // itself from the data source.
    func locationWasSaved(_: StudentInformation) -> Void
}