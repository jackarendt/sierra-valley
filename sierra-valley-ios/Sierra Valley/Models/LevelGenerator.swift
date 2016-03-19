//
//  LevelGenerator.swift
//  Sierra Valley
//
//  Created by Jack Arendt on 1/29/16.
//  Copyright © 2016 John Arendt. All rights reserved.
//

import UIKit

let maximumLevelDifficulty = 90

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
        let val = arc4random() % 100
        var path : LevelGenerationProtocol!
        switch val {
        case 0..<60: // chance of getting a no roadblock trail
            let length = Int(arc4random() % 5 + 5)
            let difficulty = generateDifficulty(NoRoadblockTrail)
            path = NoRoadblockTrail(length: length, difficulty: difficulty)
            break;
        case 60..<75: // chance of getting spikes
            let difficulty = generateDifficulty(SpikeTrail)
            path = SpikeTrail(length: 0, difficulty: difficulty)
            break;
        case 75..<88:
            let difficulty = generateDifficulty(SpikePitTrail)
            path = SpikePitTrail(length: 0, difficulty: difficulty)
            break;
        case 88..<95:
            let difficulty = generateDifficulty(SpikeIslandTrail)
            path = SpikeIslandTrail(length: 0, difficulty: difficulty)
            break;
        case 95..<100:
            let difficulty = generateDifficulty(IslandTrail)
            path = IslandTrail(length: 0, difficulty: difficulty)
            break;
        default:
            break;
        }
        nodes.append(Node(path: path))
    }
    return nodes
}

func generateDifficulty(path : LevelGenerationProtocol.Type) -> Int {
    return Int(arc4random()) % (path.maxDifficulty - path.minDifficulty) + path.minDifficulty
}

