//
//  AnalayticsManager.swift
//  Sierra Valley
//
//  Created by Jack Arendt on 4/9/16.
//  Copyright © 2016 John Arendt. All rights reserved.
//

import Foundation


public class AnalyticsManager {
    static public let sharedManager = AnalyticsManager()
    
    public func updateScreen(name : String) {
        if let tracker = GAI.sharedInstance().defaultTracker, builder = GAIDictionaryBuilder.createScreenView() {
            tracker.set(kGAIScreenName, value: name)
            tracker.send(builder.build() as [NSObject : AnyObject])
        } else {
            print("tracker is nil. cannot update")
        }
    }
    
    public func gameEnded(finalScore : Int, newAvalanches : Int) {
        let tracker = GAI.sharedInstance().defaultTracker
        let scoreDictionary = GAIDictionaryBuilder.createEventWithCategory("GameLoop", action: "Game Over", label: "score", value: finalScore)
        let avalancheDictionary = GAIDictionaryBuilder.createEventWithCategory("GameLoop", action: "Game Over", label: "avalanches", value: newAvalanches)
        
        let rows = finalScore * 10
        let seconds = CFTimeInterval(rows) * GameSettings.sharedSettings.rowRefreshRate
        
        let timeDictionary = GAIDictionaryBuilder.createTimingWithCategory("GameLoop", interval: seconds * 1000, name: "Game Over", label: "duration")
        
        tracker.send(scoreDictionary.build() as [NSObject : AnyObject])
        tracker.send(avalancheDictionary.build() as [NSObject : AnyObject])
        tracker.send(timeDictionary.build() as [NSObject : AnyObject])
    }
    
    public func sendDifficulty(difficulty : Int) {
        let tracker = GAI.sharedInstance().defaultTracker
        let difficultyDictionary = GAIDictionaryBuilder.createEventWithCategory("GameLoop", action: "Game Progress", label: "difficulty", value: difficulty)
        
        tracker.send(difficultyDictionary.build() as [NSObject : AnyObject])
    }
    
    public func sendTheme(theme : Int) {
        let tracker = GAI.sharedInstance().defaultTracker
        let themeDictionary = GAIDictionaryBuilder.createEventWithCategory("GameSupport", action: "Settings", label: "theme", value: theme)
        tracker.send(themeDictionary.build() as [NSObject : AnyObject])
    }
    
}