//
//  LevelQueue.swift
//  Sierra Valley
//
//  Created by Jack Arendt on 2/4/16.
//  Copyright © 2016 John Arendt. All rights reserved.
//

import UIKit

/// The Level Queue is a Queue subclass that generates levels when the queue falls below a threshold
/// it will automatically generate new levels
class LevelQueue : Queue<Level> {
    
    /// Sets the minimum amount of items that will be available in the queue
    var elementThreshold = 4
    
    /// the max difficulty a level can be
    private var maxDifficulty = 125
    
    /// the min difficulty a level can be
    private var minDifficulty = 75
    
    override init() {
        super.init()
        refillQueue(background: false)
    }
    
    override init(items: [Level]) {
        super.init(items: items)
        refillQueue(background: false)
    }
    
    override func dequeue() -> Level? {
        let item = super.dequeue()
        refillQueue(background: true)
        return item
    }
    
    private func refillQueue(background inBackground : Bool) {
        func generate() {
            while count < elementThreshold {
                let difficulty = assessDifficulty()
                generateLevel(difficulty)
                
                minDifficulty = min(minDifficulty + 5, 150) // set thresholds so it doesn't become impossible
                maxDifficulty = min(maxDifficulty + 10, 225)
            }
        }
        
        if inBackground {
            dispatch_async(dispatch_get_global_queue(QOS_CLASS_BACKGROUND, 0), {
                generate()
            })
        } else {
            generate()
        }
    }
    
    private func assessDifficulty() -> Int {
        return Int(arc4random()) % (maxDifficulty - minDifficulty) + minDifficulty
    }
    
    /// Generates a level with a given difficulty and enqueues it
    /// - Parameter difficulty: The difficulty of the level to be generated
    private func generateLevel(difficulty : Int) {
        let level = Level(difficulty: difficulty)
        if isEmpty() || peek(count).last?.avalanche == true {
            level.avalanche = false
        }
        enqueue(level)
    }
}
