//
//  Node.swift
//  Sierra Valley
//
//  Created by Jack Arendt on 3/17/16.
//  Copyright © 2016 John Arendt. All rights reserved.
//

import Foundation

/// The Node class represents one vertex of a graph.
public class Node : NSObject {
    
    /// The path that will be used in the level if this node is selected
    public var path : LevelGenerationProtocol!
    
    /// Boolean denoting whether the node was visited or not
    public var visited = false
    
    /// Array of nodes that the graph touches
    public var edges = Set<Node>()
    
    
    /// The length of the path
    public var length : Int {
        get {
            return path.length
        }
    }
    
    /// The difficulty of the path
    public var difficulty : Int {
        get {
            return path.difficulty
        }
    }
    
    /// Creates a new graph node
    /// - Parameter path: The path that is represented by the node
    public init(path : LevelGenerationProtocol) {
        self.path = path
    }
}