//
//  AppDelegate.swift
//  JSSAlertView
//
//  Created by Tomas Sykora, jr. on 04/04/2016.
//  Copyright (c) 2016 Tomas Sykora, jr.. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    private func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
		window = UIWindow(frame: UIScreen.main.bounds)
		if let window = window {
			let exampleTableViewController = ExampleTableViewController()
			let navigationController = UINavigationController()
			navigationController.setViewControllers([exampleTableViewController], animated: true)
			window.rootViewController = navigationController
			window.makeKeyAndVisible()
		}
        print("Got it 1")
        return true
    }

}

