//
//  AnalayticsManager.swift
//  Sierra Valley
//
//  Created by Jack Arendt on 4/9/16.
//  Copyright © 2016 John Arendt. All rights reserved.
//

import Foundation
import Fabric
import Crashlytics

/// Handles all analytics operations for the game action
public final class AnalyticsManager {
    
    /// Initializes all of the analytics libraries
    public class func initializeAnalytics() {
        Fabric.with([Crashlytics.self])
    }
    
    
    /// Called when the game is started
    /// - Parameter car: The car that is being used to start the game
    public class func gameStarted(car : SVCar) {
        Answers.logLevelStart("GameLoop", customAttributes: ["car" : car.rawValue])
    }
    
    /// Called when the game has ended
    /// - Parameter finalScore: The final score of the game
    /// - Parameter newAvalanches: The number of avalanches passed per game
    /// - Parameter car: The car used to complete the game
    public class func gameEnded(finalScore : Int, newAvalanches : Int, car : SVCar) {
        Answers.logLevelEnd("GameLoop", score: finalScore, success: true, customAttributes: ["avalanches" : newAvalanches, "car" : car.rawValue])
    }
    
    /// Called to determine which theme is being used
    /// - Parameter theme: The theme being used
    public class func sendTheme(theme : GameTheme) {
        Answers.logCustomEventWithName("GameAttributes", customAttributes: ["theme" : theme.name()])
    }
    
    /// Called to send sound and music preferences preferences
    /// - Parameter sound: Whether sound is enabled
    /// - Parameter music: Whether music is enabled
    public class func sendSoundPreferences(sound : Bool, music : Bool) {
        let soundPlaying = sound ? "Sound" : "Muted"
        let musicPlaying = music ? "Music" : "Muted"
        Answers.logCustomEventWithName("GameAttributes", customAttributes: ["sound" : soundPlaying, "music" : musicPlaying])
    }
    
    /// Called to log which screen is currently in view
    /// - Parameter screenName: The name of the screen presented
    public class func logScreenView(screenName : String) {
        Answers.logCustomEventWithName("ScreenView", customAttributes: ["name" : screenName])
    }
    
    /// Called to log which home screen action was used
    /// - Parameter buttonName: The name of the button that was pressed
    public class func logHomeScreenActivity(buttonName : String) {
        Answers.logContentViewWithName("HomeScreen", contentType: "button", contentId: buttonName, customAttributes: nil)
    }
    
    /// Called when an action occurs on on the game screen
    /// - Parameter contentId: The button that was pressed on the game screen
    public class func logGameScreenActivity(contentId : String) {
        Answers.logContentViewWithName("GameScreen", contentType: "button", contentId: contentId, customAttributes: nil)
    }
    
    /// Called when a user shares the results of the game
    /// - Parameter activityType: The bundle ID of the share activity that was chosen
    /// - Parameter highScore: Whether the user shared their high score
    /// - Parameter finished: Whether the sharing was completed
    public class func share(activityType : String, highScore : Bool, finished : Bool) {
        let score = highScore ? "High Score" : "Normal"
        let completed = finished ? "Finished" : "Abandoned"
        Answers.logShareWithMethod(activityType, contentName: nil, contentType: "image", contentId: score, customAttributes: ["completed" : completed])
    }
    
    /// Called to determine whether game center is available
    /// - Parameter enabled: 
    public class func gameCenterEnabled(enabled: Bool, errorCode : Int?) {
        let en = enabled ? "Enabled" : "Disabled"
        var dict = ["Activation Status" : en]
        var code = ""
        if let errorCode = errorCode {
            code = String(errorCode)
            dict["Error Code"] = code
        }
        
        Answers.logCustomEventWithName("GameCenter", customAttributes: dict)
    }
    
}