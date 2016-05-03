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
    
    /// The height of the triangle to be rendered.  Defaults to settings triangle height
    public var triangleHeight : CGFloat = GameSettings.sharedSettings.triangleHeight
    
    /// If a row will osciallate, this is the oscillation period of the row
    public var oscillationPeriod : CFTimeInterval = 0
    
    /// Whether the row will oscillate or not
    public var oscillate : Bool = false
    
    /// Whether the row will drop out as soon it's touched
    public var dropOut : Bool = false
    
    /// The different types that make up that row.
    /// Maximum number are 3. [0] is the base (or first to be added), while the last idx is the top piece.
    ///
    /// Rectangle - 0, Triangle - 1, Spike - 2, blank - 3
    public var row = [UInt8]()
    
    /// If the row is empty this will be true
    public var isEmpty = false
    
    /// Initializes a row with a set of rows to be used and a height to drop the rectangle
    /// - Parameter row: The SVSpriteName representation of what a row will look like once it's rendered
    /// - Parameter depressedHeight: The height to drop a rectangle if there is a valley in the track
    public init(row : [SVSpriteName], depressedHeight : CGFloat) {
        var rows = [UInt8]()
        
        func spriteNameToPiece(name : SVSpriteName) -> UInt8 {
            let pieces : [SVSpriteName : UInt8] = [.Rectangle : 0, .Triangle : 1, .Spike : 2, .None : 3]
            return pieces[name]!
        }
        
        for sprite in row {
            let piece = spriteNameToPiece(sprite)
            if piece == 3 {
                isEmpty = true
            }
            rows.append(piece)
        }
        self.row = rows
        self.depressedHeight = depressedHeight
    }
}
