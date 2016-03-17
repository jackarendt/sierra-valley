//
//  AvalancheAvoidedView.swift
//  Sierra Valley
//
//  Created by Jack Arendt on 3/16/16.
//  Copyright © 2016 John Arendt. All rights reserved.
//

import UIKit

class AvalancheAvoidedView: UIView {
    
    private let leftMountain = UIImageView(image: UIImage(asset: .Avalanche))
    private let rightMountain = UIImageView(image: UIImage(asset: .Avalanche))
    private let avoidedLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        avoidedLabel.text = "AVALANCHE AVOIDED"
        avoidedLabel.font = UIFont.svHeavyFont(min(30, 0.08 * UIScreen.mainScreen().bounds.height))
        avoidedLabel.textColor = UIColor.whiteColor()
        avoidedLabel.sizeToFit()
        avoidedLabel.center = CGPoint(x: bounds.width/2, y: bounds.height/2)
        addSubview(avoidedLabel)
        
        leftMountain.frame = CGRect(x: avoidedLabel.frame.origin.x - bounds.height - 10, y: 0, width: bounds.height, height: bounds.height)
        addSubview(leftMountain)
        
        rightMountain.frame = CGRect(x: avoidedLabel.frame.maxX + 10, y: 0, width: bounds.height, height: bounds.height)
        addSubview(rightMountain)
        
        alpha = 0
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    func showAvoidedView() {
        UIView.animateKeyframesWithDuration(4.0, delay: 0, options: .AllowUserInteraction, animations: {
            UIView.addKeyframeWithRelativeStartTime(0, relativeDuration: 0.1875, animations: {
                self.alpha = 1
            })
            
            UIView.addKeyframeWithRelativeStartTime(0.8125, relativeDuration: 0.1875, animations: {
                self.alpha = 0
            })
        }, completion: nil)
    }
}
