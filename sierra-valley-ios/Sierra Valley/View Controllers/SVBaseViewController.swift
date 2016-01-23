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
    
    /// Title at the top of the view controller. Similar to a UINavigationItem's title.
    public let navigationTitleLabel = UILabel()
    
    /// The left item of a navigation bar.  Similar to a UIBarButtonItem on the left side.
    public let leftNavigationButton = UIButton()
    
    /// The right item of a navigation bar.  Similar to a UIBarButtonItem on the right side.
    public let rightNavigationButton = UIButton()
    
    /// The view in which all content should be added to.  This will be faded when segueing from one view controller to another
    public let contentView = UIView()
    
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        // Add the background to every view
        let background =  UIImageView(image: UIImage(asset: .Background))
        background.frame = view.bounds
        view.addSubview(background)
        
        
        contentView.frame = view.bounds
        view.addSubview(contentView)
        
        // create navigation title label
        navigationTitleLabel.frame = CGRect(x: 70, y: 15, width: view.bounds.width - 140, height: 40)
        navigationTitleLabel.font = UIFont.svFont(40)
        navigationTitleLabel.textAlignment = .Center
        navigationTitleLabel.textColor = UIColor.whiteColor()
        contentView.addSubview(navigationTitleLabel)
        
        // create left navigation item
        leftNavigationButton.frame = CGRect(x: 20, y: 15, width: 40, height: 40)
        leftNavigationButton.addTarget(self, action: "leftNavigationButtonTapped:", forControlEvents: .TouchUpInside)
        contentView.addSubview(leftNavigationButton)
        
        // create right navigation item
        rightNavigationButton.frame = CGRect(x: view.bounds.width - 60, y: 15, width: 40, height: 40)
        rightNavigationButton.addTarget(self, action: "rightNavigationButtonTapped:", forControlEvents: .TouchUpInside)
        contentView.addSubview(rightNavigationButton)
        
        // add notifications for application states
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "applicationWillResignActive:", name: applicationWillResignNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "applicationWillEnterForeground:", name: applicationDidEnterForegroundNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "applicationDidBecomeActive:", name: applicationDidBecomeActiveNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "applicationDidEnterBackground:", name: applicationDidEnterBackgroundNotification, object: nil)
        
    }

    override public func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        NSNotificationCenter.defaultCenter().removeObserver(self)
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
