//
//  Level.swift
//  Sierra Valley
//
//  Created by Jack Arendt on 1/28/16.
//  Copyright © 2016 John Arendt. All rights reserved.
//

import SpriteKit

public final class Level {
    
    var gameSettings : GameSettings
    
    var levelWidth : CGFloat {
        get {
            return CGFloat(rows.count) * gameSettings.rowWidth
        }
    }
    
    var difficulty = 0
    
    var levelTime : CFTimeInterval {
        get {
            return CFTimeInterval(rows.count) * gameSettings.rowRefreshRate
        }
    }
    
    var levelHeight : CGFloat {
        get {
            return levelWidth * tan(gameSettings.angle)
        }
    }
    
    let rows = Queue<ResourceRow>()
    
    var avalanche = false
    
    init(settings : GameSettings, difficulty : Int) {
        self.gameSettings = settings
        self.difficulty = difficulty
        computeLevel(difficulty, queue: rows)
    }
}