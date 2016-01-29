//
//  CarNode.swift
//  Sierra Valley
//
//  Created by Jack Arendt on 1/23/16.
//  Copyright © 2016 John Arendt. All rights reserved.
//

import SpriteKit

enum CarDirection {
    case Left
    case Right
}

/// The CarNode contains all of the business logic associated with driving the car
final class CarNode: SKSpriteNode {
    
    /// The current car that is being presented
    var car : SVCar?
    
    /// The direction that the car is heading
    var direction : CarDirection = .Left
    
    private var inAir = false
    
    init(car : SVCar) {
        self.car = car
        let texture = SKTexture(imageNamed: car.rawValue)
        super.init(texture: texture, color: UIColor.whiteColor(), size: texture.size())
        
        name = SVSpriteName.Car.rawValue
        
        physicsBody = SKPhysicsBody(rectangleOfSize: size)
        physicsBody?.dynamic = true
        physicsBody?.allowsRotation = true
        physicsBody?.restitution = 0
        
        physicsBody?.categoryBitMask = CollisionBitmaskCategory.Car
        setContactBitmask([CollisionBitmaskCategory.Spike, CollisionBitmaskCategory.Rectangle])
        setCollisionBitmask([CollisionBitmaskCategory.Spike, CollisionBitmaskCategory.Rectangle])
    }
    
    required init?(coder aDecoder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
    }
    
    func setCollisionBitmask(collisions : [UInt32]) {
        var bitmask : UInt32 = 0
        for c in collisions {
            bitmask = bitmask | c
        }
        physicsBody?.collisionBitMask = bitmask
    }
    
    func setContactBitmask(contacts : [UInt32]) {
        var bitmask : UInt32 = 0
        for c in contacts {
            bitmask = bitmask | c
        }
        physicsBody?.contactTestBitMask = bitmask
    }
    
    func jump() {
        if inAir {
            return
        }
//        let offset = direction == .Left ? size.width * -1/80 : size.width * 1/80
        physicsBody?.applyImpulse(CGVector(dx: 0, dy: 600), atPoint: CGPoint(x: position.x /*+ offset*/, y: position.y))
        inAir = true
    }
    
    func switchDirection(newDirection : CarDirection) {
        if direction != newDirection {
            direction = newDirection
            xScale = xScale * -1
        }
    }
    
    func endJump() {
        inAir = false
    }
}
