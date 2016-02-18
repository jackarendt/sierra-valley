//
//  RowBufferPool.swift
//  Sierra Valley
//
//  Created by Jack Arendt on 2/1/16.
//  Copyright © 2016 John Arendt. All rights reserved.
//

import SpriteKit

/// Contains a pool of all of the buffers for holding all of the nodes
class RowBufferPool {
    /// The pool of all of the buffers
    private var pool : Buffer<RowBuffer>!
    
    /// contains the buffer used for rendering the foreground of the game
    private var foregroundRowBuffer : RowBuffer!
    
    /// contains the buffer used for rendering the background level of the game
    private var backgroundRowBuffer : RowBuffer!
    
    /// Initializes a pool with n number of buffers, of m size
    /// - Parameter poolSize: The number of buffers in the pool
    /// - Parameter bufferSize: The size of each buffer
    /// - Note: The pool size must be larger than 2.
    init(poolSize : Int, bufferSize : Int) {
        var buf = [RowBuffer]()
        for _ in 0.stride(to: poolSize, by: 1) {
            var rowBuffer = [RowBufferItem]()
            for _ in 0.stride(to: bufferSize, by: 1) {
                rowBuffer.append(RowBufferItem())
            }
            buf.append(RowBuffer(items: rowBuffer)) // create buffer
        }
        pool = Buffer<RowBuffer>(items: buf) // allocate the pool
        backgroundRowBuffer = pool.next() // 0
        incrementPool()
    }
    
    /// Increments the pool index
    func incrementPool() {
        let origBackground = backgroundRowBuffer // 1
        backgroundRowBuffer = pool.next() // 2
        foregroundRowBuffer = origBackground // 1
    }
    
    func alterCategoryBitMask() {
        formatForegroundElements(foregroundRowBuffer)
        formatBackgroundElements(backgroundRowBuffer)
    }
    
    private func formatBackgroundElements(buffer : RowBuffer) {
        for _ in 0.stride(to: buffer.capacity, by: 1) {
            let item = buffer.next()
            item.rectangle?.categoryBitMask = CollisionBitmaskCategory.Background
            item.spike?.categoryBitMask = CollisionBitmaskCategory.Background
            item.triangle?.categoryBitMask = CollisionBitmaskCategory.Background
        }
    }
    
    private func formatForegroundElements(buffer : RowBuffer) {
        for _ in 0.stride(to: buffer.capacity, by: 1) {
            let item = buffer.next()
            item.rectangle?.categoryBitMask = CollisionBitmaskCategory.Rectangle
            item.spike?.categoryBitMask = CollisionBitmaskCategory.Triangle
            item.triangle?.categoryBitMask = CollisionBitmaskCategory.Spike
        }
    }
    
    /// Returns the next buffer item in the foreground buffer
    /// - Returns: RowBufferItem of the foreground buffer
    func nextForegroundItem() -> RowBufferItem {
        return foregroundRowBuffer.next()
    }
    
    /// Returns the next buffer item in the background buffer
    /// - Returns: RowBufferItem of the background buffer
    func nextBackgroundItem() -> RowBufferItem {
        return backgroundRowBuffer.next()
    }
}