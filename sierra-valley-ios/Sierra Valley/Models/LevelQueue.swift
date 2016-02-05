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
    
    override init() {
        super.init()
        while count < elementThreshold {
            generateLevel(10)
        }
    }
    
    override init(items: [Level]) {
        super.init(items: items)
        while count < elementThreshold {
            generateLevel(10)
        }
    }
    
    override func dequeue() -> Level? {
        let item = super.dequeue()
        while count < elementThreshold { // generate new levels until threshold is met
            generateLevel(10)
        }
        return item
    }
    
    /// Generates a level with a given difficulty and enqueues it
    /// - Parameter difficulty: The difficulty of the level to be generated
    private func generateLevel(difficulty : Int) {
        let level = Level(settings: GameSettings(), difficulty: difficulty)
        enqueue(level)
    }
}
