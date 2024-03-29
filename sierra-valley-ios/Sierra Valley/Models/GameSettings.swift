//
//  GameSettings.swift
//  Sierra Valley
//
//  Created by Jack Arendt on 1/24/16.
//  Copyright © 2016 John Arendt. All rights reserved.
//

import UIKit

/// A bunch of important information regarding the scene's info
public class GameSettings {
    
    static let sharedSettings = GameSettings()
    
    /// The width of the row
    public var rowWidth : CGFloat = 30
    
    /// The height of the rectangle when on the maximum edge
    public var maxMountainHeight : CGFloat {
        get {
            return actualWidth * tan(angle) + minMountainHeight
        }
    }
    
    /// The height of the rectangle when on the minimum edge
    public var minMountainHeight : CGFloat = 40
    
    public var triangleHeight : CGFloat {
        get {
            return rowWidth * tan(angle)
        }
    }
    
    /// The refresh rate of the display
    public let vSyncTime : CFTimeInterval = 1.0/60.0
    
    /// The number of frames that it takes for a row to become fully visible on the screen
    public var framesPerRow : Int = 5
    
    /// The screen width
    public let screenWidth : CGFloat = UIScreen.mainScreen().bounds.width
    
    /// The screen height
    public let screenHeight : CGFloat = UIScreen.mainScreen().bounds.height
    
    /// The number of frames it takes to move from the minimum mountain height to the maximum
    public var framesToTop : Int {
        get {
            let height = maxMountainHeight - minMountainHeight
            let ftt = height / triangleHeight
            return Int(ceil(ftt))
        }
    }
    
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
            var orig = ceil(screenWidth / rowWidth) + 4
            if orig % 2 == 1 {
                orig += 1
            }
            return orig
        }
    }
    
    /// The angle at which the rows drop across the screen
    public var angle : CGFloat {
        get {
            return atan(2.0/15.0)
        }
    }
    
    /// The amount of time it takes for a row to be fully visible on the screen
    public var rowRefreshRate : CFTimeInterval {
        get {
            return vSyncTime * CFTimeInterval(framesPerRow)
        }
    }
}