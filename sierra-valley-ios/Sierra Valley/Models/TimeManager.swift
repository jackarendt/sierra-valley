//
//  TimeManager.swift
//  Sierra Valley
//
//  Created by Jack Arendt on 3/27/16.
//  Copyright © 2016 John Arendt. All rights reserved.
//

import Foundation

/// Keeps track of the time, and different time zones
public class TimeManager {
    public static let sharedManager = TimeManager()
    
    private let timePath = NSBundle.mainBundle().URLForResource("time", withExtension: "plist")
    
    private var sunrise : Int = -1
    private var sunset : Int = -1
    private var dawn : Int = -1
    private var dusk : Int = -1
    
    private var timeDescription = ""
    
    /// Creates a new instance of a time manager by reading the plist from a path
    init() {
        if let path = timePath {
            let data = NSData(contentsOfURL: path)!
            do {
                let info = try NSPropertyListSerialization.propertyListWithData(data, options: .Immutable, format: nil) as! [String : AnyObject]
                
                if let sr = info["sunrise"] as? Int {
                    sunrise = sr
                }
                
                if let ss = info["sunset"] as? Int {
                    sunset = ss
                }
                
                if let da = info["dawn"] as? Int {
                    dawn = da
                }
                
                if let du = info["dusk"] as? Int {
                    dusk = du
                }
                
                if let desc = info["description"] as? String {
                    timeDescription = desc
                }
            } catch {
                print(error)
            }
        }
    }
    
    /// Gets the alpha value based on the time of day
    /// - Note: reads the settings, and returns a value based on the theme that was selected
    /// - Returns: The alpha for the dusk view
    public func getAlphaForTime() -> Float {
        
        let settings = Settings()
        if settings.theme == GameTheme.Day {
            return 0
        } else if settings.theme == GameTheme.Night {
            return 1
        }
        
        let hour = NSCalendar.currentCalendar().component(.Hour, fromDate: NSDate())
        let minute = NSCalendar.currentCalendar().component(.Minute, fromDate: NSDate())
        
        // night time
        if hour > dusk || hour < dawn {
            return 1.0
        }
        
        // day time
        if hour > sunrise && hour < sunset {
            return 0.0
        }
        
        // sunrise
        if hour >= dawn && hour <= sunrise {
            let diff : Float  = Float(hour - dawn) + Float(minute)/60
            let range = Float(sunrise - dawn)
            return 1 - diff/range
        }
        
        // sunset
        if hour >= sunset && hour <= dusk {
            let diff : Float  = Float(hour - sunset) + Float(minute)/60
            let range = Float(dusk - sunset)
            return diff/range
        }
        
        return 0.0
    }
}