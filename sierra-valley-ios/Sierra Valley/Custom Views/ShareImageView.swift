//
//  ShareImageView.swift
//  Sierra Valley
//
//  Created by Jack Arendt on 4/12/16.
//  Copyright © 2016 John Arendt. All rights reserved.
//

import UIKit

class ShareImageView: UIView {
    init(car : SVCar, peak : Int, score : Int) {
        let frame = CGRect(x: 0, y: 0, width: 1920, height: 1080)
        super.init(frame: frame)
        let backgroundView = UIImageView(image: UIImage(asset: .Background))
        backgroundView.frame = bounds
        backgroundView.alpha = CGFloat(1 - TimeManager.sharedManager.getAlphaForTime())
        addSubview(backgroundView)
        
        let duskView = UIView(frame: bounds)
        duskView.backgroundColor = SVColor.darkColor()
        duskView.alpha = CGFloat(TimeManager.sharedManager.getAlphaForTime())
        addSubview(duskView)
        
        let mountainView = UIImageView(image : UIImage(asset: .ShareBackground))
        mountainView.frame = bounds
        addSubview(mountainView)
        
        let titleLabel = UILabel(frame: CGRect(origin: CGPoint.zero, size: CGSize(width: frame.width * 0.7, height: 160)))
        titleLabel.center = CGPoint(x: frame.width/2, y: 220)
        titleLabel.text = "SIERRA VALLEY"
        titleLabel.font = UIFont.svFont(160)
        titleLabel.textColor = SVColor.lightColor()
        titleLabel.textAlignment = .Center
        addSubview(titleLabel)
        
        
        let road = UIView(frame: CGRect(x: 0, y: bounds.height * 0.8, width: bounds.width, height: bounds.height * 0.2))
        road.backgroundColor = SVColor.levelPrimaryColor()
        addSubview(road)
        
        let carImageView = UIImageView(image: UIImage(car: car))
        carImageView.bounds = CGRect(origin: CGPoint.zero, size: CGSize(width: carImageView.image!.size.width * 2.5, height: carImageView.image!.size.height * 2.5))
        carImageView.center = CGPoint(x: bounds.width/2, y: bounds.height * 0.8 - carImageView.bounds.height/2)
        addSubview(carImageView)
        
        let distanceLabel = UILabel(frame: road.frame)
        if score == peak {
            distanceLabel.text = "NEW PEAK: \(peak)"
        } else {
            distanceLabel.text = "THIS CLIMB: \(score)\t\t\tPEAK: \(peak)"
        }
        distanceLabel.textColor = SVColor.lightColor()
        distanceLabel.font = UIFont.svHeavyFont(bounds.height * 0.075)
        distanceLabel.textAlignment = .Center
        addSubview(distanceLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func createImage() -> UIImage {
        UIGraphicsBeginImageContextWithOptions(bounds.size, opaque, UIScreen.mainScreen().scale)
        layer.renderInContext(UIGraphicsGetCurrentContext()!)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image
        
    }
}
