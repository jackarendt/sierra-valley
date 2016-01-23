//
//  UIImage+Extensions.swift
//  Sierra Valley
//
//  Created by Jack Arendt on 1/18/16.
//  Copyright © 2016 John Arendt. All rights reserved.
//

import UIKit

/// Enumeration containing all images in the Asset Catalog
enum SVImage : String {
    case Avalanche = "avalanche"
    case BackButton = "back-button"
    case Background = "background"
    case CloseButton = "close-button"
    case Mountains = "mountains"
    case MuteIcon = "mute-icon"
    case VolumeIcon = "volume-icon"
}

enum SVCar : String {
    case SierraTurboLarge = "sierra-turbo-large"
}

extension UIImage {
    /// Initialize image using the SVImage enum
    convenience init!(asset: SVImage) {
        self.init(named: asset.rawValue)
    }
    
    convenience init!(car : SVCar) {
        self.init(named: car.rawValue)
    }
}