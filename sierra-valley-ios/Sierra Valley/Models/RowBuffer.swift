//
//  RowBufferItem.swift
//  Sierra Valley
//
//  Created by Jack Arendt on 1/26/16.
//  Copyright © 2016 John Arendt. All rights reserved.
//

import SpriteKit

/// Set typealias of row buffer to that of a queue of row buffer items
typealias RowBuffer = Queue<RowBufferItem>


class RowBufferItem {
    
    init() {
        self.rectangle = RectangleNode(position: CGPointZero, color: UIColor.clearColor(), resourceSize: CGSizeZero)
        self.triangle = SKNode()
        self.spike = SpikeNode(position: CGPointZero, color: UIColor.clearColor(), resourceSize: CGSizeZero)
    }
    
    var rectangle : RectangleNode?
    var triangle : SKNode? // TODO: needs to be created
    var spike : SpikeNode?
}
