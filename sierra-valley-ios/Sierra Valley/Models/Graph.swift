//
//  Graph.swift
//  Sierra Valley
//
//  Created by Jack Arendt on 3/17/16.
//  Copyright © 2016 John Arendt. All rights reserved.
//

import Foundation

/// The Graph class represents a 2D graph. It allows for graphs to be generated, and traversed using a special
/// graphing algorithm that is a modified version of DFS.  It is currently not weighted, and bidirectional.
public class Graph {
    
    /// The number of edges on the graph
    public var edgeCount : Int {
        get {
            return verticies.count * multiplier
        }
    }
    
    /// The multiplier can be varied so that it
    public var multiplier : Int = 3
    
    /// The verticies of a graph
    public var verticies = [Node]()
    
    /// Adds a vertex to the 
    public func addVertex(newVertex : Node) {
        verticies.append(newVertex)
    }
    
    /// Adds an edge to the graph between two verticies
    /// - Parameter source: The source node
    /// - Parameter destination: The destination node
    /// - Returns: Boolean denoting whether the edge was added or not
    public func addEdge(source source : Node, destination : Node) -> Bool {
        
        if source == destination {
            return false
        }
        
        if source.edges.contains(destination) {
            return false
        }
        
        source.edges.insert(destination)
        destination.edges.insert(source)
        return true
    }
}

extension Graph : GraphGenerationProtocol {
    func generateGraphWithNodes(nodes : [Node]) {
        verticies = nodes
        
        // keep track of number of edges that have been created
        var edges = 0
        while edges < edgeCount {
            // get source and destination index
            let src = Int(arc4random()) % verticies.count
            let dst = Int(arc4random()) % verticies.count
            
            // if the edge addition is successful, then increment the edge count
            if addEdge(source: verticies[src], destination: verticies[dst]) {
                edges += 1
            }
        }
    }
}