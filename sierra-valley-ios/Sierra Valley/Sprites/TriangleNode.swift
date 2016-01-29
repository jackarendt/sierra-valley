//
//  TriangleNode.swift
//  Sierra Valley
//
//  Created by Jack Arendt on 1/27/16.
//  Copyright © 2016 John Arendt. All rights reserved.
//

import SpriteKit

final class TriangleNode: SKSpriteNode, LevelResourceProtocol {
    required init(position: CGPoint, color: UIColor, resourceSize: CGSize) {
        super.init(texture: triangleTexture, color: color, size: resourceSize)
        
        self.position = position
        
        physicsBody = SKPhysicsBody(rectangleOfSize: resourceSize)
        physicsBody?.dynamic = true
        physicsBody?.affectedByGravity = false
        physicsBody?.allowsRotation = false
        physicsBody?.categoryBitMask = CollisionBitmaskCategory.Triangle
        physicsBody?.collisionBitMask = 0
        name = SVSpriteName.Triangle.rawValue
        
        blendMode = SKBlendMode.Replace
        colorBlendFactor = 1.0
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
