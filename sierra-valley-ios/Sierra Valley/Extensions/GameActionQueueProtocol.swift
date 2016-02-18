//
//  GameActionProtocol.swift
//  Sierra Valley
//
//  Created by Jack Arendt on 2/11/16.
//  Copyright © 2016 John Arendt. All rights reserved.
//

import SpriteKit

/// The GameActionQueueProtocol contains a set of methods that standardize the behavior of moving
/// pieces in the background
protocol GameActionQueueProtocol {
    /// Adds an action to the game action queue
    /// - Parameter width: The width that the node needs to pan
    /// - Parameter height: The height that the node needs to pan
    /// - Parameter time: The time it takes to pan the node to the end point
    func enqueueGameAction(width : CGFloat, height : CGFloat, time : CFTimeInterval)
    
    
    /// The queue
    var queue : Queue<SKAction> { get set }
    
    var node : SKNode { get }
}


extension GameActionQueueProtocol {
    /// Dequeues an action and runs it
    func dequeueAndRunAction() {
        if let action = queue.dequeue() {
            node.runAction(action)
        }
    }
    
    /// Creates a default action, and enqueues it.  It will also run the action if there are no other actions
    /// in the action queue at that time.
    /// - Parameter width: The width of node to pan
    /// - Parameter height: The height of the node to pan
    /// - Parameter time: The time it takes to pan the node
    func enqueueDefaultGameAction(width : CGFloat, height : CGFloat, time : CFTimeInterval) {
        let action = SKAction.moveBy(CGVector(dx: width, dy: height), duration: time)
        let completionAction = SKAction.runBlock({
            self.dequeueAndRunAction()
        })
        
        // create sequence and enqueue it
        let sequence = SKAction.sequence([action, completionAction])
        queue.enqueue(sequence)
        
        if queue.count == 1 && node.hasActions() == false {
            dequeueAndRunAction()
        }
    }
}