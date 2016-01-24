//
//  SVPauseBaseView.swift
//  Sierra Valley
//
//  Created by Jack Arendt on 1/23/16.
//  Copyright © 2016 John Arendt. All rights reserved.
//

import UIKit

class SVPauseBaseView: UIView {
    
    var titleText = "" {
        didSet {
           titleLabel.text = titleText
        }
    }
    
    var subtitleText = "" {
        didSet {
           subtitleLabel.text = subtitleText
        }
    }
    
    var distance = 60 {
        didSet {
            distanceLabel.text = String(format: "%i", distance)
        }
    }
    
    var avalanche = 25 {
        didSet {
            avalancheLabel.text = String(format: "%i", avalanche)
        }
    }
    
    var blinkSubtitle = true {
        didSet {
            if blinkSubtitle {
                subtitleLabel.alpha = 0
                blinkAnimation.blink()
            } else {
                blinkAnimation.stopBlink(true)
            }
        }
    }
    
    var tapGesture : UITapGestureRecognizer!
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    private let avalancheImageView = UIImageView(image: UIImage(asset: .Avalanche))
    private let avalancheLabel = UILabel()
    private let distanceLabel = UILabel()
    
    private var blinkAnimation : SVBlinkAnimation!

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        let backgroundView = UIImageView(image: UIImage(asset: .Background))
        backgroundView.frame = bounds
        backgroundView.alpha = 0.8
        addSubview(backgroundView)
        
        tapGesture = UITapGestureRecognizer(target: self, action: "tapGestureRecognized:")
        addGestureRecognizer(tapGesture)
        
        titleLabel.frame = CGRect(x: 40, y: bounds.height/2 - 65, width: bounds.width - 80, height: 50)
        titleLabel.textAlignment = .Center
        titleLabel.textColor = UIColor.whiteColor()
        titleLabel.font = UIFont.svFont(min(60, 0.16 * bounds.height))
        addSubview(titleLabel)
        
        subtitleLabel.frame = CGRect(x: 40, y: bounds.height/2 + 5, width: bounds.width - 80, height: 30)
        subtitleLabel.textAlignment = .Center
        subtitleLabel.textColor = UIColor.whiteColor()
        subtitleLabel.font = UIFont.svHeavyFont(min(60, 0.08 * bounds.height))
        addSubview(subtitleLabel)
        blinkAnimation = SVBlinkAnimation(view: subtitleLabel, duration: 3.0)
        
        avalancheImageView.frame = CGRect(x: bounds.width - 70, y: 25, width: 50, height: 50)
        addSubview(avalancheImageView)
        
        avalancheLabel.frame = CGRect(x: bounds.width/2, y: 20, width: bounds.width/2 - 80, height: 60)
        avalancheLabel.textColor = UIColor.whiteColor()
        avalancheLabel.text = String(format: "%i", avalanche)
        avalancheLabel.textAlignment = .Right
        avalancheLabel.font = UIFont.svFont(min(60, 0.16 * bounds.height))
        addSubview(avalancheLabel)
        
        distanceLabel.frame = CGRect(x: 20, y: 20, width: bounds.width/2 - 40, height: 60)
        distanceLabel.textColor = UIColor.whiteColor()
        distanceLabel.text = String(format: "%i", distance)
        distanceLabel.font = UIFont.svFont(min(60, 0.16 * bounds.height))
        addSubview(distanceLabel)
    }
    
    func tapGestureRecognized(gesture : UITapGestureRecognizer) {
        blinkAnimation.stopBlink(false)
    }
    
    func showMenu() {
        if blinkSubtitle {
            subtitleLabel.alpha = 0
            blinkAnimation.blink()
        }
    }
}
