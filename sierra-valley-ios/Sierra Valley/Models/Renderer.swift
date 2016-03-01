//
//  Renderer.swift
//  Sierra Valley
//
//  Created by Jack Arendt on 1/30/16.
//  Copyright © 2016 John Arendt. All rights reserved.
//

import SpriteKit

protocol RendererDelegate : class {
    func zPositionChanged(newZPosition : CGFloat)
}


/// The Renderer class is specific to the platform.  The renderer is in charge of placing all of the
/// different level pieces into their respective places.
final class Renderer {
    /// The buffer pool contains all of the initialized the row data so that you don't need to allocate
    /// a node every single time you use a piece
    private var bufferPool : RowBufferPool!
    
    /// the scene that the game is being presented
    weak var scene : SKScene?
    
    weak var delegate : RendererDelegate?
    
    /// The information of the game for renders
    private let gameSettings = GameSettings()
    
    private var zPosition : CGFloat = 1000000
    
    /// Initializes the renderer with the current scene, and allocates the buffer pool
    /// - Parameter scene: The scene that is being presented
    init(scene : SKScene) {
        self.scene = scene
        bufferPool = RowBufferPool(poolSize: 3, bufferSize: Int(gameSettings.numFrames * 1.5))
        delegate?.zPositionChanged(zPosition)
    }
    
    /// Renders a row on the screen to the given position and color and adds it to the scene if necessary
    /// - Parameter row: The row to be rendered
    /// - Parameter color: The color for the row
    /// - Parameter direction: The direction that the car will travel
    /// - Parameter cameraPosition: The center of the camear in the scene
    func renderResourceRow(row : ResourceRow, color : UIColor , direction : CarDirection, var position : CGPoint, duration : CFTimeInterval){
        // get proper buffer and z position for the row
        var buffer : RowBufferItem!
        var zPos : CGFloat = zPosition
        
        if duration >= 0 {
            buffer = bufferPool.nextBackgroundItem()
            zPos = zPosition - 1
        } else {
            buffer = bufferPool.nextForegroundItem()
        }
        
        let rectHeight : CGFloat = 300
        position.y = position.y - UIScreen.mainScreen().bounds.height/2 + gameSettings.maxMountainHeight - rectHeight/2 - row.depressedHeight
        let usedResrouces = renderPieces(buffer, color: color, row: row, position: position, zPos: zPos, rectHeight: rectHeight, direction: direction)

        if duration >= 0 {
            for resource in usedResrouces {
                resource.position.y += 3 * rectHeight
                let delay = SKAction.waitForDuration(duration)
                let rise = SKAction.moveBy(CGVector(dx: 0, dy: -3 * rectHeight), duration: 0.5)
                resource.runAction(SKAction.sequence([delay,rise]))
            }
        }
        
    }
    
    func incrementBufferPool() {
        bufferPool.incrementPool()
        zPosition -= 1
        delegate?.zPositionChanged(zPosition)
        
    }
    
    func alterCategoryBitMask() {
        bufferPool.alterCategoryBitMask()
    }
    
    /// Does the actually rendering of the pieces and adds them to the scene
    /// - Parameter buffer: The buffer item to use when rendering
    /// - Parameter color: The color of the row
    /// - Parameter row: The row information to be renderered
    /// - Parameter position: The x & y information of where rendering takes place
    /// - Parameter zPos: The z position of the row
    /// - Parameter rectHeight: The height of the rectangle to be rendered
    /// - Parameter direction: The direction of the triangle to be rendered (whether it should face left or right)
    private func renderPieces(buffer : RowBufferItem, color : UIColor, row : ResourceRow, position : CGPoint, zPos : CGFloat, rectHeight : CGFloat, direction : CarDirection) -> [SKNode] {
        // resources that will be rendered on the screen
        var usedResources = [SKNode]()
        
        // if empty row, make them all hidden
        if row.row.contains(3) {
            buffer.rectangle?.size = CGSizeZero
            buffer.triangle?.size = CGSizeZero
            buffer.spike?.size = CGSizeZero
            return [buffer.rectangle!, buffer.triangle!, buffer.spike!]
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
            spike.size = CGSizeMake(spike.size.width, 20)
            spike.position = CGPoint(x: position.x, y: position.y + rect.size.height/2 + spike.size.height/2)
            spike.color = color
            spike.zPosition = zPos
            usedResources.append(spike)
        }
        addNodes(usedResources)
        return usedResources
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
}