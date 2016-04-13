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

public final class AnalyticsManager {
    
    public class func initializeAnalytics() {
        Fabric.with([Crashlytics.self])
    }
    
    public class func gameStarted(car : SVCar) {
        Answers.logLevelStart("GameLoop", customAttributes: ["car" : car.rawValue])
    }
    
    public class func gameEnded(finalScore : Int, newAvalanches : Int, car : SVCar) {
        Answers.logLevelEnd("GameLoop", score: finalScore, success: true, customAttributes: ["avalanches" : newAvalanches, "car" : car.rawValue])
    }
    
    public class func sendTheme(theme : GameTheme) {
        Answers.logCustomEventWithName("GameAttributes", customAttributes: ["theme" : theme.name()])
    }
    
    public class func sendSoundPreferences(sound : Bool, music : Bool) {
        Answers.logCustomEventWithName("GameAttributes", customAttributes: ["sound" : sound, "music" : music])
    }
    
    public class func logScreenView(screenName : String) {
        Answers.logCustomEventWithName("ScreenView", customAttributes: ["name" : screenName])
    }
    
    public class func logHomeScreenActivity(buttonName : String) {
        Answers.logContentViewWithName("HomeScreen", contentType: "button", contentId: buttonName, customAttributes: nil)
    }
    
    public class func logGameScreenActivity(contentId : String) {
        Answers.logContentViewWithName("GameScreen", contentType: "button", contentId: contentId, customAttributes: nil)
    }
    
}