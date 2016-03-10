//
//  GameViewController.swift
//  Sierra Valley
//
//  Created by Jack Arendt on 1/18/16.
//  Copyright (c) 2016 John Arendt. All rights reserved.
//

import UIKit
import SpriteKit

class GameViewController: SVBaseViewController {

    private let pauseButton = UIButton()
    private let distanceLabel = UILabel()
    
    var gameScene : GameScene!
    var skView : SKView!
    
    var pauseView : PauseView!
    var gameOverView : GameOverView!
    
    var distance = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        gaName = "Main Game Loop" // set the name for Google Analytics
        
        skView = SKView(frame: view.bounds)
        contentView.addSubview(skView)
        let width = view.bounds.width * 1000
        let height = width / view.bounds.width * view.bounds.height
        gameScene = GameScene(size: CGSize(width: width, height: height))
        gameScene.gameDelegate = self
        
        // Configure the view.
        skView.showsFPS = true
        skView.showsNodeCount = true
        skView.showsDrawCount = true
        
        /* Sprite Kit applies additional optimizations to improve rendering performance */
        skView.ignoresSiblingOrder = true
        
        /* Set the scale mode to scale to fit the window */
        gameScene.scaleMode = .AspectFill
        skView.presentScene(gameScene)
        
        
        pauseButton.setImage(UIImage(asset: .PauseIcon), forState: .Normal)
        pauseButton.frame = CGRect(x: contentView.frame.width - 60, y: 0, width: 60, height: 65)
        pauseButton.imageEdgeInsets = UIEdgeInsets(top: 20, left: 25, bottom: 20, right: 20)
        pauseButton.addTarget(self, action: "pauseButtonTapped:", forControlEvents: .TouchUpInside)
        contentView.addSubview(pauseButton)
        
        distanceLabel.frame = CGRect(x: 20, y: 5, width: view.bounds.width/2 - 40, height: 60)
        distanceLabel.textColor = SVColor.lightColor()
        distanceLabel.text = "\(distance)"
        distanceLabel.font = UIFont.svFont(min(60, 0.16 * view.bounds.height))
        view.addSubview(distanceLabel)
        
        pauseView = PauseView(frame: contentView.bounds)
        pauseView.delegate = self
        pauseView.alpha = 0
        pauseView.hidden = true
        contentView.addSubview(pauseView)
        
        gameOverView = GameOverView(frame: contentView.bounds)
        gameOverView.delegate = self
        gameOverView.alpha = 0
        gameOverView.hidden = true
        contentView.addSubview(gameOverView)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    
    func pauseButtonTapped(button : UIButton) {
        pause()
    }
    
    func pause() {
        gameScene.pause()
        pauseView.hidden = false
        pauseView.showMenu()
        pauseView.distance = gameScene.currentDistance()
        UIView.animateWithDuration(0.5, animations: {
            self.pauseView.alpha = 1
            self.pauseButton.alpha = 0
            self.distanceLabel.alpha = 0
            }, completion: { finsihed in
        })
    }
    
    override func applicationDidEnterBackground(notification: NSNotification) {
        if gameOverView.alpha == 0 {
            pause()
        }
    }
    
    override func applicationWillResignActive(notification: NSNotification) {
        if gameOverView.alpha == 0 {
            pause()
        }
    }
    
    override func applicationDidBecomeActive(notification: NSNotification) {
        pauseView.blinkSubtitle = true
        gameOverView.blinkSubtitle = true
    }
}

extension GameViewController : GameSceneDelegate {
    func gameDidEnd(finalScore: Int, newAvalanches: Int) {
        gameOverView.hidden = false
        gameOverView.showMenu()
        gameOverView.distance = finalScore
        gameOverView.avalanche = 0
        UIView.animateWithDuration(0.5, animations: {
            self.gameOverView.alpha = 1
            self.pauseButton.alpha = 0
            self.distanceLabel.alpha = 0
            }, completion: { finsihed in
        })
    }
    
    func scoreDidChange(newScore: Int) {
        distanceLabel.text = "\(newScore)"
    }
}

extension GameViewController : PauseViewDelegate {
    func pauseViewDidHitResume(pauseView: PauseView) {
        UIView.animateWithDuration(0.5, animations: {
            pauseView.alpha = 0
            self.pauseButton.alpha = 1
            self.distanceLabel.alpha = 1
        }, completion: { finished in
            pauseView.hidden = true
            self.gameScene.resume()
        })
    }
}

extension GameViewController : GameOverViewDelegate {
    func gameOverViewDidHitRetry(gameOverView: GameOverView) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func gameOverViewDidHitNewCar(gameOverView: GameOverView) {
        // show garage view controller
        gameOverView.subtitleText = "TAP TO RETRY"
    }
    
    func gameOverViewDidHitShare(gameOverView: GameOverView) {
        let activityController = UIActivityViewController(activityItems: ["Share your high score: 75"], applicationActivities: nil)
        activityController.excludedActivityTypes = [UIActivityTypeAirDrop]
        presentViewController(activityController, animated: true, completion: nil)
    }
    
    func gameOverViewDidHitLeaderboard(gameOverView: GameOverView) {
        
    }
}
