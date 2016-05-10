//
//  NodeCreation.swift
//  Sierra Valley
//
//  Created by Jack Arendt on 3/23/16.
//  Copyright © 2016 John Arendt. All rights reserved.
//

import Foundation

/// Represents the different probabilities of generating a certain path type
public struct PathProbabilities  {
    static var NoRoadblockPath = 20
    static var SpikePath = 10
    static var SpikePitPath = 16
    static var SpikeIslandPath = 12
    static var IslandPath = 12
    static var RampPath = 30
    
    static func compoundProbabilityForPath(path: Int) -> Int {
        let paths = [NoRoadblockPath, SpikePath, SpikePitPath, SpikeIslandPath, IslandPath, RampPath]
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


/// Generates a set of a nodes based on a statistical probability
/// - Parameter totalNodes: The number of nodes to be generated
/// - Returns: The array of created nodes
func createRandomNodeSet(totalNodes : Int) -> [LevelGenerationProtocol] {
    var nodes = [LevelGenerationProtocol]()
    for _ in 0.stride(to: totalNodes, by: 1) {
        let val = Int(arc4random() % 100)
        var path : LevelGenerationProtocol!
        switch val {
        // no roadblock trail
        case 0..<PathProbabilities.compoundProbabilityForPath(PathProbabilities.NoRoadblockPath):
            let length = Int(arc4random() % 5 + 6)
            let difficulty = generateDifficulty(maxDifficulty: NoRoadblockTrail.maxDifficulty, minDifficulty: NoRoadblockTrail.minDifficulty)
            path = NoRoadblockTrail(length: length, difficulty: difficulty)
            
        // spike trail
        case PathProbabilities.compoundProbabilityForPath(PathProbabilities.NoRoadblockPath)..<PathProbabilities.compoundProbabilityForPath(PathProbabilities.SpikePath):
            let difficulty = generateDifficulty(maxDifficulty: SpikeTrail.maxDifficulty, minDifficulty: SpikeTrail.minDifficulty)
            path = SpikeTrail(length: 0, difficulty: difficulty)
            
        // spike pit path
        case PathProbabilities.compoundProbabilityForPath(PathProbabilities.SpikePath)..<PathProbabilities.compoundProbabilityForPath(PathProbabilities.SpikePitPath):
            let difficulty = generateDifficulty(maxDifficulty: SpikePitTrail.maxDifficulty, minDifficulty: SpikePitTrail.minDifficulty)
            path = SpikePitTrail(length: 0, difficulty: difficulty)
           
        // spike island trail
        case PathProbabilities.compoundProbabilityForPath(PathProbabilities.SpikePitPath)..<PathProbabilities.compoundProbabilityForPath(PathProbabilities.SpikeIslandPath):
            let difficulty = generateDifficulty(maxDifficulty: SpikeIslandTrail.maxDifficulty, minDifficulty: SpikeIslandTrail.minDifficulty)
            path = SpikeIslandTrail(length: 0, difficulty: difficulty)
           
        // island trail
        case PathProbabilities.compoundProbabilityForPath(PathProbabilities.SpikeIslandPath)..<PathProbabilities.compoundProbabilityForPath(PathProbabilities.IslandPath):
            let difficulty = generateDifficulty(maxDifficulty: IslandTrail.maxDifficulty, minDifficulty: IslandTrail.minDifficulty)
            path = IslandTrail(length: 0, difficulty: difficulty)
            
        // ramp path
        case PathProbabilities.compoundProbabilityForPath(PathProbabilities.IslandPath)..<100:
            let difficulty = generateDifficulty(maxDifficulty: RampTrail.maxDifficulty, minDifficulty: RampTrail.minDifficulty)
            let length = 10
            path = RampTrail(length: length, difficulty: difficulty)
        default:
            break
        }
        nodes.append(path)
    }
    return nodes
}

func generateDifficulty(maxDifficulty maxDifficulty : Int, minDifficulty : Int) -> Int {
    if maxDifficulty == 0 && minDifficulty == 0 {
        return 0
    }
    return Int(arc4random()) % (maxDifficulty - minDifficulty) + minDifficulty
}
