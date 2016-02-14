//
//  ParallaxBackgroundNode.swift
//  Sierra Valley
//
//  Created by Jack Arendt on 2/14/16.
//  Copyright © 2016 John Arendt. All rights reserved.
//

import SpriteKit

class ParallaxBackgroundNode: SKNode, GameActionQueueProtocol {
    
    var queue = Queue<SKAction>()
    
    var gameSettings = GameSettings()
    
    var node : SKNode {
        get {
            return self
        }
    }
    
    private let middleBackground = SKSpriteNode(imageNamed: SVLevelResource.DarkParallaxBackground.rawValue)
    private let leftBackground = SKSpriteNode(imageNamed: SVLevelResource.LightParallaxBackground.rawValue)
    private let rightBackground = SKSpriteNode(imageNamed: SVLevelResource.LightParallaxBackground.rawValue)
    private let farLeftBackground = SKSpriteNode(imageNamed: SVLevelResource.DarkParallaxBackground.rawValue)
    private let farRightBackground = SKSpriteNode(imageNamed: SVLevelResource.DarkParallaxBackground.rawValue)
    
    override init() {
        super.init()
        middleBackground.alpha = 0.65
        middleBackground.zPosition = -3
        middleBackground.position = CGPoint(x: gameSettings.actualWidth/2, y: UIScreen.mainScreen().bounds.height/2 - 75)
        addChild(middleBackground)
        
        leftBackground.alpha = 0.85
        leftBackground.zPosition = -2
        leftBackground.position = CGPoint(x: gameSettings.actualWidth/4, y: UIScreen.mainScreen().bounds.height/2 - 175)
        addChild(leftBackground)
        
        rightBackground.alpha = 0.85
        rightBackground.zPosition = -2
        rightBackground.position = CGPoint(x: 3*gameSettings.actualWidth/4, y: UIScreen.mainScreen().bounds.height/2 - 175)
        addChild(rightBackground)
        
        
        //        let farYPos = CGFloat(gameSettings.framesToTop) * gameSettings.triangleHeight + gameSettings.minMountainHeight
        
        farLeftBackground.alpha = 0.9
        farLeftBackground.zPosition = -1
        farLeftBackground.position = CGPoint(x: gameSettings.actualWidth * 0.1, y: UIScreen.mainScreen().bounds.height/2 - 225)
        addChild(farLeftBackground)
        
        farRightBackground.alpha = 0.9
        farRightBackground.zPosition = -1
        farRightBackground.position = CGPoint(x: gameSettings.actualWidth * 0.9, y: UIScreen.mainScreen().bounds.height/2 - 225)
        addChild(farRightBackground)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func enqueueGameAction(width: CGFloat, height: CGFloat, time: CFTimeInterval) {
        enqueueDefaultGameAction(width, height: height, time: time)
    }
}
