//
//  TriangleNode.swift
//  Sierra Valley
//
//  Created by Jack Arendt on 1/27/16.
//  Copyright © 2016 John Arendt. All rights reserved.
//

import SpriteKit

/// The TriangleNode is a sublcass of SKSpriteNode that renders a right triangle on the screen.  The main objective
/// of the triangle node is to smooth out the path between rectangles.  So instead of going up stairs, it's like going
/// up a buttery smooth walkway.  TriangleNode also adheres to the LevelResourceProtocol which allows it to be used
/// interchangably with other level resources
final public class TriangleNode: SKSpriteNode, LevelResourceProtocol {
    
    
    override public var size : CGSize {
        didSet {
            let path = UIBezierPath()
            path.moveToPoint(CGPoint(x: -size.width/2, y: -size.height/2))
            path.addLineToPoint(CGPoint(x: size.width/2, y: -size.height/2))
            path.addLineToPoint(CGPoint(x: size.width/2, y: size.height/2))
            path.closePath()
            
            // create physics body
            physicsBody = SKPhysicsBody(polygonFromPath: path.CGPath)
            physicsBody?.dynamic = true
            physicsBody?.affectedByGravity = false // not affected by gravity
            physicsBody?.allowsRotation = false
            physicsBody?.categoryBitMask = CollisionBitmaskCategory.Triangle
            physicsBody?.collisionBitMask = 0 // doesn't collide with anything
            name = SVSpriteName.Triangle.rawValue
        }
    }
    
    required public init(position: CGPoint, color: UIColor, resourceSize: CGSize) {
        super.init(texture: triangleTexture, color: color, size: triangleTexture.size())
        self.position = position
        
        let path = UIBezierPath()
        path.moveToPoint(CGPoint(x: -size.width/2, y: -size.height/2))
        path.addLineToPoint(CGPoint(x: size.width/2, y: -size.height/2))
        path.addLineToPoint(CGPoint(x: size.width/2, y: size.height/2))
        path.closePath()
        
        // create physics body
        physicsBody = SKPhysicsBody(polygonFromPath: path.CGPath)
        physicsBody?.dynamic = true
        physicsBody?.affectedByGravity = false // not affected by gravity
        physicsBody?.allowsRotation = false
        physicsBody?.categoryBitMask = CollisionBitmaskCategory.Triangle
        physicsBody?.collisionBitMask = 0 // doesn't collide with anything
        name = SVSpriteName.Triangle.rawValue
        
        // set the blend mode to replace for increased drawing performance, and allow it to be recolored
        colorBlendFactor = 1.0
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
