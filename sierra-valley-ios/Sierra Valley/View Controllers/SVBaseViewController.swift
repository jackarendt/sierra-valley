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
        let background =  UIImageView(image: UIImage(asset: .Background))
        background.frame = view.bounds
        view.addSubview(background)
    }
}
