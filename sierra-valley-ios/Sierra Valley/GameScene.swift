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
    
    override func didMoveToView(view: SKView) {
        super.didMoveToView(view)
        view.allowsTransparency = true
        backgroundColor = SKColor.clearColor()
        
        let spike = SpikeNode(position: CGPoint(x: -15, y: 13), spikeColor: SVColor.orangeColor())
        let slideAction = SKAction.moveToX(view.bounds.width, duration: 3.0)
        spike.runAction(slideAction)
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
        enumerateChildNodesWithName(SVSpriteName.Spike.rawValue) { (node, stop) -> Void in
            if node.position.x == self.view?.bounds.width {
                node.position = CGPoint(x: -15, y: 13)
                let slideAction = SKAction.moveToX(self.view!.bounds.width, duration: 3.0)
                node.runAction(slideAction)
            }
        }
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
