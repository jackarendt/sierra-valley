//
//  GameManager.swift
//  Sierra Valley
//
//  Created by Jack Arendt on 1/24/16.
//  Copyright © 2016 John Arendt. All rights reserved.
//

import SpriteKit


public protocol GameManagerDelegate : class {
    func placeResource(resource : SKSpriteNode)
    func removeResource(resource : SKSpriteNode)
    func moveResource(resource : SVLevelResource, toPoint newLoc : CGPoint)
    func scoreChanged(newScore : Int)
}

public class GameManager {
    
    weak public var delegate : GameManagerDelegate?
    
    public var bounds : CGRect
    
    public var score = 0
    
    public init(delegate : GameManagerDelegate, gameBounds : CGRect) {
        self.delegate = delegate
        self.bounds = gameBounds
    }
    
    /// Call this when the game starts to start placing sprites
    public func startGame() {
        
        
    }
    
    private func gameLoop() {
        
    }
    
    
    public func pause() {
        
    }
    
    public func resume() {
        
    }
}