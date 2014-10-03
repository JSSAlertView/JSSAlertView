//
//  ViewController.swift
//  JSSAlertViewExample
//
//  Created by Jay Stakelon on 9/23/14.
//  Copyright (c) 2014 Jay Stakelon. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func basicAlertButtonPress() {
        JSSAlertView().show(self, title: "Boring and basic, but with a multi-line title")
    }

    @IBAction func standardAlertButtonPress() {
        JSSAlertView().show(self, title: "Standard alert", modalText: "A standard alert with some text looks like this", buttonText: "Yay")
    }

    @IBAction func customColorAlertButtonPress() {
        JSSAlertView().show(self, title: "Custom color", modalText: "Purple alerts are the new transparent white alerts are the new gradient-laden alerts", buttonText: "Whoa", color: UIColorFromHex(0x9b59b6, alpha: 1))
    }
    
    @IBAction func customIconAlertButtonPress() {
        var customIcon = UIImage(named: "lightbulb")
        JSSAlertView().show(self, title: "Custom icon", modalText: "Supply a UIImage as the iconImage for sexy results", buttonText: "Yes", color: nil, iconImage: customIcon)
    }

    @IBAction func infoAlertButtonPress() {
        JSSAlertView().info(self, title: "Heads up!")
    }
    
    @IBAction func successAlertButtonPress() {
        JSSAlertView().success(self, title: "Great success")
    }
    
    @IBAction func warningAlertButtonPress() {
        JSSAlertView().warning(self, title: "Take warning")
    }
    
    @IBAction func dangerAlertButtonPress() {
        JSSAlertView().danger(self, title: "Oh, shit.")
    }
    
    @IBAction func kitchenSinkAlertViewButtonPress() {
        var customIcon = UIImage(named: "lightbulb")
        JSSAlertView().show(self, title: "Kitchen sink", modalText: "Here's a modal alert with descriptive text, an icon, and a custom color", buttonText: "Sweet", color: UIColorFromHex(0x9b59b6, alpha: 1), iconImage: customIcon)
    }
}

