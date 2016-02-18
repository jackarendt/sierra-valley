//
//  Buffer.swift
//  Sierra Valley
//
//  Created by Jack Arendt on 1/27/16.
//  Copyright © 2016 John Arendt. All rights reserved.
//

import Foundation

/// Generic read-only circular-read buffer of fixed length.
public class Buffer<T> {
    
    /// The buffer to be used
    private var _buf : [T]
    
    /// Current index for retrieving from the buffer
    private var idx = 0
    
    /// capacity of the buffer
    public var capacity = 0
    
    /// Initializes a new buffer with a set of items
    /// - Parameter items: The items to initialize the buffer with
    public init(items : [T]) {
        _buf = items
        capacity = _buf.count
    }
    
    /// Returns the next item in the buffer
    /// - Returns: next item in the buffer
    public func next() -> T {
        let item = _buf[idx]
        idx += 1
        if idx >= capacity {
            idx = 0 // if it is passed capacity, then move back to the front of the buffer
        }
        return item
    }
}
