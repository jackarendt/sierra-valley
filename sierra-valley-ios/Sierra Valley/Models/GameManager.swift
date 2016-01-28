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
}

public class GameManager {
    
    weak public var delegate : GameManagerDelegate?
    
    public var bounds : CGRect
    
    public var score = 0
    
    public var gameSettings = GameSettings()
    
    weak public var scene : SKScene?
    
    weak public var camera : SKCameraNode?
    
    public init(delegate : GameManagerDelegate, gameBounds : CGRect, scene : SKScene) {
        self.delegate = delegate
        self.bounds = gameBounds
        self.scene = scene
    }
    
    private var previousTime : CFTimeInterval = 0
    
    private var frameCount = 0
    
    private var rowBuffer : RowBuffer!
    
    private var readyToRender = false
    
    /// Call this when the game starts to start placing sprites
    public func startGame() {
        var buf = [RowBufferItem]()
        for _ in 0.stride(through: Int(gameSettings.numFrames), by: 1){
            buf.append(RowBufferItem())
        }
        rowBuffer = RowBuffer(items: buf)
        readyToRender = true
        
        if let camera = camera {
            delegate?.placeResource(camera)
            let moveDifference = gameSettings.maxMountainHeight - gameSettings.minMountainHeight
            let action = SKAction.moveTo(CGPoint(x: 20 * UIScreen.mainScreen().bounds.width + camera.position.x, y: camera.position.y + 20 * moveDifference), duration: 60.0)
            camera.runAction(action)
        }
    }
    
    public func pause() {
        
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
                let sprites = renderResourceRow(ResourceRow(row: [.Rectangle], baseHeight: 0), rowBuffer: buffer, cameraPosition: cameraPosition, color: UIColor.orangeColor(), direction: .Right, gameSettings: gameSettings)
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