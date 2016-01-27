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
        backgroundColor = SKColor.blackColor()
        
        gameManager = GameManager(delegate: self, gameBounds: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        
        let spike = SpikeNode(position: CGPoint(x: view.bounds.width, y: 93), color: SVColor.orangeColor(), resourceSize: CGSizeZero)
        addChild(spike)
        
        let rectangle = RectangleNode(position: CGPoint(x: view.bounds.width, y: 30), color: SVColor.orangeColor(), resourceSize: CGSize(width: 30, height: 100))
        addChild(rectangle)
        
        
        let newCamera = SKCameraNode()
        newCamera.position = CGPoint(x: view.bounds.width/2, y: view.bounds.height/2)
        let action = SKAction.moveTo(CGPoint(x: 2 * view.bounds.width + newCamera.position.x, y: newCamera.position.y + 80), duration: 6.0)
        newCamera.runAction(action)
        newCamera.xScale = view.bounds.width / size.width
        newCamera.yScale = view.bounds.height / size.height
        camera = newCamera
        addChild(newCamera)
        
        
        car.switchDirection(CarDirection.Right)
        car.position = CGPoint(x: 90, y: 70)
        car.physicsBody?.affectedByGravity = false
        let caraction = SKAction.moveTo(CGPoint(x: 2 * view.bounds.width + car.position.x, y: car.position.y + 80), duration: 6.0)
        car.runAction(caraction)
        self.addChild(car)
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
        gameManager.update(currentTime)
    }
}

extension GameScene : GameManagerDelegate {
    func placeResource(resource: SKNode) {
        addChild(resource)
    }
    
    func removeResource(resource: SKNode) {
        resource.removeFromParent()
    }
    
    func scoreChanged(newScore: Int) {
        
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
