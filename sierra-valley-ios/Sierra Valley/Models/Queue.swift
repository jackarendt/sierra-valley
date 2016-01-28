//
//  Queue.swift
//  Sierra Valley
//
//  Created by Jack Arendt on 1/25/16.
//  Copyright © 2016 John Arendt. All rights reserved.
//

import Foundation


public class Queue<T> {
    private var _queue = [T]()
    
    public var count : Int {
        get {
            return _queue.count
        }
    }
    
    private var enqueueIndex = 0
    private var dequeueIndex = 0
    
    public init() {
        
    }
    
    public init(items : [T]) {
        _queue = items
    }
    
    public func enqueue(item : T) {
        _queue.append(item)
    }
    
    public func dequeue() -> T? {
        if isEmpty() {
            return nil
        }
        return _queue.removeFirst()
    }
    
    public func isEmpty() -> Bool {
        return _queue.count == 0
    }
}