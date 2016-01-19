//
//  HomeViewController.swift
//  Sierra Valley
//
//  Created by Jack Arendt on 1/18/16.
//  Copyright © 2016 John Arendt. All rights reserved.
//

import UIKit
import SpriteKit

/// The root view controller
class HomeViewController: SVBaseViewController {
    
    let logoLabel = UILabel()
    let tapToPlayLabel = UILabel()
    
    let settingsButton = UIButton()
    let chooseCarButton = UIButton()
    
    var animationsFinished = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
        logoLabel.text = "SIERRA VALLEY"
        logoLabel.textColor = UIColor.whiteColor()
        logoLabel.textAlignment = .Center
        logoLabel.font = UIFont.svFont(72)
        logoLabel.minimumScaleFactor = 0.7
        logoLabel.adjustsFontSizeToFitWidth = true
        logoLabel.frame = CGRect(x: 35, y: view.bounds.height, width: view.bounds.width - 70, height: 100) // put at bottom
        logoLabel.alpha = 0
        view.addSubview(logoLabel)
        
        
        let mountains = UIImage(asset: .Mountains)
        let mountainsImageView = UIImageView(image: mountains)
        let mountainWidth = view.bounds.width - 200
        let mountainHeight = 0.375 * mountainWidth
        mountainsImageView.frame = CGRect(x: 100, y: view.bounds.height - mountainHeight, width: mountainWidth, height: mountainHeight)
        view.addSubview(mountainsImageView)
        

        tapToPlayLabel.text = "TAP TO PLAY"
        tapToPlayLabel.textColor = UIColor.whiteColor()
        tapToPlayLabel.textAlignment = .Center
        tapToPlayLabel.font = UIFont.svHeavyFont(30)
        tapToPlayLabel.minimumScaleFactor = 0.7
        tapToPlayLabel.adjustsFontSizeToFitWidth = true
        tapToPlayLabel.frame = CGRect(x: 75, y: 130, width: view.bounds.width - 150, height: 35)
        tapToPlayLabel.alpha = 0
        view.addSubview(tapToPlayLabel)
        
        let settingsExpandedButton = UIButton(frame: CGRect(x: view.bounds.width - 225, y: view.bounds.height - 100, width: 225, height: 100))
        // currently not adding extra space for hit box
//        settingsExpandedButton.addTarget(self, action: "settingsButtonTapped", forControlEvents: .TouchUpInside)
        view.addSubview(settingsExpandedButton)
        
        settingsButton.frame = CGRect(x: view.bounds.width - 150, y: view.bounds.height - 50, width: 150, height: 50)
        settingsButton.titleLabel?.font = UIFont.svHeavyFont(20)
        settingsButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        settingsButton.setTitleColor(UIColor(white: 1, alpha: 0.7), forState: .Highlighted)
        settingsButton.setTitle("SETTINGS", forState: .Normal)
        settingsButton.alpha = 0
        settingsButton.addTarget(self, action: "settingsButtonTapped", forControlEvents: .TouchUpInside)
        view.addSubview(settingsButton)
        
        // larger hit boxes for the choose car button so that there are no accidental taps
        let chooseCarExpandedButton = UIButton(frame: CGRect(x: 0, y: view.bounds.height - 100, width: 225, height: 100))
//        chooseCarExpandedButton.addTarget(self, action: "chooseCarButtonTapped", forControlEvents: .TouchUpInside)
        view.addSubview(chooseCarExpandedButton)
        
        chooseCarButton.frame = CGRect(x: 0, y: view.bounds.height - 50, width: 150, height: 50)
        chooseCarButton.titleLabel?.font = UIFont.svHeavyFont(20)
        chooseCarButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        chooseCarButton.setTitleColor(UIColor(white: 1, alpha: 0.7), forState: .Highlighted)
        chooseCarButton.setTitle("CHOOSE CAR", forState: .Normal)
        chooseCarButton.alpha = 0
        chooseCarButton.addTarget(self, action: "chooseCarButtonTapped", forControlEvents: .TouchUpInside)
        view.addSubview(chooseCarButton)
        
        // add tap gesture to start the game
        let tapGesture = UITapGestureRecognizer(target: self, action: "startGame")
        view.addGestureRecognizer(tapGesture)
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        UIView.animateWithDuration(0.75, delay: 0, options: .CurveLinear, animations: {
            // raise the logo from the bottom of the screen
            self.logoLabel.frame = CGRect(x: 35, y: 35, width: self.view.bounds.width - 70, height: 100)
            self.logoLabel.alpha = 1
        }, completion: { finished in
            self.blinkTapToPlay() // blink the tap to play label
            UIView.animateWithDuration(0.75, animations: {
                // show the buttons
                self.settingsButton.alpha = 1
                self.chooseCarButton.alpha = 1
            }, completion:  { finished in
                self.animationsFinished = true // set flag so that
            })
        })
    }
    
    // blinks the tap to play label
    private func blinkTapToPlay() {
        UIView.animateKeyframesWithDuration(3, delay: 0, options: .Repeat, animations: {
            UIView.addKeyframeWithRelativeStartTime(0, relativeDuration: 0.25, animations: {
                self.tapToPlayLabel.alpha = 1
            })
            UIView.addKeyframeWithRelativeStartTime(0.75, relativeDuration: 0.25, animations: {
                self.tapToPlayLabel.alpha = 0
            })
        }, completion: nil)
    }
    
    // segues to settings page
    func settingsButtonTapped() {
        print("settings tapped")
    }
    
    // segues to choosing the car
    func chooseCarButtonTapped() {
        print("choose car tapped")
    }
    
    // segues to start the game
    func startGame() {
        guard animationsFinished else {
            print("not so fast")
            return
        }
        print("start game")
    }
}
