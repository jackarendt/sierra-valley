//
//  GameScene.swift
//  Sierra Valley
//
//  Created by Jack Arendt on 1/18/16.
//  Copyright (c) 2016 John Arendt. All rights reserved.
//

import SpriteKit

protocol GameSceneDelegate : class {
    func gameDidEnd(finalScore : Int, newAvalanches : Int)
}

class GameScene: SVBaseScene {
    
    weak var gameDelegate : GameSceneDelegate?
    
    var gameManager : GameManager!
    
    let car = CarNode(car: .SierraTurbo)
    
    override func didMoveToView(view: SKView) {
        super.didMoveToView(view)
        view.allowsTransparency = true
        backgroundColor = SKColor.clearColor()
        
        gameManager = GameManager(delegate: self, gameBounds: CGRect(x: 0, y: 0, width: size.width, height: size.height), scene: self)
        
        
        let newCamera = SKCameraNode()
        newCamera.position = CGPoint(x: view.bounds.width/2, y: view.bounds.height/2)
        newCamera.xScale = view.bounds.width / size.width
        newCamera.yScale = view.bounds.height / size.height
        camera = newCamera
        
        gameManager.camera = newCamera
        
        blendMode = .Replace
        
        gameManager.startGame()
    }
    
    override func tapGestureRecognized(tap: UITapGestureRecognizer) {
        
    }
    
    override func swipeLeftGestureRecognized(swipeLeft: UISwipeGestureRecognizer) {
        car.switchDirection(.Left)
    }
    
    override func swipeRightGestureRecognized(swipeRight: UISwipeGestureRecognizer) {
        car.switchDirection(.Right)
    }
   
    override func update(currentTime: CFTimeInterval) {
        gameManager.update(currentTime, cameraPosition: camera!.position)
    }
}

extension GameScene : GameManagerDelegate {
    func placeResource(resource: SKNode) {
        addChild(resource)
    }
    
    func scoreChanged(newScore: Int) {
        
    }
    
    func gameEnded(finalScore: Int) {
        gameDelegate?.gameDidEnd(0, newAvalanches: 0)
    }
}

extension GameScene {
    override func didBeginContact(contact: SKPhysicsContact) {
        pause()
        gameDelegate?.gameDidEnd(0, newAvalanches: 0)
    }
    
    override func didEndContact(contact: SKPhysicsContact) {
        
    }
}

extension GameScene {
    /// Pauses the game
    func pause() {
        view?.paused = true
    }
    
    /// Resumes the game
    func resume() {
        view?.paused = false
    }
    
    /// Returns the current distance that the car has traveled
    func currentDistance() -> Int {
        return 0 // TODO: update this with real data
    }
}
