//
//  LevelPaths.swift
//  Sierra Valley
//
//  Created by Jack Arendt on 3/19/16.
//  Copyright © 2016 John Arendt. All rights reserved.
//

import Foundation

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
            rows.append(ResourceRow(row: [.Rectangle, .Triangle], depressedHeight: 0))
        }
        return rows
    }
}

// MARK: - Basic Obstacles

/// Adds a a bunch of spikes in a row on the level ground
struct SpikeTrail : LevelGenerationProtocol {
    static var minDifficulty = 5
    static var maxDifficulty = 25

    var name = TrailTypes.SpikeTrail.rawValue
    
    var difficulty = 0
    var length = 0
    
    var rows : [ResourceRow]!
    
    init(length: Int, difficulty : Int) {
        self.difficulty = difficulty
        self.length = length
        self.rows = generatePath()
    }

    mutating func generatePath() -> [ResourceRow] {
        length = Int(ceil(Double(difficulty - SpikeTrail.minDifficulty)/Double(SpikeTrail.maxDifficulty - SpikeTrail.minDifficulty) * 4)) // maximum of 5 spikes
        var rows = [ResourceRow]()
        for _ in 0.stride(to: length, by: 1) {
            rows.append(ResourceRow(row: [.Rectangle, .Triangle, .Spike], depressedHeight: 0))
        }
        return rows
    }
}


struct SpikePitTrail : LevelGenerationProtocol {
    static var minDifficulty = 20
    static var maxDifficulty = 50

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
        if difficulty > Int(Double(SpikePitTrail.maxDifficulty) * 0.57) {
            length = 2
        } else if difficulty > Int(Double(SpikeTrail.maxDifficulty) * 0.78){
            length = 3
        } else {
            length = 4
        }
        for i in 0.stride(to: length, by: 1) {
            rows.append(ResourceRow(row: [.Rectangle, .Spike], depressedHeight: GameSettings.sharedSettings.rowWidth + CGFloat(i) * GameSettings.sharedSettings.triangleHeight))
        }
        return rows
    }
}


// MARK: - Advanced obstacles

struct SpikeIslandTrail : LevelGenerationProtocol {
    static var minDifficulty = 30
    static var maxDifficulty = 70

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
            if i == 0 || i == moatLength * 2 + islandLength + 1 {
                rows.append(ResourceRow(row: [.Rectangle, .Triangle, .Spike], depressedHeight: 0))
            } else if i <= moatLength || i > moatLength + islandLength {
                rows.append(ResourceRow(row: [.Rectangle, .Spike], depressedHeight: GameSettings.sharedSettings.rowWidth + CGFloat(i) * GameSettings.sharedSettings.triangleHeight))
            } else {
                rows.append(ResourceRow(row: [.Rectangle, .Triangle], depressedHeight: 0))
            }
        }
        length = rows.count
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
            rows.append(ResourceRow(row: [.Rectangle], depressedHeight: CGFloat(i) * GameSettings.sharedSettings.triangleHeight))
        }
        return rows
    }
}

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
            rows.append(ResourceRow(row: [.None], depressedHeight: 0))
        }
        return rows
    }
}
