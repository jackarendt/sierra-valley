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

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let skView = SKView(frame: view.bounds)
        contentView.addSubview(skView)
        
        let scene = GameScene(size: view.bounds.size)
        // Configure the view.
        skView.showsFPS = true
        skView.showsNodeCount = true
        
        /* Sprite Kit applies additional optimizations to improve rendering performance */
        skView.ignoresSiblingOrder = true
        
        /* Set the scale mode to scale to fit the window */
        scene.scaleMode = .AspectFill
        
        skView.presentScene(scene)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override func prefersStatusBarHidden() -> Bool {
        return true
    }
}
