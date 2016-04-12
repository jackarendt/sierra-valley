//
//  SVConstants.swift
//  Sierra Valley
//
//  Created by Jack Arendt on 1/18/16.
//  Copyright © 2016 John Arendt. All rights reserved.
//

import SpriteKit

public let applicationWillResignNotification = "applicationWillResign"
public let applicationDidEnterForegroundNotification = "applicationDidEnterForeground"
public let applicationDidBecomeActiveNotification = "applicationDidBecomeActive"
public let applicationDidEnterBackgroundNotification = "applicationDidEnterBackground"


public let rectangleTexture = SKTexture(imageNamed: SVLevelResource.Rectangle.rawValue)
public let spikeTexture     = SKTexture(imageNamed: SVLevelResource.Spike.rawValue)
public let triangleTexture  = SKTexture(imageNamed: SVLevelResource.Triangle.rawValue)


public struct CollisionBitmaskCategory {
    static let Car       : UInt32 = 1 << 0
    static let Floor     : UInt32 = 1 << 1
    static let Spike     : UInt32 = 1 << 2
    static let Rectangle : UInt32 = 1 << 3
    static let Triangle  : UInt32 = 1 << 4
    static let Background: UInt32 = 1 << 5
}

public enum SVSpriteName : String {
    case Car = "car"
    case Spike = "spike"
    case Rectangle = "rectangle"
    case Triangle = "triangle"
    case None = "none"
}

/// Enumeration for determining which direction the car is facing
public enum CarDirection {
    case Left // front of the car faces the left edge of the screen
    case Right // front of the car faces the right edge of the screen
    
    static func oppositeDirection(direction : CarDirection) -> CarDirection {
        if direction == .Left {
            return .Right
        } else {
            return .Left
        }
    }
}

/// The current theme for the game
public enum GameTheme : Int {
    /// The color theme changes based on the time of day
    case TimeBased = 0
    /// The day theme is always on
    case Day = 1
    /// It is always night time
    case Night = 2
    
    func name() -> String {
        switch self {
        case .TimeBased: return "Time"
        case .Day: return "Day"
        case .Night: return "Night"
        }
    }
}



