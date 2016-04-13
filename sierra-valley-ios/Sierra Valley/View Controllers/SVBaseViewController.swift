//
//  SVBaseViewController.swift
//  Sierra Valley
//
//  Created by Jack Arendt on 1/18/16.
//  Copyright © 2016 John Arendt. All rights reserved.
//

import UIKit

/// Root base view controller
public class SVBaseViewController: UIViewController {
    
    /// Navigation Title of the view controller
    public var navigationTitle = "" {
        didSet {
            navigationTitleLabel.text = navigationTitle
        }
    }
    
    /// The name of the view controller for Google Analytics
    public var name = "VC Name Not Set"
    
    /// Title at the top of the view controller. Similar to a UINavigationItem's title.
    public let navigationTitleLabel = UILabel()
    
    /// The left item of a navigation bar.  Similar to a UIBarButtonItem on the left side.
    public let leftNavigationButton = UIButton()
    
    /// The right item of a navigation bar.  Similar to a UIBarButtonItem on the right side.
    public let rightNavigationButton = UIButton()
    
    /// The view in which all content should be added to.  This will be faded when segueing from one view controller to another
    public let contentView = UIView()
    
    /// If dusk view is enabled, this will determine whether it should animate in or not.
    public var animateDuskView = false
    
    /// This is used for dimming the colors at night to make a "night mode"
    private let duskView = UIView()
    
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        // Add the background to every view
        let background =  UIImageView(image: UIImage(asset: .Background))
        background.frame = view.bounds
        view.addSubview(background)
        
        duskView.frame = view.bounds
        duskView.alpha = 0
        duskView.backgroundColor = SVColor.darkColor()
        view.addSubview(duskView)
        
        
        contentView.frame = view.bounds
        view.addSubview(contentView)
        
        // create navigation title label
        navigationTitleLabel.frame = CGRect(x: 70, y: 15, width: view.bounds.width - 140, height: 40)
        navigationTitleLabel.font = UIFont.svFont(40)
        navigationTitleLabel.textAlignment = .Center
        navigationTitleLabel.textColor = SVColor.lightColor()
        contentView.addSubview(navigationTitleLabel)
        
        // create left navigation item
        leftNavigationButton.frame = CGRect(x: 20, y: 15, width: 40, height: 40)
        leftNavigationButton.addTarget(self, action: #selector(SVBaseViewController.leftNavigationButtonTapped(_:)), forControlEvents: .TouchUpInside)
        contentView.addSubview(leftNavigationButton)
        
        // create right navigation item
        rightNavigationButton.frame = CGRect(x: view.bounds.width - 60, y: 15, width: 40, height: 40)
        rightNavigationButton.addTarget(self, action: #selector(SVBaseViewController.rightNavigationButtonTapped(_:)), forControlEvents: .TouchUpInside)
        contentView.addSubview(rightNavigationButton)
        
        // add notifications for application states
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(UIApplicationDelegate.applicationWillResignActive(_:)), name: applicationWillResignNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(UIApplicationDelegate.applicationWillEnterForeground(_:)), name: applicationDidEnterForegroundNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(UIApplicationDelegate.applicationDidBecomeActive(_:)), name: applicationDidBecomeActiveNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(UIApplicationDelegate.applicationDidEnterBackground(_:)), name: applicationDidEnterBackgroundNotification, object: nil)
        
    }
    
    public override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        AnalyticsManager.logScreenView(name)
        changeThemeAlpha()
    }

    override public func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    func changeThemeAlpha() {
        if animateDuskView {
            UIView.animateWithDuration(1.5, animations: {
                self.duskView.alpha = CGFloat(TimeManager.sharedManager.getAlphaForTime())
            })
            animateDuskView = false
        } else {
            duskView.alpha = CGFloat(TimeManager.sharedManager.getAlphaForTime())
        }
    }
    
    // MARK: - Navigation button selectors
    
    public func leftNavigationButtonTapped(button : UIButton) {
        
    }
    
    public func rightNavigationButtonTapped(button : UIButton) {
        
    }
    
    // MARK: - application notification methods
    
    public func applicationWillResignActive(notification : NSNotification) {
        
    }
    
    public func applicationWillEnterForeground(notification : NSNotification) {
        
    }
    
    public func applicationDidBecomeActive(notification : NSNotification) {
        
    }
    
    public func applicationDidEnterBackground(notification : NSNotification) {
        
    }
}

// MARK: - UIViewController Transititioning Delegate methods & segues
extension SVBaseViewController : UIViewControllerTransitioningDelegate {
    public func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        let animator = SVFadeAnimator()
        animator.presenting = true
        return animator
    }
    
    public func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        let animator = SVFadeAnimator()
        return animator
    }
    
    public override func presentViewController(viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> Void)?) {
        if viewControllerToPresent is SVBaseViewController {
//            viewControllerToPresent.modalPresentationStyle = .Custom
            viewControllerToPresent.transitioningDelegate = self
        } else {
            viewControllerToPresent.modalTransitionStyle = .CrossDissolve
        }
        super.presentViewController(viewControllerToPresent, animated: flag, completion: completion)
    }
}
