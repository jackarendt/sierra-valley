//
//  SpikeNode.swift
//  Sierra Valley
//
//  Created by Jack Arendt on 1/24/16.
//  Copyright © 2016 John Arendt. All rights reserved.
//

import SpriteKit

class SpikeNode: SKSpriteNode {
    init(position : CGPoint, spikeColor : UIColor) {
        let texture = SKTextureAtlas(named: levelTextureAtlas).textureNamed(SVLevelResource.Spike.rawValue)
        super.init(texture: texture, color: spikeColor, size: texture.size())
        
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
        physicsBody?.categoryBitMask = CollisionBitmaskCategory.Spike.rawValue
        physicsBody?.contactTestBitMask = CollisionBitmaskCategory.Car.rawValue
        
        color = spikeColor
        colorBlendFactor = 1.0
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
