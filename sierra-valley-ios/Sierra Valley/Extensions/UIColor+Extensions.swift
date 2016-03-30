//
//  UIColor+Extensions.swift
//  Sierra Valley
//
//  Created by Jack Arendt on 1/18/16.
//  Copyright © 2016 John Arendt. All rights reserved.
//

import UIKit

extension UIColor {
    
    /// Initializes a UIColor with Int instead of Float values
    convenience init(r : Int, g : Int, b : Int, a : Int = 255) {
        self.init(red: CGFloat(r)/255.0, green: CGFloat(g)/255.0, blue: CGFloat(b)/255.0, alpha: CGFloat(a)/255.0)
    }
}

/// The SVColor is a color class that contains all of the colors used in the game
class SVColor {
    
    // MARK: - General colors
    
    /// The light color that is used throughout - #ffffff
    class func lightColor() -> UIColor {
        return UIColor.whiteColor()
    }
    
    /// The background color of the night sky
    class func darkColor() -> UIColor {
        return UIColor(r: 28, g: 28, b: 28)
    }
    
    /// MARK: - Level colors
    
    class func lightLevelPrimaryColorComponents() -> (r: Int, g: Int, b: Int) {
        return (22, 160, 133)
    }
    
    class func darkLevelPrimaryColorComponents() -> (r: Int, g: Int, b: Int) {
        return (16, 115, 96)
    }
    
    class func lightLevelSecondaryColorComponents() -> (r: Int, g: Int, b: Int) {
        return (34, 49, 63)
    }
    
    class func darkLevelSecondaryColorComponents() -> (r: Int, g: Int, b: Int) {
        return (16, 23, 30)
    }
    
    class func levelPrimaryColor() -> UIColor {
        let light = lightLevelPrimaryColorComponents()
        let dark = darkLevelPrimaryColorComponents()
        let color = timeConversion(light, dark: dark)
        return UIColor(r: color.r, g: color.g, b: color.b)
    }
    
    class func levelSecondaryColor() -> UIColor {
        let light = lightLevelSecondaryColorComponents()
        let dark = darkLevelSecondaryColorComponents()
        let color = timeConversion(light, dark: dark)
        return UIColor(r: color.r, g: color.g, b: color.b)
    }
    
    // MARK: - Background colors
    
    /// The color of the mountains during an avalanche
    class func avalancheColor() -> UIColor {
        return UIColor(r: 236, g: 240, b: 241)
    }
    
    class func lightBackgroundPrimaryColorComponents() -> (r: Int, g: Int, b: Int) {
        return (74, 84, 94)
    }
    
    class func darkBackgroundPrimaryColorComponents() -> (r: Int, g: Int, b: Int) {
        return (52, 59, 65)
    }
    
    class func lightBackgroundSecondaryColorComponents() -> (r: Int, g: Int, b: Int) {
        return (114, 127, 128)
    }
    
    class func darkBackgroundSecondaryColorComponents() -> (r: Int, g: Int, b: Int) {
        return (90, 100, 101)
    }
    
    class func backgroundPrimaryColor() -> UIColor {
        let light = lightBackgroundPrimaryColorComponents()
        let dark = darkBackgroundPrimaryColorComponents()
        let color = timeConversion(light, dark: dark)
        return UIColor(r: color.r, g: color.g, b: color.b)
    }
    
    class func backgroundSecondaryColor() -> UIColor {
        let light = lightBackgroundSecondaryColorComponents()
        let dark = darkBackgroundSecondaryColorComponents()
        let color = timeConversion(light, dark: dark)
        return UIColor(r: color.r, g: color.g, b: color.b)
    }
    
    private class func timeConversion(light : (r: Int, g: Int, b: Int), dark: (r: Int, g: Int, b: Int)) -> (r: Int, g: Int, b: Int) {
        let alpha = TimeManager.sharedManager.getAlphaForTime()
        let diff = (r: light.r - dark.r, g: light.g - dark.g, b: light.b - dark.b)
        return (light.r - Int(Float(diff.r) * alpha), light.g - Int(Float(diff.g) * alpha), light.b - Int(Float(diff.b) * alpha))
    }
}