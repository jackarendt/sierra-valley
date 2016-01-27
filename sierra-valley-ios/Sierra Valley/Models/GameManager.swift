//
//  GameManager.swift
//  Sierra Valley
//
//  Created by Jack Arendt on 1/24/16.
//  Copyright © 2016 John Arendt. All rights reserved.
//

import SpriteKit


public protocol GameManagerDelegate : class {
    func placeResource(resource : SKNode)
    func removeResource(resource : SKNode)
    func scoreChanged(newScore : Int)
}

public class GameManager {
    
    weak public var delegate : GameManagerDelegate?
    
    public var bounds : CGRect
    
    public var score = 0
    
    public var gameSettings = GameSettings()
    
    public init(delegate : GameManagerDelegate, gameBounds : CGRect) {
        self.delegate = delegate
        self.bounds = gameBounds
    }
    
    private var previousTime : CFTimeInterval = 0
    
    private var frameCount = 0
    
    /// Call this when the game starts to start placing sprites
    public func startGame() {
        
    }
    
    private func gameLoop() {
        
    }
    
    
    public func pause() {
        
    }
    
    public func resume() {
        
    }
    
    public func update(time : CFTimeInterval) {
        if previousTime != 0 {
            frameCount += calcPassedFrames(time)
            if frameCount >= gameSettings.framesPerRow {
                // TODO: dequeue row
            }
        }
        previousTime = time
    }
    
    /// Calculates the number of frames that have passed since the last update
    private func calcPassedFrames(time : CFTimeInterval) -> Int {
        let diff = time - previousTime
        return Int(round(60 * diff))
    }
}