//
//  SVPauseBaseView.swift
//  Sierra Valley
//
//  Created by Jack Arendt on 1/23/16.
//  Copyright © 2016 John Arendt. All rights reserved.
//

import UIKit

/// The SVPauseBaseView is what is shown when the user either pauses the game, or the game has ended.
/// It shows things like the score of the game, along with the avalanche information, and specific screen functionality
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
    
    var distance = 0 {
        didSet {
            distanceLabel.text = String(format: "%i", distance)
        }
    }
    
    var avalanche = 0 {
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
    let titleLabel = UILabel()
    let subtitleLabel = UILabel()
    let avalancheImageView = UIImageView(image: UIImage(asset: .Avalanche))
    let avalancheLabel = UILabel()
    let distanceLabel = UILabel()
    
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
        
        let baseAlpha : CGFloat = 0.7
        
        let backgroundView = UIImageView(image: UIImage(asset: .Background))
        backgroundView.frame = bounds
        backgroundView.alpha = baseAlpha * CGFloat(1 - TimeManager.sharedManager.getAlphaForTime())
        addSubview(backgroundView)
        
        let duskView = UIView(frame: bounds)
        duskView.backgroundColor = SVColor.darkColor()
        duskView.alpha = baseAlpha * CGFloat(TimeManager.sharedManager.getAlphaForTime())
        addSubview(duskView)
        
        
        tapGesture = UITapGestureRecognizer(target: self, action: #selector(SVPauseBaseView.tapGestureRecognized(_:)))
        addGestureRecognizer(tapGesture)
        
        titleLabel.frame = CGRect(x: 40, y: bounds.height/2 - 55, width: bounds.width - 80, height: 50)
        titleLabel.textAlignment = .Center
        titleLabel.textColor = SVColor.lightColor()
        titleLabel.font = UIFont.svFont(min(60, 0.16 * bounds.height))
        addSubview(titleLabel)
        
        subtitleLabel.frame = CGRect(x: 40, y: bounds.height/2 + 5, width: bounds.width - 80, height: 30)
        subtitleLabel.textAlignment = .Center
        subtitleLabel.textColor = SVColor.lightColor()
        subtitleLabel.font = UIFont.svHeavyFont(min(60, 0.08 * bounds.height))
        addSubview(subtitleLabel)
        blinkAnimation = SVBlinkAnimation(view: subtitleLabel, duration: 3.0)
        
        avalancheImageView.frame = CGRect(x: bounds.width - 70, y: 10, width: 50, height: 50)
        addSubview(avalancheImageView)
        
        avalancheLabel.frame = CGRect(x: bounds.width/2, y: 5, width: bounds.width/2 - 80, height: 60)
        avalancheLabel.textColor = SVColor.lightColor()
        avalancheLabel.text = String(format: "%i", avalanche)
        avalancheLabel.textAlignment = .Right
        avalancheLabel.font = UIFont.svFont(min(60, 0.16 * bounds.height))?.monospacedDigitFont
        addSubview(avalancheLabel)
        
        distanceLabel.frame = CGRect(x: 20, y: 5, width: bounds.width/2 - 40, height: 60)
        distanceLabel.textColor = SVColor.lightColor()
        distanceLabel.text = String(format: "%i", distance)
        distanceLabel.font = UIFont.svFont(min(60, 0.16 * bounds.height))?.monospacedDigitFont
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
