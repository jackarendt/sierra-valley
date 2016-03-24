//
//  GraphProtocols.swift
//  Sierra Valley
//
//  Created by Jack Arendt on 3/19/16.
//  Copyright © 2016 John Arendt. All rights reserved.
//

import Foundation

/// The DFSTraversalProtocol is a protocol designed to help traverse a graph using the DFS algorithm
public protocol DFSTraversalProtocol {
    
    /// Traverses the graph using a modified version of DFS.  In addition to retreating when
    /// there are no more new nodes to discover, the algorithm will also stop when it hits a suggested
    /// difficulty and length.  These will be saved in a temporary data structure and returned so that
    /// the most appropriate path from the generated list.
    /// - Parameter difficulty: The difficulty that the level should be
    /// - Parameter suggestedLength: The suggested length of the path to be generated. (Just a guideline, not strictly followed)
    func traverseGraphUsingDFS(difficulty difficulty: Int, suggestedLength : Int) -> [Node]
}

/// The graph generation protocol is designed to create a graph using a set of nodes by randomly assigning each edge
/// of the graph.
public protocol GraphGenerationProtocol {
    /// Generates a graph using the nodes that are passed in.  Randomly assigns each edge of the graph.
    /// It creates an arbitrary number of times the amount of edges as there are nodes.
    func generateGraphWithNodes(nodes: [Node])
}