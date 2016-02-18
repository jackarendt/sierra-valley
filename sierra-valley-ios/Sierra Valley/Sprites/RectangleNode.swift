//
//  RectangleNode.swift
//  Sierra Valley
//
//  Created by Jack Arendt on 1/24/16.
//  Copyright © 2016 John Arendt. All rights reserved.
//

import SpriteKit

/// The rectangle node is subclass of SKSpriteNode that renders a rectangle on the level.  It is the main building block
/// to build a row on screen.  The RectangleNode also adheres to the LevelResourceProtocol which allows it to be used
///interchangably with other level resource nodes.
final public class RectangleNode: SKSpriteNode, LevelResourceProtocol {
    
    var categoryBitMask : UInt32 = CollisionBitmaskCategory.Rectangle {
        didSet {
            physicsBody?.categoryBitMask = categoryBitMask
        }
    }
    
    override public var size : CGSize {
        didSet {
            if size != CGSizeZero {
                physicsBody = SKPhysicsBody(rectangleOfSize: size)
                physicsBody?.categoryBitMask = categoryBitMask
                physicsBody?.dynamic = false
                physicsBody?.collisionBitMask = CollisionBitmaskCategory.Car
                physicsBody?.contactTestBitMask = CollisionBitmaskCategory.Car
            }
        }
    }
    
    
    required public init(position: CGPoint, color: UIColor, resourceSize: CGSize) {
        super.init(texture: rectangleTexture, color: color, size: resourceSize)
        
        self.position = position
        physicsBody = SKPhysicsBody(rectangleOfSize: resourceSize)
        physicsBody?.categoryBitMask = categoryBitMask
        physicsBody?.dynamic = false
        physicsBody?.collisionBitMask = CollisionBitmaskCategory.Car
        physicsBody?.contactTestBitMask = CollisionBitmaskCategory.Car
        
        name = SVSpriteName.Rectangle.rawValue
        
        zPosition = 100
        
        colorBlendFactor = 1.0
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
