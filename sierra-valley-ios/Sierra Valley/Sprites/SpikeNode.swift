//
//  SpikeNode.swift
//  Sierra Valley
//
//  Created by Jack Arendt on 1/24/16.
//  Copyright © 2016 John Arendt. All rights reserved.
//

import SpriteKit

/// The triangle node is subclass of SKSpriteNode that renders a spike on the level.  It is the main objective for the
/// car to avoid.  The SpikeNode also adheres to the LevelResourceProtocol which allows it to be used interchangably
/// with other level resource nodes.
final public class SpikeNode: SKSpriteNode, LevelResourceProtocol  {
    required public init(position : CGPoint, color : UIColor, resourceSize: CGSize) {
        super.init(texture: spikeTexture, color: color, size: spikeTexture.size())
        name = SVSpriteName.Spike.rawValue
        
        self.position = position
        
        let path = UIBezierPath()
        path.moveToPoint(CGPoint(x: -size.width/2, y: -size.height/2))
        path.addLineToPoint(CGPoint(x: size.width/2, y: -size.height/2))
        path.addLineToPoint(CGPoint(x: 0, y: size.height/2))
        path.closePath()
        
        physicsBody = SKPhysicsBody(polygonFromPath: path.CGPath)
        physicsBody?.dynamic = true
        physicsBody?.affectedByGravity = false
        physicsBody?.allowsRotation = true
        physicsBody?.categoryBitMask = CollisionBitmaskCategory.Spike
        physicsBody?.collisionBitMask = 0

        colorBlendFactor = 1.0
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
