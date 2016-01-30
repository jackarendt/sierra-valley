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
    func scoreChanged(newScore : Int)
    func gameEnded(finalScore : Int)
}

final public class GameManager {
    
    weak public var delegate : GameManagerDelegate?
    
    public var bounds : CGRect
    
    public var score = 0
    
    public var gameSettings = GameSettings()
    
    weak public var scene : SKScene?
    
    weak public var camera : SKCameraNode?
    
    private var previousTime : CFTimeInterval = 0
    
    private var frameCount = 0
    
    public init(delegate : GameManagerDelegate, gameBounds : CGRect, scene : SKScene) {
        self.delegate = delegate
        self.bounds = gameBounds
        self.scene = scene
    }
    
    // temporary variables until things get set up
    private var rowBuffer : RowBuffer!
    
    private var readyToRender = false
    
    private var orange = true
    
    private var level : Level!
    
    /// Call this when the game starts to start placing sprites
    public func startGame() {
        var buf = [RowBufferItem]()
        for _ in 0.stride(through: Int(gameSettings.numFrames), by: 1){
            buf.append(RowBufferItem())
        }
        rowBuffer = RowBuffer(items: buf)
        
        level = Level(settings: gameSettings, difficulty: 0)
        
        readyToRender = true
        
        if let camera = camera {
            delegate?.placeResource(camera)
            let moveDifference = gameSettings.maxMountainHeight - gameSettings.minMountainHeight
            print("expected: \(225 * 60) actual : \(level.levelWidth)")
            print("expected: \(20 * moveDifference) actual: \(level.levelHeight)")
            
            
            
            let action = SKAction.moveTo(CGPoint(x: level.levelWidth + camera.position.x, y: camera.position.y + level.levelHeight), duration: level.levelTime)
            let endAction = SKAction.runBlock(){ // junk code. please remove eventually
                self.scene?.paused = true
                self.delegate?.gameEnded(0)
            }
            camera.runAction(SKAction.sequence([action, endAction]))
        }
    }
    
    public func pause() {
        previousTime = 0
    }
    
    public func resume() {
        
    }
    
    public func update(time : CFTimeInterval, var cameraPosition : CGPoint) {
        if previousTime != 0 {
            frameCount += calcPassedFrames(time)
            if frameCount >= gameSettings.framesPerRow && readyToRender {
                let diff = frameCount - gameSettings.framesPerRow
                cameraPosition.x += 3.75 * CGFloat(diff)
                let buffer = rowBuffer.next()
                
                // FOR DEBUG USE ONLY
                var color = SVColor.maroonColor()
                if orange {
                    color = SVColor.orangeColor()
                }
                orange = !orange
                let row = level.rows.dequeue()
                let sprites = renderResourceRow(row!, rowBuffer: buffer, cameraPosition: cameraPosition, color: color, direction: .Right, gameSettings: gameSettings)
                for s in sprites {
                    if s.scene == nil {
                        delegate?.placeResource(s)
                    }
                }
                frameCount = diff
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