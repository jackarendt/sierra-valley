//
//  StackTests.swift
//  Sierra Valley
//
//  Created by Jack Arendt on 3/17/16.
//  Copyright © 2016 John Arendt. All rights reserved.
//

import XCTest
@testable import Sierra_Valley

class StackTests: XCTestCase {
    
    func testBasicFunctionality() {
        let stack = Stack<Int>()
        XCTAssertTrue(stack.isEmpty())
        
        stack.push(1)
        stack.push(2)
        stack.push(3)
        
        XCTAssertEqual(stack.pop(), 3)
        XCTAssertEqual(stack.pop(), 2)
        
        stack.push(4)
        
        XCTAssertFalse(stack.isEmpty())
        
        XCTAssertEqual(stack.pop(), 4)
        XCTAssertEqual(stack.pop(), 1)
        
        XCTAssertNil(stack.pop())
        
        XCTAssertTrue(stack.isEmpty())
    }
    
    func testLargePushesAndPops() {
        let stack = Stack<Int>()
        
        for i in 1.stride(through: 1000, by: 1) {
            stack.push(i)
        }
        
        XCTAssertEqual(stack.count, 1000)
        
        for j in 1000.stride(through: 1, by: 1) {
            XCTAssertEqual(stack.pop(), j)
        }
    }
}
