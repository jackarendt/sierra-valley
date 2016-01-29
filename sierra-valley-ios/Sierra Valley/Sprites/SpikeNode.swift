//
//  SpikeNode.swift
//  Sierra Valley
//
//  Created by Jack Arendt on 1/24/16.
//  Copyright © 2016 John Arendt. All rights reserved.
//

import SpriteKit

final class SpikeNode: SKSpriteNode, LevelResourceProtocol  {
    required init(position : CGPoint, color : UIColor, resourceSize: CGSize) {
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
        blendMode = SKBlendMode.Replace
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
