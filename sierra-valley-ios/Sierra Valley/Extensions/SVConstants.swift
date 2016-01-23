//
//  SVConstants.swift
//  Sierra Valley
//
//  Created by Jack Arendt on 1/18/16.
//  Copyright © 2016 John Arendt. All rights reserved.
//

import Foundation

let applicationWillResignNotification = "applicationWillResign"
let applicationDidEnterForegroundNotification = "applicationDidEnterForeground"
let applicationDidBecomeActiveNotification = "applicationDidBecomeActive"
let applicationDidEnterBackgroundNotification = "applicationDidEnterBackground"


let carsTextureAtlas = "Cars"


enum CollisionBitmaskCategory : UInt32 {
    case Car    = 0x01
    case Floor  = 0x10
}