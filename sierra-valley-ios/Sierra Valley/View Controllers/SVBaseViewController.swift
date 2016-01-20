//
//  SVBaseViewController.swift
//  Sierra Valley
//
//  Created by Jack Arendt on 1/18/16.
//  Copyright © 2016 John Arendt. All rights reserved.
//

import UIKit

/// Root base view controller
class SVBaseViewController: UIViewController {
    
    /// Navigation Title of the view controller
    var navigationTitle = "" {
        didSet {
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Add the background to every view
        let background =  UIImageView(image: UIImage(asset: .Background))
        background.frame = view.bounds
        view.addSubview(background)
        
        // add notifications for application states
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "applicationWillResignActive:", name: applicationWillResignNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "applicationWillEnterForeground:", name: applicationDidEnterForegroundNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "applicationDidBecomeActive:", name: applicationDidBecomeActiveNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "applicationDidEnterBackground:", name: applicationDidEnterBackgroundNotification, object: nil)
    }

    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    func applicationWillResignActive(notification : NSNotification) {
        
    }
    
    func applicationWillEnterForeground(notification : NSNotification) {
        
    }
    
    func applicationDidBecomeActive(notification : NSNotification) {
        
    }
    
    func applicationDidEnterBackground(notification : NSNotification) {
        
    }
    
}
