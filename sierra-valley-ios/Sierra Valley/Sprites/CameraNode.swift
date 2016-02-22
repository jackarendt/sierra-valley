//
//  CameraNode.swift
//  Sierra Valley
//
//  Created by Jack Arendt on 2/14/16.
//  Copyright © 2016 John Arendt. All rights reserved.
//

import SpriteKit

class CameraNode: SKCameraNode, GameActionQueueProtocol {
    
    var queue = Queue<SKAction>()
    
    var node : SKNode {
        get {
            return self
        }
    }

    func enqueueGameAction(width: CGFloat, height: CGFloat, time: CFTimeInterval) {
        enqueueDefaultGameAction(width, height: height, time: time)
    }
}
