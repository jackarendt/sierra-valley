//
//  StarBackgroundManager.swift
//  Sierra Valley
//
//  Created by Jack Arendt on 2/21/16.
//  Copyright © 2016 John Arendt. All rights reserved.
//

import SpriteKit

class StarBackgroundManager : GameActionQueueProtocol {
    
    let starEmitter = SKEmitterNode(fileNamed: "StarParticle.sks")
    
    let rightShootingStar = SKEmitterNode(fileNamed: "ShootingStarParticle.sks")
    let leftShootingStar = SKEmitterNode(fileNamed: "ShootingStarParticle.sks")
    
    let starNode = SKNode()
    
    
    var queue = Queue<SKAction>()
    
    var node : SKNode {
        get {
            return starNode
        }
    }
    
    var zPosition : CGFloat = 0 {
        didSet {
            starEmitter?.zPosition = zPosition
            rightShootingStar?.zPosition = zPosition
            leftShootingStar?.zPosition = zPosition
        }
    }
    
    init(position : CGPoint, scene : SKScene) {
        starEmitter?.position = position
        if let starEmitter = starEmitter {
            starNode.addChild(starEmitter)
        }
        rightShootingStar?.position = CGPoint(x: position.x - UIScreen.mainScreen().bounds.width/2, y: position.y)
        if let shootingStarEmitter = rightShootingStar {
            starNode.addChild(shootingStarEmitter)
        }
        
        leftShootingStar?.position = CGPoint(x: position.x + UIScreen.mainScreen().bounds.width/2, y: position.y)
        leftShootingStar?.xScale *= -1
        if let shootingStarEmitter = leftShootingStar {
            starNode.addChild(shootingStarEmitter)
        }
        scene.addChild(starNode)
    }
    
    func enqueueGameAction(width: CGFloat, height: CGFloat, time: CFTimeInterval) {
        enqueueDefaultGameAction(width, height: height, time: time)
    }
}
