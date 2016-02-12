//
//  Level.swift
//  Sierra Valley
//
//  Created by Jack Arendt on 1/28/16.
//  Copyright © 2016 John Arendt. All rights reserved.
//

import UIKit

/// The level class is an encoded version of what the user will drive over.  It uses a unique formula
/// to create a level based on a difficulty level
public final class Level {
    
    /// Contains important settings about the current game such as how high the camera will have to pan, etc.
    public var gameSettings : GameSettings
    
    /// The width of a level
    public var levelWidth : CGFloat {
        get {
            return CGFloat(rows.count) * gameSettings.rowWidth
        }
    }
    
    /// The amount of time it will take to move across the level
    public var levelTime : CFTimeInterval {
        get {
            return CFTimeInterval(rows.count) * gameSettings.rowRefreshRate
        }
    }
    
    /// The height that the car will climb across the level
    public var levelHeight : CGFloat {
        get {
            return levelWidth * tan(gameSettings.angle)
        }
    }
    
    /// The number of empty and flat rows at the end of a level
    public var flatRowCount : Int = 0
    
    /// The rows that are used to create the level in the form of a queue
    public let rows = Queue<ResourceRow>()
    
    /// The difficulty of the level
    public var difficulty = 0
    
    /// Whether the level is an avalanche or not
    public var avalanche = false
    
    
    /// Initializes a level with the settings object and a difficulty
    /// - Parameter settings: The game settings for proper computation
    /// - Parameter difficulty: The difficulty of a level between 0 and 100
    public init(settings : GameSettings, difficulty : Int) {
        self.gameSettings = settings
        self.difficulty = difficulty
        flatRowCount = Int(gameSettings.numFrames/2) - 1
        computeLevel(difficulty, queue: rows, flatRowLength: flatRowCount)
        
    }
}