//
//  HelpCarScene.swift
//  Sierra Valley
//
//  Created by Jack Arendt on 1/22/16.
//  Copyright © 2016 John Arendt. All rights reserved.
//

import SpriteKit

class HelpCarScene: SVBaseScene {
    
    let car = CarNode(car: .SierraTurboLarge)
    
    override func didMoveToView(view: SKView) {
        super.didMoveToView(view)
        view.allowsTransparency = true
        backgroundColor = SKColor.clearColor()
        
        // add car to scene
        car.position = CGPoint(x: view.bounds.width/2, y: car.size.height/2 + 10)
        car.setCollisionBitmask([.Floor])
        self.addChild(car)
        
        let floorNode = SKSpriteNode(color: UIColor.clearColor(), size: CGSize(width: view.bounds.width, height: 10))
        floorNode.position = CGPoint(x: view.bounds.width/2, y: 5)
        floorNode.physicsBody = SKPhysicsBody(rectangleOfSize: floorNode.size)
        floorNode.physicsBody?.categoryBitMask = CollisionBitmaskCategory.Floor.rawValue
        floorNode.physicsBody?.dynamic = false
        floorNode.physicsBody?.collisionBitMask = CollisionBitmaskCategory.Car.rawValue
        floorNode.physicsBody?.contactTestBitMask = CollisionBitmaskCategory.Car.rawValue
        self.addChild(floorNode)
    }
    
    override func tapGestureRecognized(tap: UITapGestureRecognizer) {
        car.jump()
    }
    
    override func swipeLeftGestureRecognized(swipeLeft: UISwipeGestureRecognizer) {
        car.switchDirection(.Left)
    }
    
    override func swipeRightGestureRecognized(swipeRight: UISwipeGestureRecognizer) {
        car.switchDirection(.Right)
    }
    
    override func didBeginContact(contact: SKPhysicsContact) {
        car.endJump()
    }
}
