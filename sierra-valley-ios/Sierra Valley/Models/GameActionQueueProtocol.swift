//
//  GameActionProtocol.swift
//  Sierra Valley
//
//  Created by Jack Arendt on 2/11/16.
//  Copyright © 2016 John Arendt. All rights reserved.
//

import SpriteKit

/// The GameActionQueueProtocol contains a set of methods that standardize the behavior of moving
/// pieces in the background
protocol GameActionQueueProtocol {
    /// Adds an action to the game action queue
    /// - Parameter width: The width that the node needs to pan
    /// - Parameter height: The height that the node needs to pan
    /// - Parameter time: The time it takes to pan the node to the end point
    func enqueueGameAction(width : CGFloat, height : CGFloat, time : CFTimeInterval)
}
