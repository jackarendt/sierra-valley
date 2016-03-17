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
    
    var gameSettings = GameSettings.sharedSettings
    
    let colorBlendFactor : CGFloat = 1.0
    
    var avalancheActive = false {
        didSet {
            let time = 1.25
            if avalancheActive  {
                startAvalanche(time)
            } else {
                endAvalanche(time)
            }
        }
    }
    
    var node : SKNode {
        get {
            return self
        }
    }
    
    private let lightTexture = SKTexture(imageNamed: SVLevelResource.LightParallaxBackground.rawValue)
    private let darkTexture = SKTexture(imageNamed: SVLevelResource.DarkParallaxBackground.rawValue)
    private let avalancheTexture = SKTexture(imageNamed: SVLevelResource.AvalancheParallaxBackground.rawValue)
    
    private let middleBackground = SKSpriteNode(imageNamed: SVLevelResource.AvalancheParallaxBackground.rawValue)
    private let leftBackground = SKSpriteNode(imageNamed: SVLevelResource.AvalancheParallaxBackground.rawValue)
    private let rightBackground = SKSpriteNode(imageNamed: SVLevelResource.AvalancheParallaxBackground.rawValue)
    private let farLeftBackground = SKSpriteNode(imageNamed: SVLevelResource.AvalancheParallaxBackground.rawValue)
    private let farRightBackground = SKSpriteNode(imageNamed: SVLevelResource.AvalancheParallaxBackground.rawValue)
    
    override init() {
        super.init()
        
        middleBackground.alpha = 0.75
        middleBackground.zPosition = -3
        middleBackground.position = CGPoint(x: position.x, y: position.y - 75)
        middleBackground.colorBlendFactor = colorBlendFactor
        addChild(middleBackground)
        
        leftBackground.alpha = 0.85
        leftBackground.zPosition = -2
        leftBackground.position = CGPoint(x: position.x - gameSettings.actualWidth/4, y: position.y - 175)
        leftBackground.colorBlendFactor = colorBlendFactor
        addChild(leftBackground)
        
        rightBackground.alpha = 0.85
        rightBackground.zPosition = -2
        rightBackground.position = CGPoint(x: position.x + gameSettings.actualWidth/4, y: position.y - 175)
        rightBackground.colorBlendFactor = colorBlendFactor
        addChild(rightBackground)
        
        farLeftBackground.alpha = 0.9
        farLeftBackground.zPosition = -1
        farLeftBackground.position = CGPoint(x: position.x - gameSettings.actualWidth * 0.4, y: position.y - 125)
        farLeftBackground.colorBlendFactor = colorBlendFactor
        addChild(farLeftBackground)
        
        farRightBackground.alpha = 0.9
        farRightBackground.zPosition = -1
        farRightBackground.position = CGPoint(x: position.x + gameSettings.actualWidth * 0.4, y: position.y - 125)
        farRightBackground.colorBlendFactor = colorBlendFactor
        addChild(farRightBackground)
        
        endAvalanche(0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func endAvalanche(time : NSTimeInterval) {
        for n in [middleBackground, leftBackground, farLeftBackground, rightBackground, farRightBackground].enumerate() {
            if n.index % 2 == 0 {
                n.element.runAction(SKAction.colorizeWithColor(SVColor.backgroundPrimaryColor(), colorBlendFactor: colorBlendFactor, duration: time))
            } else {
                n.element.runAction(SKAction.colorizeWithColor(SVColor.backgroundSecondaryColor(), colorBlendFactor: colorBlendFactor, duration: time))
            }
        }
    }
    
    private func startAvalanche(time : NSTimeInterval) {
        let avalancheColorAction = SKAction.colorizeWithColor(SVColor.avalancheColor(), colorBlendFactor: colorBlendFactor, duration: time)
        for n in [middleBackground, leftBackground, rightBackground, farLeftBackground, farRightBackground] {
            n.runAction(avalancheColorAction)
        }
    }
    
    func enqueueGameAction(width: CGFloat, height: CGFloat, time: CFTimeInterval) {
        enqueueDefaultGameAction(width, height: height, time: time)
    }
}
