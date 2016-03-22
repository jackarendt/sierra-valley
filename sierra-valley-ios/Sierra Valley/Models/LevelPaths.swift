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
    
    // Creates a new object with a length and difficulty
    init(length : Int, difficulty : Int)
}

// MARK: - Paths


/// no roadblocks, no difficulty here.
struct NoRoadblockTrail : LevelGenerationProtocol {
    static var minDifficulty = 0
    static var maxDifficulty = 0
    
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
    
    var difficulty = 0
    var length = 0
    
    var rows : [ResourceRow]!
    
    init(length: Int, difficulty : Int) {
        self.difficulty = difficulty
        self.length = length
        self.rows = generatePath()
    }

    mutating func generatePath() -> [ResourceRow] {
        length = Int(Double(difficulty - SpikeTrail.minDifficulty)/Double(SpikeTrail.maxDifficulty - SpikeTrail.minDifficulty) * 4) // maximum of 4 spikes
        var rows = [ResourceRow]()
        for _ in 0.stride(to: length, by: 1) {
            rows.append(ResourceRow(row: [.Rectangle, .Triangle, .Spike], depressedHeight: 0))
        }
        return rows
    }
}


struct SpikePitTrail : LevelGenerationProtocol {
    static var minDifficulty = 10
    static var maxDifficulty = 50
    
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
        if difficulty > Int(Double(SpikePitTrail.maxDifficulty) * 0.4) {
            length = 1
        } else if difficulty > Int(Double(SpikePitTrail.maxDifficulty) * 0.6) {
            length = 2
        } else if difficulty > Int(Double(SpikeTrail.maxDifficulty) * 0.8){
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
        let islandLength = Int(2 * islandFraction) + 1
        for i in 0.stride(to: moatLength * 2 + islandLength, by: 1) {
            if i < moatLength || i > moatLength + islandLength - 1{
                rows.append(ResourceRow(row: [.Rectangle, .Spike], depressedHeight: GameSettings.sharedSettings.rowWidth + CGFloat(i) * GameSettings.sharedSettings.triangleHeight))
            } else if islandLength == 3 && i == 2 {
                rows.append(ResourceRow(row: [.Rectangle, .Triangle], depressedHeight: 0))
            } else {
                rows.append(ResourceRow(row: [.Rectangle, .Spike], depressedHeight: 0))
            }
        }
        length = rows.count
        return rows
    }
}

struct IslandTrail : LevelGenerationProtocol {
    static var minDifficulty = 50
    static var maxDifficulty = 90
    
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
        let diff = IslandTrail.maxDifficulty - IslandTrail.minDifficulty
        
        let islandFraction : Double = Double(difficulty - IslandTrail.minDifficulty)/Double(IslandTrail.maxDifficulty)
        let islandLength = Int(6 * 1 - islandFraction)
        var moatLength = 1
        if difficulty > IslandTrail.maxDifficulty - diff/2 {
            moatLength = 2
        }
        
        for i in 0.stride(to: moatLength * 2 + islandLength, by: 1) {
            if i < moatLength || i > moatLength + islandLength - 1{
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
