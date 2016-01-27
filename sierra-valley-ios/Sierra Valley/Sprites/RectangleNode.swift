//
//  RectangleNode.swift
//  Sierra Valley
//
//  Created by Jack Arendt on 1/24/16.
//  Copyright © 2016 John Arendt. All rights reserved.
//

import SpriteKit

class RectangleNode: SKSpriteNode, LevelResourceProtocol {
    required init(position: CGPoint, color: UIColor, resourceSize: CGSize) {
        super.init(texture: nil, color: color, size: resourceSize)
        
        self.position = position
        
        physicsBody = SKPhysicsBody(rectangleOfSize: resourceSize)
        physicsBody?.dynamic = true
        physicsBody?.affectedByGravity = false
        physicsBody?.allowsRotation = false
        physicsBody?.categoryBitMask = CollisionBitmaskCategory.Rectangle
        physicsBody?.collisionBitMask = 0
        name = SVSpriteName.Rectangle.rawValue
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
