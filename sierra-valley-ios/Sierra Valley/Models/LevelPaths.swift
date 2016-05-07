//
//  LevelPaths.swift
//  Sierra Valley
//
//  Created by Jack Arendt on 3/19/16.
//  Copyright © 2016 John Arendt. All rights reserved.
//

import Foundation
import UIKit

// MARK: - Level Generation Protocol

/// The Level Generation Protocol eases making different level pieces and makes them interchangable
public protocol LevelGenerationProtocol {
    /// The easiest the level can get
    static var minDifficulty : Int { get set }
    
    /// The hardest the level can get
    static var maxDifficulty : Int { get set }
    
    /// The actual difficulty of a path
    var difficulty : Int { get set }
    
    /// The length of a path
    var length : Int { get set }
    
    /// The rows for a particular path
    var rows : [ResourceRow]! { get set }
    
    /// Generates the path for a given difficulty and suggested length
    /// - Returns: An array of resource rows to be enqueued
    mutating func generatePath() -> [ResourceRow]
    
    /// The name of the level (meant for debugging)
    var name : String { get set }
    
    // Creates a new object with a length and difficulty
    init(length : Int, difficulty : Int)
}

public func >(lhs : LevelGenerationProtocol, rhs : LevelGenerationProtocol) -> Bool {
    return lhs.difficulty > rhs.difficulty
}

public func <(lhs : LevelGenerationProtocol, rhs : LevelGenerationProtocol) -> Bool {
    return lhs.difficulty < rhs.difficulty
}


public enum TrailTypes : String {
    case NoRoadblockTrail = "NoRoadblockTrail"
    case SpikeTrail = "SpikeTrail"
    case SpikePitTrail = "SpikePitTrail"
    case SpikeIslandTrail = "SpikeIslandTrail"
    case IslandTrail = "IslandTrail"
    case RampTrail = "RampTrail"
    
    static func allTypes() -> [TrailTypes] {
        return [.NoRoadblockTrail, .SpikeTrail, .SpikePitTrail, .SpikeIslandTrail, .IslandTrail, .RampTrail]
    }
}

// MARK: - Paths


/// no roadblocks, no difficulty here.
struct NoRoadblockTrail : LevelGenerationProtocol {
    static var minDifficulty = 0
    static var maxDifficulty = 0
    
    var name = TrailTypes.NoRoadblockTrail.rawValue
    
    var difficulty = 0
    var length = 0
    
    var rows : [ResourceRow]!
    
    init(length: Int, difficulty : Int) {
        self.difficulty = difficulty
        self.length = length
        self.rows = generatePath()
    }
    
    mutating func generatePath() -> [ResourceRow] {
        var rows = [ResourceRow]()
        for _ in 0.stride(to: length, by: 1) {
            // create path with no obstacles, easy.
            rows.append(ResourceRow(row: [.Rectangle, .Triangle], depressedHeight: 0))
        }
        return rows
    }
}

// MARK: - Basic Obstacles

/// Adds a a bunch of spikes in a row on the level ground
struct SpikeTrail : LevelGenerationProtocol {
    static var minDifficulty = 5
    static var maxDifficulty = 20

    var name = TrailTypes.SpikeTrail.rawValue
    
    var difficulty = 0
    var length = 0
    
    var rows : [ResourceRow]!
    
    var maxSpikes : Double = 3
    
    init(length: Int, difficulty : Int) {
        self.difficulty = difficulty
        self.length = length
        self.rows = generatePath()
    }

    mutating func generatePath() -> [ResourceRow] {
        length = Int(ceil(Double(difficulty - SpikeTrail.minDifficulty)/Double(SpikeTrail.maxDifficulty - SpikeTrail.minDifficulty) * maxSpikes)) // maximum of 3 spikes
        var rows = [ResourceRow]()
        for _ in 0.stride(to: length, by: 1) {
            rows.append(ResourceRow(row: [.Rectangle, .Triangle, .Spike], depressedHeight: 0))
        }
        return rows
    }
}

