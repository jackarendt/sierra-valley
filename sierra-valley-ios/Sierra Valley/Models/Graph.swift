//
//  Graph.swift
//  Sierra Valley
//
//  Created by Jack Arendt on 3/17/16.
//  Copyright © 2016 John Arendt. All rights reserved.
//

import Foundation

/// The Graph class represents a 2D graph. It allows for graphs to be generated, and traversed using a special
/// graphing algorithm that is a modified version of DFS.  It is currently not weighted, and directional.
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
    
    /// Adds a directed edge to the graph between two verticies
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
    public func traverseGraphUsingDFS(difficulty difficulty: Int, suggestedLength: Int) -> [Node] {
        let nodeStack = Stack<Node>() // get the stack to visit nodes
        
        var visitedPath = [Node : Node]()
        
        var remainingDifficulty = difficulty
        
        let startingIndex = Int(arc4random()) % verticies.count
        let startingNode = verticies[startingIndex]
        nodeStack.push(startingNode)
        
        var finalNode : Node!
        
        var pathsTaken = 0
        
        while !nodeStack.isEmpty() && remainingDifficulty > 0 {
            if let node = nodeStack.pop(){ // get the topmost item
                if !node.visited { // go to the node if it hasn't been visited
                    node.visited = true // set it as visited
                    node.visitedRemainingDifficulty = remainingDifficulty
                    remainingDifficulty -= node.difficulty
                    pathsTaken += 1
                    if remainingDifficulty <= 0 {
                        finalNode = node
                    }
                    for newNode in node.edges {
                        if !newNode.visited {
                            nodeStack.push(newNode)
                            visitedPath[newNode] = node
                        }
                    }
                }
            }
        }
        
        var currentNode : Node? = finalNode
        var path = [Node]()
        
        while currentNode != nil {
            path.append(currentNode!)
            currentNode = visitedPath[currentNode!]
        }
        
        return path
    }
    
    public func determineBestPath(difficulty difficulty : Int, suggestedLength : Int) -> [ResourceRow] {
        while true {
            let nodePath = traverseGraphUsingDFS(difficulty: difficulty, suggestedLength: suggestedLength)
            let length = calculateLengthForPath(nodePath)
//            let difficulty = calculateDifficultyForPath(nodePath)
            print(length)
            if abs(length - suggestedLength) < 30 {
                return createRowsForNodePath(nodePath)
            } else {
                for node in verticies {
                    node.visited = false
                }
            }
        }
    }
    
    private func calculateLengthForPath(nodes : [Node]) -> Int {
        var length = 0
        for node in nodes {
            length += node.length
        }
        return length
    }
    
    private func calculateDifficultyForPath(nodes : [Node]) -> Int {
        var difficulty = 0
        for node in nodes {
            difficulty += node.difficulty
        }
        return difficulty
    }
    
    private func createRowsForNodePath(nodes : [Node]) -> [ResourceRow] {
        var rows = [ResourceRow]()
        for node in nodes {
            rows.appendContentsOf(node.path.rows)
        }
        return rows
    }
}