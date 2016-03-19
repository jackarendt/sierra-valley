//
//  Stack.swift
//  Sierra Valley
//
//  Created by Jack Arendt on 3/17/16.
//  Copyright © 2016 John Arendt. All rights reserved.
//

import Foundation

/// The stack is a class that utilizes the FILO (first in first out) protocol.  If an item is
/// pushed, it will not be popped off until all subsequent objects are popped from on top of it.
/// Think of this as a pez dispenser
public class Stack<T> {
    
    /// The array that will keep track of the items in the stack
    private var _stack : [T]
    
    /// The number of items in the stack
    public var count : Int {
        return _stack.count
    }
    
    /// Creates a new instance of a stack
    public init() {
        _stack = [T]()
    }

    /// Pushes a new object on to the top of the stack
    /// - Parameter item: The item to be pushed on to the stack
    public func push(item : T) {
        _stack.append(item)
    }
    
    /// Pops an item off of the stack
    /// - Note: Returns nil if no object exists
    /// - Returns: The item that has been popped off
    public func pop() -> T? {
        if !isEmpty() {
            return _stack.removeLast()
        }
        return nil
    }
    
    /// Checks to see if the stack is empty or not
    /// - Returns: Boolean denoting if the stack is empty or not
    public func isEmpty() -> Bool {
        return count == 0
    }
}