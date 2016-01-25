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

    let pauseButton = UIButton()
    
    var gameScene : GameScene!
    var skView : SKView!
    
    var pauseView : PauseView!
    var gameOverView : GameOverView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        skView = SKView(frame: view.bounds)
        contentView.addSubview(skView)
        gameScene = GameScene(size: view.bounds.size)
        gameScene.gameDelegate = self
        // Configure the view.
        skView.showsFPS = true
        skView.showsNodeCount = true
        skView.showsPhysics = true
        
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
        gameScene.pause()
        pauseView.hidden = false
        pauseView.showMenu()
        pauseView.distance = gameScene.currentDistance()
        UIView.animateWithDuration(0.5, animations: {
            self.pauseView.alpha = 1
            self.pauseButton.alpha = 0
        }, completion: { finsihed in
        })
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
            }, completion: { finsihed in
        })
    }
}

extension GameViewController : PauseViewDelegate {
    func pauseViewDidHitResume(pauseView: PauseView) {
        UIView.animateWithDuration(0.5, animations: {
            pauseView.alpha = 0
            self.pauseButton.alpha = 1
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
