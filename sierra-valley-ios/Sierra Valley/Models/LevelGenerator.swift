//
//  LevelGenerator.swift
//  Sierra Valley
//
//  Created by Jack Arendt on 1/29/16.
//  Copyright © 2016 John Arendt. All rights reserved.
//

import UIKit


func computeLevel(difficulty : Int, queue : Queue<ResourceRow>) {
    while queue.count < 200 {
        var rows : [ResourceRow]!
        if arc4random() % 3 == 0 {
            rows = SpikeIslandTrail.generatePath(Int(30 + arc4random() % 41), suggestedLength: 0)
        } else {
            rows = NoRoadblockTrail.generatePath(0, suggestedLength: min(Int(arc4random() % 10 + 1), 200 - queue.count))
        }
        for row in rows {
            queue.enqueue(row)
        }
    }
    
    for row in FlatTrail.generatePath(0, suggestedLength: 5) {
        queue.enqueue(row)
    }
}

protocol LevelGenerationProtocol {
    static var minDifficulty : Int { get set }
    static var maxDifficulty : Int { get set }
    static func generatePath(difficulty : Int, suggestedLength: Int) -> [ResourceRow]
}

/// Adds a a bunch of spikes in a row on the level ground
struct SpikeTrail : LevelGenerationProtocol {
    static var minDifficulty = 5
    static var maxDifficulty = 25
    
    static func generatePath(difficulty: Int, suggestedLength: Int) -> [ResourceRow] {
        let spikes = Int(Double(difficulty - minDifficulty)/Double(maxDifficulty - minDifficulty) * 4) // maximum of 4 spikes
        var rows = [ResourceRow]()
        for _ in 0.stride(to: spikes, by: 1) {
            rows.append(ResourceRow(row: [.Rectangle, .Spike], depressedHeight: 0))
        }
        return rows
    }
}

/// no roadblocks, no difficulty here.
struct NoRoadblockTrail : LevelGenerationProtocol {
    static var minDifficulty = 0
    static var maxDifficulty = 0
    
    static func generatePath(difficulty: Int, suggestedLength: Int) -> [ResourceRow] {
        var rows = [ResourceRow]()
        for _ in 0.stride(to: suggestedLength, by: 1) {
            rows.append(ResourceRow(row: [.Rectangle, .Triangle], depressedHeight: 0))
        }
        return rows
    }
}

struct IslandTrail : LevelGenerationProtocol {
    static var minDifficulty = 50
    static var maxDifficulty = 90
    
    static func generatePath(difficulty: Int, suggestedLength: Int) -> [ResourceRow] {
        var rows = [ResourceRow]()
        let diff = maxDifficulty - minDifficulty

        let islandFraction : Double = Double(difficulty - minDifficulty)/Double(maxDifficulty)
        let islandLength = Int(6 * 1 - islandFraction)
        print(islandLength)
        var moatLength = 1
        if difficulty > maxDifficulty - diff/2 {
            moatLength = 2
        }
        
        for i in 0.stride(to: moatLength * 2 + islandLength, by: 1) {
            if i < moatLength || i > moatLength + islandLength - 1{
                rows.append(ResourceRow(row: [.Rectangle, .Spike], depressedHeight: CGFloat(30 + i * 4)))
            } else {
                rows.append(ResourceRow(row: [.Rectangle, .Triangle], depressedHeight: 0))
            }
        }
        return rows
    }
}

struct SpikeIslandTrail : LevelGenerationProtocol {
    static var minDifficulty = 30
    static var maxDifficulty = 70
    
    static func generatePath(difficulty: Int, suggestedLength: Int) -> [ResourceRow] {
        var rows = [ResourceRow]()
        let diff = maxDifficulty - minDifficulty
        
        let moatLength = 1
        let islandFraction : Double = Double(difficulty - minDifficulty)/(Double(diff) * 0.8)
        let islandLength = Int(2 * islandFraction) + 1
        for i in 0.stride(to: moatLength * 2 + islandLength, by: 1) {
            if i < moatLength || i > moatLength + islandLength - 1{
                rows.append(ResourceRow(row: [.Rectangle, .Spike], depressedHeight: CGFloat(30 + i * 4)))
            } else if islandLength == 3 && i == 2 {
                rows.append(ResourceRow(row: [.Rectangle, .Triangle], depressedHeight: 0))
            } else {
                rows.append(ResourceRow(row: [.Rectangle, .Spike], depressedHeight: 0))
            }
        }
        return rows
    }
}

/// Has a flat path at the end of a
struct FlatTrail : LevelGenerationProtocol {
    static var minDifficulty = 0
    static var maxDifficulty = 10
    
    static func generatePath(difficulty: Int, suggestedLength: Int) -> [ResourceRow] {
        var rows = [ResourceRow]()
        for i in 0.stride(through: max(4, suggestedLength), by: 1) {
            rows.append(ResourceRow(row: [.Rectangle], depressedHeight: CGFloat(i * 4)))
        }
        return rows
    }
}


struct SpikePitTrail : LevelGenerationProtocol {
    static var minDifficulty = 10
    static var maxDifficulty = 50
    
    static func generatePath(difficulty: Int, suggestedLength: Int) -> [ResourceRow] {
        var rows = [ResourceRow]()
        for i in 0.stride(to: suggestedLength, by: 1) {
            rows.append(ResourceRow(row: [.Rectangle, .Spike], depressedHeight: CGFloat(30 + i * 4)))
        }
        return rows
    }
}
