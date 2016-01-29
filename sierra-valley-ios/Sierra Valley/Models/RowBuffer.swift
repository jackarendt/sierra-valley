//
//  RowBufferItem.swift
//  Sierra Valley
//
//  Created by Jack Arendt on 1/26/16.
//  Copyright © 2016 John Arendt. All rights reserved.
//

import SpriteKit

/// Set typealias of row buffer to that of a queue of row buffer items
typealias RowBuffer = Buffer<RowBufferItem>


/// Reperesents an item in the buffer, contains memory for the rectangle, triangle, and spike
final class RowBufferItem {
    init() {
        self.rectangle = RectangleNode(position: CGPointZero, color: UIColor.clearColor(), resourceSize: CGSizeZero)
        self.triangle = TriangleNode(position: CGPointZero, color: UIColor.clearColor(), resourceSize: CGSizeZero)
        self.spike = SpikeNode(position: CGPointZero, color: UIColor.clearColor(), resourceSize: CGSizeZero)
    }
    /// The Rectangle node.
    var rectangle : RectangleNode?
    
    /// The Triangle node.  inits the triangle with the slope on the right side
    var triangle : TriangleNode?
    
    /// The spike node
    var spike : SpikeNode?
}
