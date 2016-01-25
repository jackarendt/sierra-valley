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
    
    override func didMoveToView(view: SKView) {
        super.didMoveToView(view)
        view.allowsTransparency = true
        backgroundColor = SKColor.clearColor()
        
        let spike = SpikeNode(position: CGPoint(x: view.bounds.width + 15, y: 92), color: SVColor.orangeColor(), resourceSize: CGSize(width: 30, height: 80))
        let slideAction = SKAction.moveTo(CGPoint(x: -15, y: 52), duration: 3.0)
        spike.runAction(slideAction)
        
        let rectangle = RectangleNode(position: CGPoint(x: view.bounds.width + 15, y: 40), color: SVColor.orangeColor(), resourceSize: CGSize(width: 30, height: 80))
        let rectSlideAction = SKAction.moveTo(CGPoint(x: -15, y: 0), duration: 3.0)
        rectangle.runAction(rectSlideAction)
        addChild(rectangle)
        addChild(spike)
    }
    
    override func tapGestureRecognized(tap: UITapGestureRecognizer) {
        // replace this eventually
        let location = tap.locationInView(view!)
        let car = CarNode(car: .SierraTurbo)
        car.position = CGPoint(x: location.x, y: view!.bounds.height - location.y)
        car.physicsBody?.affectedByGravity = false
        self.addChild(car)
    }
   
    override func update(currentTime: CFTimeInterval) {
        enumerateChildNodesWithName(SVSpriteName.Rectangle.rawValue) { (node, stop) -> Void in
            if node.position.x <= -15 {
                node.position = CGPoint(x: self.view!.bounds.width + 15, y: 40)
                let slideAction = SKAction.moveTo(CGPoint(x: -15, y: 0), duration: 3.0)
                node.runAction(slideAction)
            }
        }
        
        enumerateChildNodesWithName(SVSpriteName.Spike.rawValue, usingBlock: { (node, stop) -> Void in
            if node.position.x <= -15 {
                node.position = CGPoint(x: self.view!.bounds.width + 15, y: 92)
                let slideAction = SKAction.moveTo(CGPoint(x: -15, y: 52), duration: 3.0)
                node.runAction(slideAction)
            }
        })
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
