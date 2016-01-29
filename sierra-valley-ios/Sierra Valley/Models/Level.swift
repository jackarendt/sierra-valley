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
    
    init(settings : GameSettings, difficulty : Int) {
        self.gameSettings = settings
        self.difficulty = difficulty
        computeLevel(difficulty, avalanche: false, queue: rows)
    }
}


func computeLevel(difficulty : Int, avalanche : Bool, queue : Queue<ResourceRow>) {
    for _ in 0.stride(through: 200, by: 1) { // TODO: don't bs this
        var vals : [SVSpriteName] = [.Rectangle]
        var depressedHeight : CGFloat = 0
        if arc4random() % 5 == 0 {
            vals.append(.Spike)
            if arc4random() % 5 == 0 {
                depressedHeight = 80
            }
        } else {
            vals.append(.Triangle)
        }
        let row = ResourceRow(row: vals, depressedHeight: depressedHeight)
        
        queue.enqueue(row)
    }
}