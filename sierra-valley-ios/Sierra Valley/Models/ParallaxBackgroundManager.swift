//
//  ParallaxBackgroundManager.swift
//  Sierra Valley
//
//  Created by Jack Arendt on 2/11/16.
//  Copyright © 2016 John Arendt. All rights reserved.
//

import SpriteKit


class ParallaxBackgroundManager {
    let gameSettings = GameSettings()
    
    weak var scene : SKScene?
    
    /// The camera queue is used for when a level is generated and that action needs to be stored
    private let backgroundActionQueue = Queue<SKAction>()
    
    let middleBackground = SKSpriteNode(imageNamed: SVLevelResource.DarkParallaxBackground.rawValue)
    let leftBackground = SKSpriteNode(imageNamed: SVLevelResource.LightParallaxBackground.rawValue)
    let rightBackground = SKSpriteNode(imageNamed: SVLevelResource.LightParallaxBackground.rawValue)
    let farLeftBackground = SKSpriteNode(imageNamed: SVLevelResource.DarkParallaxBackground.rawValue)
    let farRightBackground = SKSpriteNode(imageNamed: SVLevelResource.DarkParallaxBackground.rawValue)
    
    let backgroundNode = SKNode()
    
    init(scene : SKScene) {
        self.scene = scene
        
        
        
        middleBackground.alpha = 0.65
        middleBackground.zPosition = -3
        middleBackground.position = CGPoint(x: gameSettings.actualWidth/2, y: UIScreen.mainScreen().bounds.height/2 - 75)
        backgroundNode.addChild(middleBackground)
        
        leftBackground.alpha = 0.85
        leftBackground.zPosition = -2
        leftBackground.position = CGPoint(x: gameSettings.actualWidth/4, y: UIScreen.mainScreen().bounds.height/2 - 175)
        backgroundNode.addChild(leftBackground)
        
        rightBackground.alpha = 0.85
        rightBackground.zPosition = -2
        rightBackground.position = CGPoint(x: 3*gameSettings.actualWidth/4, y: UIScreen.mainScreen().bounds.height/2 - 175)
        backgroundNode.addChild(rightBackground)
        
        
//        let farYPos = CGFloat(gameSettings.framesToTop) * gameSettings.triangleHeight + gameSettings.minMountainHeight
        
        farLeftBackground.alpha = 0.9
        farLeftBackground.zPosition = -1
        farLeftBackground.position = CGPoint(x: gameSettings.actualWidth * 0.1, y: UIScreen.mainScreen().bounds.height/2 - 225)
        backgroundNode.addChild(farLeftBackground)
        
        farRightBackground.alpha = 0.9
        farRightBackground.zPosition = -1
        farRightBackground.position = CGPoint(x: gameSettings.actualWidth * 0.9, y: UIScreen.mainScreen().bounds.height/2 - 225)
        backgroundNode.addChild(farRightBackground)
        
        scene.addChild(backgroundNode)
        
    }
}

extension ParallaxBackgroundManager : GameActionQueueProtocol {
    func enqueueGameAction(width: CGFloat, height: CGFloat, time: CFTimeInterval) {
        let action = SKAction.moveBy(CGVector(dx: width, dy: height), duration: time)
        let completionAction = SKAction.runBlock({ // when the camera is done executing, automatically start the next one
            self.backgroundMovementFinished()
        })
        let sequence = SKAction.sequence([action, completionAction])
        backgroundActionQueue.enqueue(sequence) // add the action to the queue
    
        // if the camera is still and doesn't have any actions, run the first available action
        if backgroundActionQueue.count == 1 && backgroundNode.hasActions() == false {
            dequeueAndRunBackgroundAction()
        }
    }


    // MARK: Helper methods for GameActionQueue
    
    /// Dequeues a camera action and then applies it to the camera
    private func dequeueAndRunBackgroundAction() {
        if let action = backgroundActionQueue.dequeue() {
            backgroundNode.runAction(action)
        }
    }
    
    /// Invoked when the camera action has finished
    func backgroundMovementFinished() {
        dequeueAndRunBackgroundAction()
    }
}