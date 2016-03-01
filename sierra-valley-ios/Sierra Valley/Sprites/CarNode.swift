//
//  CarNode.swift
//  Sierra Valley
//
//  Created by Jack Arendt on 1/23/16.
//  Copyright © 2016 John Arendt. All rights reserved.
//

import SpriteKit

/// The CarNode contains all of the business logic associated with driving the car.
/// It allows for a user to change directions and jump.
final public class CarNode: SKSpriteNode {
    
    /// The current car that is being presented
    public var car : SVCar?
    
    /// The direction that the car is heading
    public var direction : CarDirection = .Right
    
    /// The dy of the impulse vector that causes the car to jump
    public var impulse : CGFloat = 140
    
    /// The current impulse value for jumping
    private var currentImpulse : CGFloat = 0
    
    /// boolean denoting whether the car is currently jumping or not
    private var inAir = false
    
    /// boolean denoting whether the car has double jumped (or super jumped)
    private var doubleJumped = false
    
    /// Initializes a new car object using the name of a car.  The initializer will then create
    /// the texture for that car, and a physics body that appropriately fits the texture.
    /// - Parameter car: The type of car to be driven
    public init(car : SVCar) {
        self.car = car
        let texture = SKTexture(imageNamed: car.rawValue)
        super.init(texture: texture, color: SVColor.lightColor(), size: texture.size())
        
        currentImpulse = impulse
        
        // shrink slightly
        xScale = 0.9
        yScale = 0.9
        
        // car initially faces left, need it to face right.
        xScale *= -1
        
        // set the name of the car
        name = SVSpriteName.Car.rawValue
        
        // create physics body for car
        physicsBody = SKPhysicsBody(rectangleOfSize: size)
        physicsBody?.dynamic = true
        physicsBody?.allowsRotation = true
        physicsBody?.restitution = 0
        physicsBody?.collisionBitMask = 0
        
        // set default collision and contact bitmasks
        physicsBody?.categoryBitMask = CollisionBitmaskCategory.Car
        
        setCollisionBitmask([CollisionBitmaskCategory.Spike, CollisionBitmaskCategory.Rectangle, CollisionBitmaskCategory.Triangle])
        setContactBitmask([CollisionBitmaskCategory.Spike, CollisionBitmaskCategory.Rectangle, CollisionBitmaskCategory.Triangle])
        
        print(physicsBody?.collisionBitMask)
    }
    
    required public init?(coder aDecoder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
    }
    
    /// Sets the car's collision bitmask in a more concise way
    /// - Parameter collisions: The array of object types that the car will collide with
    public func setCollisionBitmask(collisions : [UInt32]) {
        var bitmask : UInt32 = 0
        for c in collisions {
            bitmask = bitmask | c
        }
        physicsBody?.collisionBitMask = bitmask
    }
    
    /// Sets the car's contact bitmask in a more concise way.  The contact bitmask
    /// is what will trigger didBeginContact.
    /// - Parameter contacts: The array of object types that the car will make contact with
    /// - SeeAlso: SKPhysicsContactDelegate
    public func setContactBitmask(contacts : [UInt32]) {
        var bitmask : UInt32 = 0
        for c in contacts {
            bitmask = bitmask | c
        }
        physicsBody?.contactTestBitMask = bitmask
    }
    
    /// Causes the car to jump up by the set impulse amount
    /// - Note: The car can double jump
    public func jump() {
        physicsBody?.applyImpulse(CGVector(dx: 0, dy: currentImpulse), atPoint: position)
        currentImpulse /= 2 // shrink it in half for each jump
    }
    
    /// This will switch the car direction based on the new direction.  If the direction has not changed,
    /// the car will not do anything
    /// - Parameter newDirection: The new direction that the car will face
    public func switchDirection(newDirection : CarDirection) {
        if direction != newDirection {
            direction = newDirection
            xScale *= -1 // causes a vertical flip
            // TODO: move car
        }
    }
    
    /// Call this to end the jump.  This will reset the flags so the user can jump again
    public func endJump() {
        inAir = false
        doubleJumped = false
        currentImpulse = impulse
    }
}
