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
    
    var blinkAnimation = SVBlinkAnimation()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        gaName = "Home" // set the name for Google Analytics
        
        logoLabel.text = "SIERRA VALLEY"
        logoLabel.textColor = SKColor.whiteColor()
        logoLabel.textAlignment = .Center
        logoLabel.font = UIFont.svFont(72)
        logoLabel.minimumScaleFactor = 0.7
        logoLabel.adjustsFontSizeToFitWidth = true
        logoLabel.frame = CGRect(x: 35, y: view.bounds.height, width: view.bounds.width - 70, height: 100) // put at bottom
        logoLabel.alpha = 0
        contentView.addSubview(logoLabel)
        
        
        let _mountains = UIImage(asset: .Mountains)
        let _mountainsImageView = UIImageView(image: _mountains)
        let _mountainWidth = view.bounds.width - 200
        let _mountainHeight = 0.375 * _mountainWidth
        _mountainsImageView.frame = CGRect(x: 100, y: view.bounds.height - _mountainHeight, width: _mountainWidth, height: _mountainHeight)
        contentView.addSubview(_mountainsImageView)
        

        tapToPlayLabel.text = "TAP TO PLAY"
        tapToPlayLabel.textColor = SVColor.lightColor()
        tapToPlayLabel.textAlignment = .Center
        tapToPlayLabel.font = UIFont.svHeavyFont(30)
        tapToPlayLabel.minimumScaleFactor = 0.7
        tapToPlayLabel.adjustsFontSizeToFitWidth = true
        tapToPlayLabel.frame = CGRect(x: 75, y: 130, width: view.bounds.width - 150, height: 35)
        tapToPlayLabel.alpha = 0
        contentView.addSubview(tapToPlayLabel)
        
        blinkAnimation.blinkView = tapToPlayLabel
        blinkAnimation.blinkDuration = 3.0
        
        let settingsExpandedButton = UIButton(frame: CGRect(x: view.bounds.width - 225, y: view.bounds.height - 100, width: 225, height: 100))
        // currently not adding extra space for hit box
//        settingsExpandedButton.addTarget(self, action: "settingsButtonTapped", forControlEvents: .TouchUpInside)
        contentView.addSubview(settingsExpandedButton)
        
        settingsButton.frame = CGRect(x: view.bounds.width - 150, y: view.bounds.height - 50, width: 150, height: 50)
        settingsButton.titleLabel?.font = UIFont.svHeavyFont(20)
        settingsButton.setTitleColor(SVColor.lightColor(), forState: .Normal)
        settingsButton.setTitleColor(SVColor.lightColor().colorWithAlphaComponent(0.7), forState: .Highlighted)
        settingsButton.setTitle("SETTINGS", forState: .Normal)
        settingsButton.alpha = 0
        settingsButton.addTarget(self, action: #selector(HomeViewController.settingsButtonTapped), forControlEvents: .TouchUpInside)
        contentView.addSubview(settingsButton)
        
        // larger hit boxes for the choose car button so that there are no accidental taps
        let chooseCarExpandedButton = UIButton(frame: CGRect(x: 0, y: view.bounds.height - 100, width: 225, height: 100))
//        chooseCarExpandedButton.addTarget(self, action: "chooseCarButtonTapped", forControlEvents: .TouchUpInside)
        contentView.addSubview(chooseCarExpandedButton)
        
        chooseCarButton.frame = CGRect(x: 0, y: view.bounds.height - 50, width: 150, height: 50)
        chooseCarButton.titleLabel?.font = UIFont.svHeavyFont(20)
        chooseCarButton.setTitleColor(SVColor.lightColor(), forState: .Normal)
        chooseCarButton.setTitleColor(SVColor.lightColor().colorWithAlphaComponent(0.7), forState: .Highlighted)
        chooseCarButton.setTitle("CHANGE CAR", forState: .Normal)
        chooseCarButton.alpha = 0
        chooseCarButton.addTarget(self, action: #selector(HomeViewController.chooseCarButtonTapped), forControlEvents: .TouchUpInside)
        contentView.addSubview(chooseCarButton)
        
        // add tap gesture to start the game
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(HomeViewController.startGame))
        contentView.addGestureRecognizer(tapGesture)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        UIView.animateWithDuration(1.0, delay: 0, options: .CurveLinear, animations: {
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
        blinkAnimation.blink()
    }
    
    override func applicationDidBecomeActive(notification: NSNotification) {
        if animationsFinished {
            blinkTapToPlay()
        }
    }
    
    override func applicationWillEnterForeground(notification: NSNotification) {
        if animationsFinished {
            blinkTapToPlay()
        }
    }
    
    override func applicationWillResignActive(notification: NSNotification) {
        if animationsFinished {
            blinkAnimation.stopBlink(false)
            tapToPlayLabel.alpha = 0
        }
    }
    
    override func applicationDidEnterBackground(notification: NSNotification) {
        if animationsFinished {
            blinkAnimation.stopBlink(false)
            tapToPlayLabel.alpha = 0
        }
    }
    
    // segues to settings page
    func settingsButtonTapped() {
        let settings = SettingsViewController()      
        presentViewController(settings, animated: true, completion: nil)
    }
    
    // segues to choosing the car
    func chooseCarButtonTapped() {
        let changeCar = ChangeCarViewController()
        presentViewController(changeCar, animated: true, completion: nil)
    }
    
    // segues to start the game
    func startGame() {
        guard animationsFinished else {
            print("not so fast")
            return
        }
        presentViewController(GameViewController(), animated: true, completion: nil)
    }
}
