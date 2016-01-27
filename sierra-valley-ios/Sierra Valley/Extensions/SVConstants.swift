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


public struct CollisionBitmaskCategory {
    static let Car       : UInt32 = 1 << 0
    static let Floor     : UInt32 = 1 << 1
    static let Spike     : UInt32 = 1 << 2
    static let Rectangle : UInt32 = 1 << 3
}

public enum SVSpriteName : String {
    case Car = "car"
    case Spike = "Spike"
    case Rectangle = "Rectangle"
    case Triangle = "Triangle"
    case None = "none"
}

