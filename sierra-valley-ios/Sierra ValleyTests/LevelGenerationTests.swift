//
//  LevelGenerationTests.swift
//  Sierra Valley
//
//  Created by Jack Arendt on 3/19/16.
//  Copyright © 2016 John Arendt. All rights reserved.
//

import XCTest
@testable import Sierra_Valley

class LevelGenerationTests: XCTestCase {
    
    func testProbabilitySummation() {
        // no roadblock
        var expected = PathProbabilities.NoRoadblockPath
        var actual = PathProbabilities.compoundProbabilityForPath(PathProbabilities.NoRoadblockPath)
        XCTAssertEqual(actual, expected)
        
        // spike trail
        expected += PathProbabilities.SpikePath
        actual = PathProbabilities.compoundProbabilityForPath(PathProbabilities.SpikePath)
        XCTAssertEqual(actual, expected)
        
        expected += PathProbabilities.SpikePitPath
        actual = PathProbabilities.compoundProbabilityForPath(PathProbabilities.SpikePitPath)
        XCTAssertEqual(actual, expected)
        
        expected += PathProbabilities.SpikeIslandPath
        actual = PathProbabilities.compoundProbabilityForPath(PathProbabilities.SpikeIslandPath)
        XCTAssertEqual(actual, expected)
        
        expected += PathProbabilities.IslandPath
        actual = PathProbabilities.compoundProbabilityForPath(PathProbabilities.IslandPath)
        XCTAssertEqual(actual, expected)
        
        XCTAssertEqual(actual, 100) // make sure total is 100, or 100%
    }
    
    func testNodeGenerationProbabilities() {
        let count = 1000
        let nodes = createRandomNodeSet(count)
        XCTAssertEqual(nodes.count, count)
        
        var noRoadblock = 0
        var spike = 0
        var spikePit = 0
        var spikeIsland = 0
        var island = 0
        
        for node in nodes {
            switch node {
            case is NoRoadblockTrail:   noRoadblock += 1;
            case is SpikeTrail:         spike += 1;
            case is SpikePitTrail:      spikePit += 1
            case is SpikeIslandTrail:   spikeIsland += 1;
            case is IslandTrail:        island += 1;
            default: break
            }
        }
     
        print(noRoadblock)
        print(spike)
        print(spikePit)
        print(spikeIsland)
        print(island)
        
        XCTAssertEqual(noRoadblock + spike + spikePit + spikeIsland + island, count)
    }
}