/// Creates a pit of spikes that need to be jumped over.
/// each spike is at the same height, and creates almost like a ditch
struct SpikePitTrail : LevelGenerationProtocol {
    static var minDifficulty = 20
    static var maxDifficulty = 60

    var name = TrailTypes.SpikePitTrail.rawValue
    
    var difficulty = 0
    var length = 0
    
    var rows : [ResourceRow]!
    
    init(length: Int, difficulty : Int) {
        self.difficulty = difficulty
        self.length = length
        self.rows = generatePath()
    }
    
    mutating func generatePath() -> [ResourceRow] {
        var rows = [ResourceRow]()
        // get the difference between the difficulty and minimum difficulty
        let diff : Double = Double(difficulty - SpikePitTrail.minDifficulty)
        // get the maximum range of the obstacle
        let range : Double = Double(SpikePitTrail.maxDifficulty - SpikePitTrail.minDifficulty)
        if diff < range * 0.25 { // easy
            length = 3
        } else if diff < range * 0.5 { // medium
            length = 4
        } else if diff < range * 0.75 { // hard
            length = 5
        } else { // damn
            length = 6
        }
        for i in 0.stride(to: length, by: 1) {
            // append rows each with a depressed height equal to the triangle height (so it appears flat)
            rows.append(ResourceRow(row: [.Rectangle, .Spike], depressedHeight: GameSettings.sharedSettings.rowWidth + CGFloat(i) * GameSettings.sharedSettings.triangleHeight))
        }
        return rows
    }
}


// MARK: - Advanced obstacles

/// Creates a moat of 1 spike with anywhere from 2 to 4 spikes forming an island in between
struct SpikeIslandTrail : LevelGenerationProtocol {
    static var minDifficulty = 30
    static var maxDifficulty = 60

    var name = TrailTypes.SpikeIslandTrail.rawValue
    
    var difficulty = 0
    var length = 0
    
    var rows : [ResourceRow]!
    
    init(length: Int, difficulty : Int) {
        self.difficulty = difficulty
        self.length = length
        self.rows = generatePath()
    }
    
    mutating func generatePath() -> [ResourceRow] {
        var rows = [ResourceRow]()
        let diff = SpikeIslandTrail.maxDifficulty - SpikeIslandTrail.minDifficulty
        
        let moatLength = 1
        let islandFraction : Double = Double(difficulty - SpikeIslandTrail.minDifficulty)/(Double(diff) * 0.8)
        let islandLength = Int(2 * islandFraction) + 2
        for i in 0.stride(to: moatLength * 2 + islandLength, by: 1) {
            if i < moatLength || i > moatLength + islandLength - 1 {
                rows.append(ResourceRow(row: [.Rectangle, .Spike], depressedHeight: GameSettings.sharedSettings.rowWidth + CGFloat(i) * GameSettings.sharedSettings.triangleHeight))
            } else {
                rows.append(ResourceRow(row: [.Rectangle, .Triangle, .Spike], depressedHeight: 0))
            }
        }
        length = rows.count
        return rows
    }
}

/// Creates a moat with a spike at the beginning and end with an island in between over variable length
struct IslandTrail : LevelGenerationProtocol {
    static var minDifficulty = 30
    static var maxDifficulty = 60
    
    var difficulty = 0
    var length = 0
    
    var name = TrailTypes.IslandTrail.rawValue
    
    var rows : [ResourceRow]!
    
    init(length: Int, difficulty : Int) {
        self.difficulty = difficulty
        self.length = length
        self.rows = generatePath()
    }
    
