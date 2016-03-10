//
//  HelpCarScene.swift
//  Sierra Valley
//
//  Created by Jack Arendt on 1/22/16.
//  Copyright © 2016 John Arendt. All rights reserved.
//

import SpriteKit

/// HelpCarScene is a subclass of SVBaseScene that handles teaching the user about how the controls of the game work.
/// This is a demo scene where they can master the basic controls of the game
final class HelpCarScene: SVBaseScene {
    
    /// CarNode that shows the sierra turbo in large format
    private let car = CarNode(car: .SierraTurboLarge)
    
    override func didMoveToView(view: SKView) {
        super.didMoveToView(view)
        
        gestureDelegate = self
        // add car to scene
        car.position = CGPoint(x: view.bounds.width/2, y: car.size.height/2 + 10)
        car.maximumImpulseValue = 900
        addChild(car)
        
        // Create a "floor" that is clear below the car so that the car can rest on it easily.
        let floorNode = SKSpriteNode(color: UIColor.clearColor(), size: CGSize(width: view.bounds.width, height: 10))
        floorNode.position = CGPoint(x: view.bounds.width/2, y: 5)
        
        // create floor's physics body
        floorNode.physicsBody = SKPhysicsBody(rectangleOfSize: floorNode.size)
        floorNode.physicsBody?.categoryBitMask = CollisionBitmaskCategory.Rectangle
        floorNode.physicsBody?.dynamic = false
        floorNode.physicsBody?.collisionBitMask = CollisionBitmaskCategory.Car
        floorNode.physicsBody?.contactTestBitMask = CollisionBitmaskCategory.Car
        
        // add floor to the scene
        addChild(floorNode)
    }
    
    override func didBeginContact(contact: SKPhysicsContact) {
        car.endJump() // when the car comes back down to the floor, reset so it can jump again
    }
}

extension HelpCarScene : SceneGestureDelegate {
    func jump() {
        car.jump()
    }
    
    func endJump() {
        car.stopJump()
    }
    
    func swipeLeft() {
        car.switchDirection(.Left)
    }
    
    func swipeRight() {
        car.switchDirection(.Right)
    }
}
