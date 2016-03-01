//
//  ChangeCarViewController.swift
//  Sierra Valley
//
//  Created by Jack Arendt on 1/23/16.
//  Copyright © 2016 John Arendt. All rights reserved.
//

import UIKit

class ChangeCarViewController: SVBaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        gaName = "Change Car" // set the name for Google Analytics
        
        navigationTitle = "CHANGE CAR"
        leftNavigationButton.setImage(UIImage(asset: .CloseButton), forState: .Normal)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func leftNavigationButtonTapped(button: UIButton) {
        dismissViewControllerAnimated(true, completion: nil)
    }
}
