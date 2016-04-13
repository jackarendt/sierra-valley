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
    public var maximumImpulseValue : CGFloat = 165
    
    /// The current impulse value for jumping
    private var impulse : CGFloat = 0
    
    /// boolean denoting whether the car is currently jumping or not
    private var isJumping = false
    
    /// boolean denoting whether the car is able to jump or not
    private var jumpAvailable = true

    
    /// Initializes a new car object using the name of a car.  The initializer will then create
    /// the texture for that car, and a physics body that appropriately fits the texture.
    /// - Parameter car: The type of car to be driven
    public init(car : SVCar) {
        self.car = car
        let texture = SKTexture(imageNamed: car.rawValue)
        super.init(texture: texture, color: SVColor.lightColor(), size: texture.size())
        
        impulse = maximumImpulseValue
        
        // car initially faces left, need it to face right.
        xScale *= -1
        
        // set the name of the car
        name = SVSpriteName.Car.rawValue
        
        // create physics body for car
        physicsBody = SKPhysicsBody(rectangleOfSize: CGSize(width: size.width * 0.9, height: size.height))
        physicsBody?.dynamic = true
        physicsBody?.allowsRotation = true
        physicsBody?.restitution = 0
        physicsBody?.collisionBitMask = 0
        
        // set default collision and contact bitmasks
        physicsBody?.categoryBitMask = CollisionBitmaskCategory.Car
        
        setCollisionBitmask([CollisionBitmaskCategory.Spike, CollisionBitmaskCategory.Rectangle, CollisionBitmaskCategory.Triangle])
        setContactBitmask([CollisionBitmaskCategory.Spike, CollisionBitmaskCategory.Rectangle, CollisionBitmaskCategory.Triangle])
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
    
    // MARK: - Car Actions
    
    /// Causes the car to jump up by the set impulse amount
    public func jump() {
        if jumpAvailable {
            physicsBody?.applyImpulse(CGVector(dx: 0, dy: impulse), atPoint: position)
            impulse /= 4
            isJumping = true
        }
    }
    
    /// Denotes that the user has stopped trying to make the car jump (stopped pressing)
    public func stopJump() {
        isJumping = false
    }
    
    /// Call this to end the jump. This denotes that the user has collided back with the ground
    /// and it will reset the impulse value and determine if the user is able to jump again
    public func endJump() {
        let motionDY = GameSettings.sharedSettings.triangleHeight * 2
        if isJumping && physicsBody?.velocity.dy < motionDY { // trying to jump, but on the ground
            jumpAvailable = false
        } else if isJumping && physicsBody?.velocity.dy >= motionDY {
            // jumped, but has a weird collision, continue jumping but don't reset
            jumpAvailable = true
        } else { // if the car is not jumping and is on the ground
            jumpAvailable = true
            isJumping = false
            impulse = maximumImpulseValue
        }
    }
    
    /// This will switch the car direction based on the new direction.  If the direction has not changed,
    /// the car will not do anything
    /// - Parameter newDirection: The new direction that the car will face
    public func switchDirection(newDirection : CarDirection) {
        if direction != newDirection {
            direction = newDirection
            xScale *= -1 // causes a vertical flip in scale
        }
    }
}
