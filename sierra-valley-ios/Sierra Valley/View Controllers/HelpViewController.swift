//
//  HelpViewController.swift
//  Sierra Valley
//
//  Created by Jack Arendt on 1/22/16.
//  Copyright © 2016 John Arendt. All rights reserved.
//

import UIKit
import SpriteKit

class HelpViewController: SVBaseViewController {

    let tryItOutLabel = UILabel()
    
    var tapAnimationView : TapAnimationView!
    
    var leftArrow : Arrow!
    var rightArrow : Arrow!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationTitle = "HELP"
        leftNavigationButton.setImage(UIImage(asset: .BackButton), forState: .Normal)
        // Do any additional setup after loading the view.
        
        tapAnimationView = TapAnimationView(frame: CGRect(x: 0, y: 0, width: 35, height: 35))
        contentView.addSubview(tapAnimationView)
        tapAnimationView.center = CGPoint(x: contentView.bounds.width * 0.80, y: navigationTitleLabel.frame.maxY + 60)
        
        leftArrow = Arrow(frame: CGRect(x: 0, y: 0, width: 100, height: 20), direction: .Left)
        contentView.addSubview(leftArrow)
        leftArrow.center = CGPoint(x: contentView.bounds.width * 0.20 - 7.5, y: navigationTitleLabel.frame.maxY + 65)
        
        rightArrow = Arrow(frame: CGRect(x: 0, y: 0, width: 100, height: 20), direction: .Right)
        contentView.addSubview(rightArrow)
        rightArrow.center = CGPoint(x: contentView.bounds.width * 0.20 + 7.5, y: navigationTitleLabel.frame.maxY + 55)
        
        let swipeLabel = UILabel(frame: CGRect(x: leftArrow.frame.origin.x, y: rightArrow.frame.origin.y - 40, width: rightArrow.frame.maxX - leftArrow.frame.origin.x, height: 35))
        swipeLabel.text = "SWIPE"
        swipeLabel.textColor = UIColor.whiteColor()
        swipeLabel.textAlignment = .Center
        swipeLabel.font = UIFont.svFont(32)
        contentView.addSubview(swipeLabel)
        
        let swipeSublabel = UILabel(frame: CGRect(x: swipeLabel.frame.origin.x, y: leftArrow.frame.maxY + 15, width: swipeLabel.frame.width, height: 50))
        swipeSublabel.text = "TO CHANGE\nDIRECTIONS"
        swipeSublabel.textColor = UIColor.whiteColor()
        swipeSublabel.textAlignment = .Center
        swipeSublabel.font = UIFont.svHeavyFont(18)
        swipeSublabel.numberOfLines = 2
        contentView.addSubview(swipeSublabel)
        
        
        let tapLabel = UILabel(frame: CGRect(x: tapAnimationView.frame.origin.x - 30, y: swipeLabel.frame.origin.y, width: tapAnimationView.frame.width + 60, height: swipeLabel.frame.height))
        tapLabel.text = "TAP"
        tapLabel.textColor = UIColor.whiteColor()
        tapLabel.textAlignment = .Center
        tapLabel.font = UIFont.svFont(32)
        contentView.addSubview(tapLabel)
        
        let tapSublabel = UILabel(frame: CGRect(x: tapLabel.frame.origin.x - 20, y: swipeSublabel.frame.origin.y, width: tapLabel.frame.width + 40, height: 20))
        tapSublabel.text = "TO JUMP"
        tapSublabel.textColor = UIColor.whiteColor()
        tapSublabel.textAlignment = .Center
        tapSublabel.font = UIFont.svHeavyFont(18)
        contentView.addSubview(tapSublabel)
        
        
        let skView = SKView(frame: CGRect(x: 0, y: navigationTitleLabel.frame.maxY, width: contentView.bounds.width, height: contentView.bounds.height - navigationTitleLabel.frame.maxY))
        let scene = HelpCarScene(size: skView.bounds.size)
        
        /* Sprite Kit applies additional optimizations to improve rendering performance */
        skView.ignoresSiblingOrder = true
        
        /* Set the scale mode to scale to fit the window */
        scene.scaleMode = .AspectFill
        print(scene)
        skView.presentScene(scene)
        contentView.addSubview(skView)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        tapAnimationView.animate()
    }
    
    override func leftNavigationButtonTapped(button: UIButton) {
        dismissViewControllerAnimated(true, completion: nil)
    }
}
