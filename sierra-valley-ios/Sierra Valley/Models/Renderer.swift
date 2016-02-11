//
//  Renderer.swift
//  Sierra Valley
//
//  Created by Jack Arendt on 1/30/16.
//  Copyright © 2016 John Arendt. All rights reserved.
//

import SpriteKit


/// The Renderer class is specific to the platform.  The renderer is in charge of placing all of the
/// different level pieces into their respective places.
final class Renderer {
    /// The buffer pool contains all of the initialized the row data so that you don't need to allocate
    /// a node every single time you use a piece
    private var bufferPool : RowBufferPool!
    
    /// the scene that the game is being presented
    weak var scene : SKScene?
    
    /// the camera that pans through the scene
    weak var camera : SKCameraNode? {
        didSet {
            oldValue?.removeFromParent()
            if let cam = camera {
                scene?.addChild(cam)
            }
        }
    }
    
    /// The information of the game for renders
    private let gameSettings = GameSettings()
    
    /// The camera queue is used for when a level is generated and that action needs to be stored
    private let cameraActionQueue = Queue<SKAction>()
    
    /// Initializes the renderer with the current scene, and allocates the buffer pool
    /// - Parameter scene: The scene that is being presented
    init(scene : SKScene) {
        self.scene = scene
        bufferPool = RowBufferPool(poolSize: 5, bufferSize: Int(gameSettings.numFrames))
    }
    
    
    /// Adds a camera action to the camera queue
    /// - Parameter width: The width that the camera needs to pan
    /// - Parameter height: The height that the camera needs to pan
    /// - Parameter time: The time it takes to pan the camera to the end point
    func enqueueCameraAction(width : CGFloat, height : CGFloat, time : CFTimeInterval) {
        if let camera = camera {
            let action = SKAction.moveTo(CGPoint(x: width + camera.position.x /*- gameSettings.rowWidth/2*/, y: camera.position.y + height /*- gameSettings.triangleHeight/2*/), duration: time /*- gameSettings.rowRefreshRate/2*/)
            let completionAction = SKAction.runBlock({ // when the camera is done executing, automatically start the next one
                self.cameraMovementFinished()
            })
            let sequence = SKAction.sequence([action, completionAction])
            cameraActionQueue.enqueue(sequence) // add the action to the queue
        }
        
        // if the camera is still and doesn't have any actions, run the first available action
        if cameraActionQueue.count == 1 && camera?.hasActions() == false {
            dequeueAndRunCameraAction()
        }
    }
    
    /// Renders a row on the screen to the given position and color and adds it to the scene if necessary
    /// - Parameter row: The row to be rendered
    /// - Parameter color: The color for the row
    /// - Parameter direction: The direction that the car will travel
    /// - Parameter cameraPosition: The center of the camear in the scene
    func renderResourceRow(row : ResourceRow, color : UIColor , direction : CarDirection, var position : CGPoint, background : Bool){
        // get proper buffer and z position for the row
        var buffer : RowBufferItem!
        var zPos : CGFloat = 100
        
        if background {
            buffer = bufferPool.nextContinuationItem()
            zPos = -100
        } else {
            buffer = bufferPool.nextForegroundItem()
        }
        
        let rectHeight : CGFloat = 200
        position.y = position.y - UIScreen.mainScreen().bounds.height/2 + gameSettings.maxMountainHeight - rectHeight/2 - row.depressedHeight
        renderPieces(buffer, color: color, row: row, position: position, zPos: zPos, rectHeight: rectHeight, direction: direction)
    }
    
    /// Does the actually rendering of the pieces and adds them to the scene
    /// - Parameter buffer: The buffer item to use when rendering
    /// - Parameter color: The color of the row
    /// - Parameter row: The row information to be renderered
    /// - Parameter position: The x & y information of where rendering takes place
    /// - Parameter zPos: The z position of the row
    /// - Parameter rectHeight: The height of the rectangle to be rendered
    /// - Parameter direction: The direction of the triangle to be rendered (whether it should face left or right)
    private func renderPieces(buffer : RowBufferItem, color : UIColor, row : ResourceRow, position : CGPoint, zPos : CGFloat, rectHeight : CGFloat, direction : CarDirection) {
        // resources that will be rendered on the screen
        var usedResources = [SKNode]()
        
        // if empty row, make them all hidden
        if row.row.contains(3) {
            buffer.rectangle?.size = CGSizeZero
            buffer.triangle?.size = CGSizeZero
            buffer.spike?.size = CGSizeZero
            return
        }
        
        let rect = buffer.rectangle! // there will always be a rectangle, so don't check for that
        rect.position = position
        rect.color = color
        rect.size = CGSize(width: gameSettings.rowWidth, height: rectHeight)
        rect.zPosition = zPos
        usedResources.append(rect)
        
        if row.row.contains(1) { // render triangle if necessary
            let triangle = buffer.triangle!
            triangle.position = CGPoint(x: position.x, y: position.y + rect.size.height/2 + gameSettings.triangleHeight/2)
            triangle.color = color
            triangle.size = CGSize(width: gameSettings.rowWidth, height: gameSettings.triangleHeight)
            triangle.zPosition = zPos
            if triangle.xScale < 0 && direction == .Right {
                triangle.xScale *= -1
            } else if triangle.xScale > 0 && direction == .Left {
                triangle.xScale *= -1
            }
            usedResources.append(triangle)
        }
        
        if row.row.contains(2) { // render spike if necessary
            let spike = buffer.spike!
            spike.position = CGPoint(x: position.x, y: position.y + rect.size.height/2 + spike.size.height/2)
            spike.color = color
            spike.zPosition = zPos
            usedResources.append(spike)
        }
        addNodes(usedResources)
    }
    
    /// Adds nodes to the scene if necessary
    /// - Parameter nodes: The nodes to be added
    private func addNodes(nodes : [SKNode]) {
        for node in nodes { // cycle through the nodes, and if a node isn't currently on the screen, add it.
            if node.scene == nil {
                scene?.addChild(node)
            }
        }
    }
    
    /// Dequeues a camera action and then applies it to the camera
    private func dequeueAndRunCameraAction() {
        if let action = cameraActionQueue.dequeue(), camera = camera {
            bufferPool.incrementPool()
            camera.runAction(action)
        }
    }
    
    func cameraMovementFinished() {
        dequeueAndRunCameraAction()
    }
}