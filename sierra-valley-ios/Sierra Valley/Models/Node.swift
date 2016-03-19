//
//  Node.swift
//  Sierra Valley
//
//  Created by Jack Arendt on 3/17/16.
//  Copyright © 2016 John Arendt. All rights reserved.
//

import Foundation

/// The Node class represents one vertex of a graph.
class Node : Equatable {
    
    /// The path that will be used in the level if this node is selected
    var path : LevelGenerationProtocol!
    
    /// Boolean denoting whether the node was visited or not
    var visited = false
    
    /// Array of nodes that the graph touches
    var edges = [Node]()
    
    /// The length of the path
    var length : Int {
        get {
            return path.length
        }
    }
    
    /// The difficulty of the path
    var difficulty : Int {
        get {
            return path.difficulty
        }
    }
    
    /// Creates a new graph node
    /// - Parameter path: The path that is represented by the node
    init(path : LevelGenerationProtocol) {
        self.path = path
    }
}

func ==(lhs: Node, rhs: Node) -> Bool {
    return unsafeAddressOf(lhs) == unsafeAddressOf(rhs)
}