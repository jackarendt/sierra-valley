//
//  SVConstants.swift
//  Sierra Valley
//
//  Created by Jack Arendt on 1/18/16.
//  Copyright © 2016 John Arendt. All rights reserved.
//

import Foundation

public let applicationWillResignNotification = "applicationWillResign"
public let applicationDidEnterForegroundNotification = "applicationDidEnterForeground"
public let applicationDidBecomeActiveNotification = "applicationDidBecomeActive"
public let applicationDidEnterBackgroundNotification = "applicationDidEnterBackground"


public let carsTextureAtlas = "Cars"
public let levelTextureAtlas = "LevelResources"


public enum CollisionBitmaskCategory : UInt32 {
    case Car    = 1
    case Floor  = 2
    case Spike  = 4
}

public enum SVSpriteName : String {
    case Car = "car"
    case Spike = "Spike"
}

