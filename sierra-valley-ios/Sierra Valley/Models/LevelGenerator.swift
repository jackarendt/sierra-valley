//
//  LevelGenerator.swift
//  Sierra Valley
//
//  Created by Jack Arendt on 1/29/16.
//  Copyright © 2016 John Arendt. All rights reserved.
//

import UIKit

public struct PathProbabilities  {
    static let NoRoadblockPath = 60
    static let SpikePath = 15
    static let SpikePitPath = 13
    static let SpikeIslandPath = 7
    static let IslandPath = 5
    
    static func compoundProbabilityForPath(path: Int) -> Int {
        let paths = [NoRoadblockPath, SpikePath, SpikePitPath, SpikeIslandPath, IslandPath]
        if let idx = paths.indexOf(path) {
            var total = 0
            for item in paths.enumerate() {
                if item.index <= idx {
                    total += item.element
                }
            }
            return total
        }
        return 0
    }
}

/// Generates a level with a given difficulty and a queue to load it in to
/// - Parameter difficulty: The difficulty of the level
/// - Parameter queue: The queue to load the level in to.
func computeLevel(difficulty : Int, queue : Queue<ResourceRow>, flatRowLength : Int) {
    while queue.count < 100 {
        var rows : [ResourceRow]!
        let path = NoRoadblockTrail(length: 10, difficulty: 0)
        rows = path.rows
        for row in rows {
            queue.enqueue(row)
        }
    }
    
    // adds flat at the end so the user can go up to the top level
    let flatPath = FlatTrail(length: 7, difficulty: 0)
    for row in flatPath.rows {
        queue.enqueue(row)
    }
    
    // add extra space to end so the camera pans
    let emptyPath = EmptyRowTrail(length: flatRowLength - 7, difficulty: 0)
    for row in emptyPath.rows {
        queue.enqueue(row)
    }
}

func generateOpeningFlatLevel(length : Int, queue : Queue<ResourceRow>) {
    for _ in 0.stride(to: length, by: 1) {
        queue.enqueue(ResourceRow(row: [.Rectangle], depressedHeight: 0))
    }
}

/// Generates a set of a nodes based on a statistical probability
/// - Parameter totalNodes: The number of nodes to be generated
/// - Returns: The array of created nodes
func createRandomNodeSet(totalNodes : Int) -> [Node] {
    var nodes = [Node]()
    for _ in 0.stride(to: totalNodes, by: 1) {
        let val = Int(arc4random() % 100)
        var path : LevelGenerationProtocol!
        switch val {
        case 0..<PathProbabilities.compoundProbabilityForPath(PathProbabilities.NoRoadblockPath): // chance of getting a no roadblock trail
            let length = Int(arc4random() % 5 + 5)
            let difficulty = generateDifficulty(maxDifficulty: NoRoadblockTrail.maxDifficulty, minDifficulty: NoRoadblockTrail.minDifficulty)
            path = NoRoadblockTrail(length: length, difficulty: difficulty)
            
        case PathProbabilities.compoundProbabilityForPath(PathProbabilities.NoRoadblockPath)..<PathProbabilities.compoundProbabilityForPath(PathProbabilities.SpikePath):
            let difficulty = generateDifficulty(maxDifficulty: SpikeTrail.maxDifficulty, minDifficulty: SpikeTrail.minDifficulty)
            path = SpikeTrail(length: 0, difficulty: difficulty)
            
        case PathProbabilities.compoundProbabilityForPath(PathProbabilities.SpikePath)..<PathProbabilities.compoundProbabilityForPath(PathProbabilities.SpikePitPath):
            let difficulty = generateDifficulty(maxDifficulty: SpikePitTrail.maxDifficulty, minDifficulty: SpikePitTrail.minDifficulty)
            path = SpikePitTrail(length: 0, difficulty: difficulty)
            
        case PathProbabilities.compoundProbabilityForPath(PathProbabilities.SpikePitPath)..<PathProbabilities.compoundProbabilityForPath(PathProbabilities.SpikeIslandPath):
            let difficulty = generateDifficulty(maxDifficulty: SpikeIslandTrail.maxDifficulty, minDifficulty: SpikeIslandTrail.minDifficulty)
            path = SpikeIslandTrail(length: 0, difficulty: difficulty)
            
        case PathProbabilities.compoundProbabilityForPath(PathProbabilities.SpikeIslandPath)..<100:
            let difficulty = generateDifficulty(maxDifficulty: IslandTrail.maxDifficulty, minDifficulty: IslandTrail.minDifficulty)
            path = IslandTrail(length: 0, difficulty: difficulty)
        default:
            break
        }
        nodes.append(Node(path: path))
    }
    return nodes
}

func generateDifficulty(maxDifficulty maxDifficulty : Int, minDifficulty : Int) -> Int {
    if maxDifficulty == 0 && minDifficulty == 0 {
        return 0
    }
    return Int(arc4random()) % (maxDifficulty - minDifficulty) + minDifficulty
}

