//
//  QueueTests.swift
//  Sierra Valley
//
//  Created by Jack Arendt on 3/19/16.
//  Copyright © 2016 John Arendt. All rights reserved.
//

import XCTest
@testable import Sierra_Valley

class QueueTests: XCTestCase {
    func testBasicFunctionality() {
        let queue = Queue<Int>()
        XCTAssertTrue(queue.isEmpty())
        
        queue.enqueue(1)
        queue.enqueue(2)
        queue.enqueue(3)
        
        XCTAssertFalse(queue.isEmpty())
        
        XCTAssertEqual(queue.dequeue(), 1)
        XCTAssertEqual(queue.dequeue(), 2)
        
        queue.enqueue(4)
        queue.enqueue(5)
        
        XCTAssertEqual(queue.dequeue(), 3)
        XCTAssertEqual(queue.dequeue(), 4)
        XCTAssertEqual(queue.dequeue(), 5)
        
        XCTAssertNil(queue.dequeue())
        
        XCTAssertTrue(queue.isEmpty())
    }
    
    func testLargeEnqueueAndDequeue() {
        let queue = Queue<Int>()
        
        for i in 1.stride(through: 1000, by: 1) {
            queue.enqueue(i)
        }
        
        XCTAssertEqual(queue.count, 1000)
        
        for j in 1.stride(through: 1000, by: 1) {
            XCTAssertEqual(queue.dequeue(), j)
        }
    }
}
