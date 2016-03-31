//
//  DummyViewController.swift
//  JSSAlertViewExample
//
//  Created by Tomas Sykora, jr. on 25/01/16.
//  Copyright © 2016 Jay Stakelon. All rights reserved.
//

import UIKit

class DummyViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .whiteColor()
        self.navigationController?.navigationBar.backgroundColor = .grayColor()

    }
    
    override func viewDidAppear(animated: Bool) {
        let alertview = JSSAlertView().show(self, title: "UINavigationController", text: "Alert is centered and it's actually shown, are you happy?", buttonText: "Yep", cancelButtonText: "Nope")
        alertview.addAction(dismiss)
        alertview.addCancelAction(dismiss)
    }

    func dismiss(){
        self.navigationController?.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
