//
//  Queue.swift
//  Sierra Valley
//
//  Created by Jack Arendt on 1/25/16.
//  Copyright © 2016 John Arendt. All rights reserved.
//

import Foundation

/// Generic queue where the first index is the front of the queue
public final class Queue<T> {
    /// contains the actual queue
    private var _queue : [T]
    
    /// returns the size of the queue
    public var count : Int {
        get {
            return _queue.count
        }
    }
    
    /// Initializes and empty queue
    public init() {
        _queue = [T]()
    }
    
    /// Initializes a queue with an array.  The first index of the array will be dequeued first
    public init(items : [T]) {
        _queue = items
    }
    
    /// Adds a new item to the queue
    /// - Parameter item: Item to be enqueued
    public func enqueue(item : T) {
        _queue.append(item)
    }
    
    /// Removes an item from the queue
    /// - Returns: First item in the queue, or nil if empty
    public func dequeue() -> T? {
        if isEmpty() {
            return nil
        }
        return _queue.removeFirst()
    }
    
    /// Allows to see into the queue by peeking at the first nth items
    /// - Parameter length: The number of items to peek
    /// - Returns: The first n items in the queue
    public func peek(var length : Int) -> [T] {
        if length > count {
            length = count
        }
        return Array(_queue[0..<length])
    }
    
    /// Checks to see if the queue is empty or not
    /// - Returns: Boolean denoting whether the empty or not
    public func isEmpty() -> Bool {
        return _queue.count == 0
    }
}