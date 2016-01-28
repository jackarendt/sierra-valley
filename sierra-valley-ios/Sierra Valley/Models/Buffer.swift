//
//  Buffer.swift
//  Sierra Valley
//
//  Created by Jack Arendt on 1/27/16.
//  Copyright © 2016 John Arendt. All rights reserved.
//

import SpriteKit

public class Buffer<T> {
    
    private var _buf : [T]
    
    private var idx = 0
    
    private var capacity = 0
    
    public init(items : [T]) {
        _buf = items
        capacity = _buf.count
    }
    
    public func next() -> T {
        let item = _buf[idx]
        idx += 1
        if idx >= capacity {
            idx = 0
        }
        return item
    }
}
