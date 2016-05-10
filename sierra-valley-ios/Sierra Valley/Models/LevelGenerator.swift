//
//  LevelGenerator.swift
//  Sierra Valley
//
//  Created by Jack Arendt on 1/29/16.
//  Copyright © 2016 John Arendt. All rights reserved.
//

import UIKit

/// Generates a level with a given difficulty and a queue to load it in to
/// - Parameter difficulty: The difficulty of the level
/// - Parameter queue: The queue to load the level in to.
func computeLevel(difficulty : Int, queue : Queue<ResourceRow>, flatRowLength : Int) {
    
    var accepted = false
    var usedRows = [ResourceRow]()
    while !accepted { // keep generating levels until we find one that's suitable
        let (remainingDifficulty, rows) = createLevelObstacles(difficulty)
        if remainingDifficulty < 10 {
            accepted = true
            usedRows = rows
        }
    }
    
    for row in usedRows {
        queue.enqueue(row)
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

/// Creates the actual obstacle part of the level
/// - Parameter difficulty: The difficulty of the level
/// - Returns: Tuple containing remaining difficulty and the rows it generated
func createLevelObstacles(difficulty : Int) -> (remainingDifficulty : Int, rows : [ResourceRow]) {
    var rows = [ResourceRow]()
    
    // create nodes and sort them by difficulty
    var nodes = createRandomNodeSet(300)
    nodes.sortInPlace { (first, second) -> Bool in
        return first.difficulty < second.difficulty
    }
    
    /// how many obstacles can be created
    var remainingDifficulty = difficulty
    
    /// The array of paths that have been generated for that level
    var paths = [LevelGenerationProtocol]()
    
    // estimated length of a level should be 100 rows (3000px)
    while rows.count < 125 {
        
        // get the available nodes for a set of qualifiers
        // don't make something more difficult than you can
        // obey length guidelines
        // don't cause too many obstacles in a row
        var availableNodes = findAvailableNodesForDifficulty(remainingDifficulty, currentLength: rows.count, nodes: nodes, lastItem: paths.last)
        
        var path : LevelGenerationProtocol // the path that was selected
        var idx = 0 // the index of the row that was selected
        
        // currently give a 2/3 shot of selecting an obstacle (with proper difficulty)
        if arc4random() % 3 != 0 && remainingDifficulty > 0 && paths.last?.name == TrailTypes.NoRoadblockTrail.rawValue {
            // get the available nodes for the remaining difficulty
            availableNodes = filterNodesForAvailableDifficulty(remainingDifficulty, nodes: availableNodes)
            
            // randomly create difficulty
            let minDifficulty = availableNodes.first!.difficulty
            let maxDifficulty = availableNodes.last!.difficulty
            var difficulty = 0
            if maxDifficulty != 0 {
                difficulty = Int(arc4random()) % (maxDifficulty - minDifficulty) + minDifficulty
            }
            // select path based on difficulty
            (path, idx) = findNearestDifficulty(difficulty, nodes: availableNodes)
        } else {
            // get no roadblock trail (difficulty of 0)
            (path, idx) = findNearestDifficulty(0, nodes: availableNodes)
        }
        
        // adjust the remaining difficulty
        remainingDifficulty -= path.difficulty
        
        // remove the node from the pool, and append the path to the paths array
        nodes.removeAtIndex(idx)
        paths.append(path)
        
        // enqueue the rows into the level queue
        for row in path.rows {
            rows.append(row)
        }
    }
    
    return (remainingDifficulty, rows)
}


/// Uses the binary search algorithm to determine which node has the closest difficulty to the one that is being queried
/// - Parameter difficulty: The key to look for when searching
/// - Parameter nodes: The array to search
/// - Returns: Tuple containing the element and the index of the element
func findNearestDifficulty(difficulty : Int, nodes : [LevelGenerationProtocol]) -> (level : LevelGenerationProtocol, index : Int) {
    
    if nodes.count == 0 {
        return (nodes[0], 0)
    }

    var min = 0 // get min index to look at
    var max = nodes.count - 1 // get max index to look at
    var pivot = (min + max)/2 // pivot splites min and max
    
    // go until you can't go no mo
    while min < max {
        pivot = (min + max)/2 // adjust the pivot
        let guess = nodes[pivot] // if the value of the pivot is the key, then return that pivot
        if guess.difficulty == difficulty {
            return (guess, pivot)
        }
        if guess.difficulty > difficulty { // if it's too much, then look left of the pivot
            max = pivot - 1
        } else { // if more, then look right
            min = pivot + 1
        }
    }
    // if no exact match, side on the more difficult, and return the max value
    return (nodes[max], max)
}


/// This is the "AI" for the level generation.  Using the supplied qualifiers, it then
/// decides which nodes are available to be selected. 
///
/// - Parameter remainingDifficulty: The remaining difficulty for the level
/// - Parameter currentLength: The length of the level so far
/// - Parameter nodes: The nodes that are being considered
/// - Parameter lastItem: The last item that was generated (so no duplicate obstacles in a row)
func findAvailableNodesForDifficulty(remainingDifficulty : Int, currentLength : Int, nodes : [LevelGenerationProtocol], lastItem : LevelGenerationProtocol?) -> [LevelGenerationProtocol] {
    // start with all available types
    var availableTrails = TrailTypes.allTypes()
    
    // For the beginning, due to rendering issues, only no roadblocks and spikes are allowed.
    if currentLength < GameSettings.sharedSettings.framesToTop {
        availableTrails = [.NoRoadblockTrail, .SpikeTrail]
    }
    
    // If there is no more difficulty left, or there was previously an obstacle,
    // make sure there is a clear path
    else if remainingDifficulty <= 0 {
        availableTrails = [.NoRoadblockTrail] // if you have no difficulty remaining, keep it 0
    }
    
    // otherwise, filter the remaining types based on which levels could *possibly* be considered
    else {
        availableTrails = filterAvailableTypesForRemainingDifficulty(availableTrails, remainingDifficulty: remainingDifficulty)
    }
    
    // filter the nodes and return them
    return filterNodesBasedOnNames(trailNamesForTypes(availableTrails), nodes: nodes)
}

/// Looks at the remaining difficulty, and says what types are available for the remaining difficulty
/// - Parameter availableTypes: The original available types
/// - Parameter remainingDifficulty: The remaining difficulty of the level
/// - Returns: Array of valid types after filtering based on difficulty
func filterAvailableTypesForRemainingDifficulty(availableTypes : [TrailTypes], remainingDifficulty : Int) -> [TrailTypes] {
    var remainingTypes = [TrailTypes]()
    
    /// if the suggested difficulty is less than the remaining difficulty, then make it accessible
    func checkDifficulty(difficulty : Int, type : TrailTypes) {
        if remainingDifficulty > difficulty {
            remainingTypes.append(type)
        }
    }
    
    // loop through all of the available types and filter out ones with too high of difficulty
    for type in availableTypes {
        switch type {
        case .NoRoadblockTrail:
            checkDifficulty(NoRoadblockTrail.minDifficulty, type: type)
        case .SpikeTrail:
            checkDifficulty(SpikeTrail.minDifficulty, type: type)
        case .SpikePitTrail:
            checkDifficulty(SpikePitTrail.minDifficulty, type: type)
        case .SpikeIslandTrail:
            checkDifficulty(SpikeIslandTrail.minDifficulty, type: type)
        case .IslandTrail:
            checkDifficulty(IslandTrail.minDifficulty, type: type)
        case .RampTrail:
            checkDifficulty(RampTrail.minDifficulty, type: type)
        }
    }
    return remainingTypes
}

/// Filters the supplied nodes by checking to see if the difficulty of the node is less than the
/// remaining difficulty of the level
/// - Parameter difficulty: The remaining difficulty of the level
/// - Parameter nodes: The nodes to be filtered
/// - Returns: The nodes that satisfy the difficulty constraint
func filterNodesForAvailableDifficulty(difficulty : Int, nodes : [LevelGenerationProtocol]) -> [LevelGenerationProtocol] {
    return nodes.filter({ (item) -> Bool in
        return item.difficulty < difficulty
    })
}

/// Filters nodes based on the names supplied, and returns the appropriate nodes.
/// ex. If only "NoRoadblockTrail" is allowed, it will only return nodes that are of that type
/// - Parameter names: Names of the allowed trails
/// - Parameter nodes: The nodes to be filtered
/// - Returns: The filtered array of the allowed types
func filterNodesBasedOnNames(names : [String], nodes: [LevelGenerationProtocol]) -> [LevelGenerationProtocol] {
    return nodes.filter { (item) -> Bool in
        return names.contains(item.name)
    }
}

/// Converts an array of trail types to their names
/// - Parameter types: The types to be converted
/// - Returns: An array of strings matching the types
func trailNamesForTypes(types : [TrailTypes]) -> [String] {
    var arr = [String]()
    for type in types {
        arr.append(type.rawValue)
    }
    return arr
}

/// Generates a flat path for when a game starts
/// - Parameter length: The length of the level
/// - Parameter queue: The queue to add the resource rows to
func generateOpeningFlatLevel(length : Int, queue : Queue<ResourceRow>) {
    for _ in 0.stride(to: length, by: 1) {
        queue.enqueue(ResourceRow(row: [.Rectangle], depressedHeight: 0))
    }
}
