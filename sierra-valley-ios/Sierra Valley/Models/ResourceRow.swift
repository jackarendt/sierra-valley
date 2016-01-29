//
//  ResourceRow.swift
//  Sierra Valley
//
//  Created by Jack Arendt on 1/25/16.
//  Copyright © 2016 John Arendt. All rights reserved.
//

import SpriteKit

/// Represents the logic behind a row.  Does not hold any reference types.
public struct ResourceRow {
    
    /// height to drop the rectangle by, relative to its neighbors
    public var depressedHeight : CGFloat = 0
    
    /// The different types that make up that row.
    /// Maximum number are 3. [0] is the base (or first to be added), while the last idx is the top piece.
    ///
    /// Rectangle - 0, Triangle - 1, Spike - 2
    public var row = [UInt8]()
    
    
    public init(row : [SVSpriteName], depressedHeight : CGFloat) {
        var rows = [UInt8]()
        for sprite in row {
            rows.append(spriteNameToPiece(sprite))
        }
        self.row = rows
        self.depressedHeight = depressedHeight
    }
    
    /// Converts the row into a bunch of sprite names so that it's easily rendered
    public func rowPieces() -> Queue<SVSpriteName> {
        let queue = Queue<SVSpriteName>()
        for piece in row {
            queue.enqueue(pieceToSpriteName(piece))
        }
        return queue
    }
    
    private func pieceToSpriteName(piece : UInt8) -> SVSpriteName {
        let sprites : [SVSpriteName] =  [.Rectangle, .Triangle, .Spike]
        return sprites[Int(piece)]
    }
    
    private func spriteNameToPiece(name : SVSpriteName) -> UInt8 {
        let pieces : [SVSpriteName : UInt8] = [.Rectangle : 0, .Triangle : 1, .Spike : 2]
        return pieces[name]!
    }
}
