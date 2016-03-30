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
    
    typealias ColorComponents = (r: Int, g: Int, b: Int)
    
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
    
    private class func lightLevelPrimaryColorComponents() -> ColorComponents {
        return (22, 160, 133)
    }
    
    private class func darkLevelPrimaryColorComponents() -> ColorComponents {
        return (16, 115, 96)
    }
    
    private class func lightLevelSecondaryColorComponents() -> ColorComponents {
        return (34, 49, 63)
    }
    
    private class func darkLevelSecondaryColorComponents() -> ColorComponents {
        return (16, 23, 30)
    }
    
    class func levelPrimaryColor() -> UIColor {
        let color = timeConversion(lightLevelPrimaryColorComponents, dark: darkLevelPrimaryColorComponents)
        return UIColor(r: color.r, g: color.g, b: color.b)
    }
    
    class func levelSecondaryColor() -> UIColor {
        let color = timeConversion(lightLevelSecondaryColorComponents, dark: darkLevelSecondaryColorComponents)
        return UIColor(r: color.r, g: color.g, b: color.b)
    }
    
    // MARK: - Background colors
    
    /// The color of the mountains during an avalanche
    class func avalancheColor() -> UIColor {
        return UIColor(r: 236, g: 240, b: 241)
    }
    
    private class func lightBackgroundPrimaryColorComponents() -> ColorComponents {
        return (74, 84, 94)
    }
    
    private class func darkBackgroundPrimaryColorComponents() -> ColorComponents {
        return (52, 59, 65)
    }
    
    private class func lightBackgroundSecondaryColorComponents() -> ColorComponents {
        return (114, 127, 128)
    }
    
    private class func darkBackgroundSecondaryColorComponents() -> ColorComponents {
        return (90, 100, 101)
    }
    
    class func backgroundPrimaryColor() -> UIColor {
        let color = timeConversion(lightBackgroundPrimaryColorComponents, dark: darkBackgroundPrimaryColorComponents)
        return UIColor(r: color.r, g: color.g, b: color.b)
    }
    
    class func backgroundSecondaryColor() -> UIColor {
        let color = timeConversion(lightBackgroundSecondaryColorComponents, dark: darkBackgroundSecondaryColorComponents)
        return UIColor(r: color.r, g: color.g, b: color.b)
    }
    
    private class func timeConversion(light : () -> ColorComponents, dark: () -> ColorComponents) -> ColorComponents {
        let l = light()
        let d = dark()
        let alpha = TimeManager.sharedManager.getAlphaForTime()
        let diff = (r: l.r - d.r, g: l.g - d.g, b: l.b - d.b)
        return (l.r - Int(Float(diff.r) * alpha), l.g - Int(Float(diff.g) * alpha), l.b - Int(Float(diff.b) * alpha))
    }
}