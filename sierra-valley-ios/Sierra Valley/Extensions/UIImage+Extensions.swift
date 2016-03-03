//
//  UIImage+Extensions.swift
//  Sierra Valley
//
//  Created by Jack Arendt on 1/18/16.
//  Copyright © 2016 John Arendt. All rights reserved.
//

import UIKit

/// Enumeration containing all images in the Asset Catalog
public enum SVImage : String {
    case Avalanche = "avalanche"
    case BackButton = "back-button"
    case Background = "background"
    case CloseButton = "close-button"
    case Mountains = "mountains"
    case MuteIcon = "mute-icon"
    case PauseIcon = "pause"
    case VolumeIcon = "volume-icon"
}

public enum SVCar : String {
    case SierraTurbo = "sierra-turbo"
    case SierraTurboLarge = "sierra-turbo-large"
}

public enum SVLevelResource : String {
    case Spike = "spike"
    case Rectangle = "rectangle"
    case Triangle = "triangle"
    case ParallaxBackground = "parallax-background"
    case AvalancheParallaxBackground = "avalanche-parallax-background"
    case LightParallaxBackground = "light-parallax-background"
    case DarkParallaxBackground = "dark-parallax-background"
}

extension UIImage {
    /// Initialize image using the SVImage enum
    convenience init!(asset: SVImage) {
        self.init(named: asset.rawValue)
    }
    
    convenience init!(car : SVCar) {
        self.init(named: car.rawValue)
    }
    
    convenience init!(resource : SVLevelResource) {
        self.init(named: resource.rawValue)
    }
}