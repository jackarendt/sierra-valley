//
//  Graph.swift
//  Sierra Valley
//
//  Created by Jack Arendt on 3/17/16.
//  Copyright © 2016 John Arendt. All rights reserved.
//

import Foundation

/// The Graph class represents a 2D graph. It allows for graphs to be generated, and traversed using a special
/// graphing algorithm that is a modified version of DFS.
class Graph {
    private var verticies = [Node]()
    
    /// Adds a vertex to the 
    func addVertex(newVertex : Node) {
        verticies.append(newVertex)
    }
    
    func addEdge(source : Node, destination : Node) -> Bool {
        
        if source == destination {
            return false
        }
        
        if source.edges.contains(destination) {
            return false
        }
        
        source.edges.append(destination)
        destination.edges.append(source)
        return true
    }
}