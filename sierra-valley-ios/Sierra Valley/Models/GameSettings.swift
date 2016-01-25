//
//  GameSettings.swift
//  Sierra Valley
//
//  Created by Jack Arendt on 1/24/16.
//  Copyright © 2016 John Arendt. All rights reserved.
//

import SpriteKit

/// A bunch of important information regarding the scene's info
public struct GameSettings {
    /// The width of the row
    public var rowWidth : CGFloat = 30
    
    /// The height of the rectangle when on the maximum edge
    public var rectangleHeight : CGFloat = 80
    
    /// The height of the rectangle when on the minimum edge
    public var minMountainHeight : CGFloat = 40
    
    /// The time it takes for a row to go from one edge to another
    public var edgeToEdgeTime : CFTimeInterval = 3.0
    
    /// The refresh rate of the display
    public let vSyncTime : CFTimeInterval = 1.0/60.0
    
    /// The number of frames that it takes for a row to become fully visible on the screen
    public var framesPerRow : CFTimeInterval = 8.0
    
    /// The screen width
    public let screenWidth : CGFloat = UIScreen.mainScreen().bounds.width
    
    /// The actual width is the width of the scene.  It is calculated by figuring out how many frames can be visible
    /// on the screen at one time and calculates the width needed to fit all of the rows fully on the screen.
    public var actualWidth : CGFloat {
        get {
            return numFrames * rowWidth
        }
    }
    
    /// Returns the number of frames that can be visible on the screen at one time.
    /// Adds an additional frame for padding
    public var numFrames : CGFloat {
        get {
            return ceil(screenWidth / rowWidth) + 1
        }
    }
    
    /// The angle at which the rows drop across the screen
    public var angle : CGFloat {
        get {
            return (rectangleHeight - minMountainHeight) / actualWidth
        }
    }
    
    /// The amount of time it takes for a row to be fully visible on the screen
    public var rowRefreshRate : CFTimeInterval {
        get {
            return vSyncTime * framesPerRow
        }
    }
}