//
//  RowBufferItem.swift
//  Sierra Valley
//
//  Created by Jack Arendt on 1/26/16.
//  Copyright © 2016 John Arendt. All rights reserved.
//

import SpriteKit

/// Set typealias of row buffer to that of a queue of row buffer items
public typealias RowBuffer = Buffer<RowBufferItem>


/// Reperesents an item in the buffer, contains memory for the rectangle, triangle, and spike
final public class RowBufferItem {
    public init() {
        self.rectangle = RectangleNode(position: CGPointZero, color: UIColor.clearColor(), resourceSize: CGSizeZero)
        self.triangle = TriangleNode(position: CGPointZero, color: UIColor.clearColor(), resourceSize: CGSizeZero)
        self.spike = SpikeNode(position: CGPointZero, color: UIColor.clearColor(), resourceSize: CGSizeZero)
    }
    
    /// Initializes and adds to a scene
    public init(scene : SKScene) {
        self.rectangle = RectangleNode(position: CGPointZero, color: UIColor.clearColor(), resourceSize: CGSizeZero)
        self.triangle = TriangleNode(position: CGPointZero, color: UIColor.clearColor(), resourceSize: CGSizeZero)
        self.spike = SpikeNode(position: CGPointZero, color: UIColor.clearColor(), resourceSize: CGSizeZero)
        
        node.addChild(rectangle!)
        node.addChild(triangle!)
        node.addChild(spike!)
        scene.addChild(node)
    }
    /// The Rectangle node.
    public var rectangle : RectangleNode?
    
    /// The Triangle node.  inits the triangle with the slope on the right side
    public var triangle : TriangleNode?
    
    /// The spike node
    public var spike : SpikeNode?
    
    /// Parent holding node used for grouping actions together
    public let node : SKNode = SKNode()
}
