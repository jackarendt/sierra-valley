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
    public func generateGraphWithNodes(nodes : [Node]) {
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


extension Graph : DFSTraversalProtocol {
    public func traverseGraphUsingDFS(difficulty difficulty: Int, suggestedLength: Int) -> [[Node]] {
        let nodeStack = Stack<Node>() // get the stack to visit nodes
        
        /*
         * The Visited Dictionary keeps a paper trail of sorts to figure out what path the DFS search travels.
         * It works as such:
         * visited[child] = parent
         */
        var visitedDictionary = [Node : Node]()
        
        var remainingDifficulty = difficulty
        
        let startingIndex = Int(arc4random()) % verticies.count
        
        nodeStack.push(verticies[startingIndex])
        
        while !nodeStack.isEmpty() {
            if let node = nodeStack.pop(){ // get the topmost item
                if !node.visited { // go to the node if it hasn't been visited
                    node.visited = true // set it as visited
                    for newNode in node.edges {
                        nodeStack.push(newNode)
                    }
                }
            }
        }
        
        return [[Node]]()
    }
}