    mutating func generatePath() -> [ResourceRow] {
        var rows = [ResourceRow]()
        let diff = IslandTrail.maxDifficulty - IslandTrail.minDifficulty
        
        let islandFraction : Double = Double(difficulty - IslandTrail.minDifficulty)/Double(IslandTrail.maxDifficulty)
        let islandLength = Int(ceil(6 * 1 - islandFraction))
        var moatLength = 2
        if difficulty > IslandTrail.maxDifficulty - diff/2 {
            moatLength = 3
        } else if difficulty > Int(Double(IslandTrail.maxDifficulty) * 0.9) {
            moatLength = 4
        }
        
        for i in 0.stride(to: moatLength * 2 + islandLength + 2, by: 1) {
            if i == 0 {
                rows.append(ResourceRow(row: [.Rectangle, .Spike], depressedHeight: 0))
            } else if i == moatLength * 2 + islandLength + 1 {
                rows.append(ResourceRow(row: [.Rectangle, .Triangle, .Spike], depressedHeight: 0))
            }else if i <= moatLength || i > moatLength + islandLength {
                rows.append(ResourceRow(row: [.Rectangle, .Spike], depressedHeight: GameSettings.sharedSettings.rowWidth + CGFloat(i) * GameSettings.sharedSettings.triangleHeight))
            } else {
                rows.append(ResourceRow(row: [.Rectangle, .Triangle], depressedHeight: 0))
            }
        }
        length = rows.count
        return rows
    }
}


// MARK: - Level mutating paths

/// The RampTrail creates a ramp that allows the user to go off a jump
struct RampTrail : LevelGenerationProtocol {
    static var minDifficulty = 20
    static var maxDifficulty = 50
    
    var name = TrailTypes.RampTrail.rawValue
    
    var difficulty: Int = 0
    var length: Int = 0
    
    var rows : [ResourceRow]!
    
    init(length: Int, difficulty : Int) {
        self.difficulty = difficulty
        self.length = length
        self.rows = generatePath()
    }
    
    mutating func generatePath() -> [ResourceRow] {
        var rows = [ResourceRow]()
        let triangleHeight : CGFloat = 10
        let depressedHeight = GameSettings.sharedSettings.triangleHeight - triangleHeight
        for i in 0.stride(to: length, by: 1) {
            var row = ResourceRow(row: [.Rectangle, .Triangle], depressedHeight: CGFloat(i) * depressedHeight)
            row.triangleHeight = triangleHeight
            row.detectRowContact = true
            
            if i < length * 4/5 {
                row.movementScalar = CGPoint(x:67 * (1 - (CGFloat(abs(length - i)) * 1.125)/CGFloat(length)), y: 0)
            }
            row.moveCar = true
            rows.append(row)
        }
        return rows
    }
}


// MARK: - Level ending paths

/// Has a flat path at the end of a level
struct FlatTrail : LevelGenerationProtocol {
    static var minDifficulty = 0
    static var maxDifficulty = 0
    
    var name = "FlatTrail"
    
    var difficulty = 0
    var length = 0
    
    var rows : [ResourceRow]!
    
    init(length: Int, difficulty : Int) {
        self.difficulty = difficulty
        self.length = length
        self.rows = generatePath()
    }
    
    mutating func generatePath() -> [ResourceRow] {
        var rows = [ResourceRow]()
        for i in 0.stride(through: max(4, length), by: 1) {
            // flat rows, similar to no roadblock, except each row is depressed by the height of the
            // triangle so it appears flat to the user
            rows.append(ResourceRow(row: [.Rectangle], depressedHeight: CGFloat(i) * GameSettings.sharedSettings.triangleHeight))
        }
        return rows
    }
}

/// Creates a set of empty rows at the end of a level so that it appears that there is a "cliff"
struct EmptyRowTrail : LevelGenerationProtocol {
    
    static var minDifficulty = 0
    static var maxDifficulty = 0
    
    var name = "EmptyRowTrail"
    
    var difficulty = 0
    var length = 0
    
    var rows : [ResourceRow]!
    
    init(length: Int, difficulty : Int) {
        self.difficulty = difficulty
        self.length = length
        self.rows = generatePath()
    }
    
    mutating func generatePath() -> [ResourceRow] {
        var rows = [ResourceRow]()
        for _ in 0.stride(to: length, by: 1) {
            // empty rows, nothing to see here
            rows.append(ResourceRow(row: [.None], depressedHeight: 0))
        }
        return rows
    }
}
