//
//  CameraManager.swift
//  Sierra Valley
//
//  Created by Jack Arendt on 2/11/16.
//  Copyright © 2016 John Arendt. All rights reserved.
//

import SpriteKit

/// Relays events of the camera manager to the delegate
protocol CameraManagerDelegate : class {
    /// Invoked when a camera action was dequeued from the cameraActionQueue
    func cameraActionDequeued(action : SKAction)
}

class CameraManager {
    
    /// The camera that moves with the scene
    weak var camera : SKCameraNode?
    
    
    weak var delegate : CameraManagerDelegate?
    
    /// The camera queue is used for when a level is generated and that action needs to be stored
    private let cameraActionQueue = Queue<SKAction>()
    
    /// Initializes a new camera manager with a new camera that has been added to the game scene
    /// - Parameter camera: The camera to move with the game scene
    init(camera : SKCameraNode?) {
        self.camera = camera
    }
}

// MARK - GameActionQueueProtocol methods
extension CameraManager : GameActionQueueProtocol {
    func enqueueGameAction(width : CGFloat, height : CGFloat, time : CFTimeInterval) {
        let action = SKAction.moveBy(CGVector(dx: width, dy: height), duration: time)
        let completionAction = SKAction.runBlock({ // when the camera is done executing, automatically start the next one
            self.cameraMovementFinished()
        })
        let sequence = SKAction.sequence([action, completionAction])
        cameraActionQueue.enqueue(sequence) // add the action to the queue
        
        // if the camera is still and doesn't have any actions, run the first available action
        if cameraActionQueue.count == 1 && camera?.hasActions() == false {
            dequeueAndRunCameraAction()
        }
    }
    
    // MARK: Helper methods for GameActionQueue
    
    /// Dequeues a camera action and then applies it to the camera
    private func dequeueAndRunCameraAction() {
        if let action = cameraActionQueue.dequeue(), camera = camera {
            delegate?.cameraActionDequeued(action)
            camera.runAction(action)
        }
    }
    
    /// Invoked when the camera action has finished
    func cameraMovementFinished() {
        dequeueAndRunCameraAction()
    }
}