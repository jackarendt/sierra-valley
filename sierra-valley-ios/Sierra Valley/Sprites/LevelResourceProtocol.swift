//
//  LevelResourceProtocol.swift
//  Sierra Valley
//
//  Created by Jack Arendt on 1/24/16.
//  Copyright © 2016 John Arendt. All rights reserved.
//

import SpriteKit

/// The LevelResourceProtocol is a protocol for creating similar level resources.
/// Its main objective is to allow for easy interoperability of different level pieces
/// and quick initializations of different pieces without fidgeting different initializers
/// or properties.
protocol LevelResourceProtocol {
    /// Initializes a level resource
    /// - Parameter position: The position for the resource
    /// - Parameter color: The color of the resource
    /// - Parameter resrouceSize: The size of the resource (for some pieces, this will not be used, and will simply be ignored)
    init(position : CGPoint, color : UIColor, resourceSize : CGSize)
    
    var categoryBitMask : UInt32 { get set }
    
    /// Boolean denoting whether that sprite has special behavior.
    var hasSpecialBehavior : Bool { get set }
    
    /// The vector that the special behavior will perform
    var specialBehaviorAction : CGVector { get set }
    
    /// The node to have the special action performed on
    var specialActionNode : SKNode? { get set }
}