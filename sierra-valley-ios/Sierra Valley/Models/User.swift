//
//  User.swift
//  Sierra Valley
//
//  Created by Jack Arendt on 4/3/16.
//  Copyright © 2016 John Arendt. All rights reserved.
//

import Foundation

/// The User class represents the user of the game
public class User {
    
    /// The high score of the user
    public var highScore = 0
    
    /// The number of avalanches that are currently being collected
    public var avalanches = 0
    
    /// The number of total avalanches the user has passed
    public var totalAvalanches = 0
    
    /// The number of games played
    public var gamesPlayed = 0
    
    /// Called when a game has been finished. Updates the DB with new information
    public func gamePlayed(score score : Int, newAvalanches : Int) {
        avalanches += newAvalanches
        totalAvalanches += newAvalanches
        gamesPlayed += 1
        
        if highScore < score {
            highScore = score
        }
        Database.database.save()
    }
}