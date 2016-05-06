//
//  ExampleTableViewController.swift
//  JSSAlertView
//
//  Created by Tomas Sykora, jr. on 04/04/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import UIKit
import JSSAlertView

class ExampleTableViewController: UITableViewController {
	
    override func viewDidLoad() {
        super.viewDidLoad()
		tableView.delegate = self
		tableView.dataSource = self
		title = "JSSAlertView Examples"
		tableView.registerClass(UITableViewCell.classForCoder(), forCellReuseIdentifier: "JSSALERTVIEWCELL")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 12
    }

	
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("JSSALERTVIEWCELL", forIndexPath: indexPath)
		cell.textLabel?.textAlignment = .Center
		switch indexPath.row {
		case 0:
			cell.textLabel?.text = "Simple alert with no buttons"
		case 1:
			cell.textLabel?.text = "Standard alert"
		case 2:
			cell.textLabel?.text = "Custom color"
		case 3:
			cell.textLabel?.text = "Custom icon"
		case 4:
			cell.textLabel?.text = "Custom font"
		case 5:
			cell.textLabel?.text = "Info style"
		case 6:
			cell.textLabel?.text = "Success style"
		case 7:
			cell.textLabel?.text = "Warning style"
		case 8:
			cell.textLabel?.text = "Danger style"
		case 9:
			cell.textLabel?.text = "Callback example"
		case 10:
			cell.textLabel?.text = "Kitchen sink"
		case 11:
			cell.textLabel?.text = "Delayed ⏲"
		default:
			break
		}
		
        return cell
    }
	
	// MARK: - Table view actions
	
	override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		switch indexPath.row {
		case 0:
			JSSAlertView().show(self, title: "Boring and basic, but with a multi-line title and no buttons", noButtons: true)
		case 1:
			JSSAlertView().show(self, title: "Standard alert", text: "A standard alert with some text looks like this", buttonText: "Yay")
		case 2:
			let alertview = JSSAlertView().show(self, title: "Custom color", text: "All of the cool kids have purple alerts these days", buttonText: "Whoa", color: UIColorFromHex(0x9b59b6, alpha: 1))
			alertview.setTextTheme(.Light)
		case 3:
			let customIcon = UIImage(named: "lightbulb")
			let alertview = JSSAlertView().show(self, title: "Custom icon", text: "Supply a UIImage as the iconImage for sexy results", buttonText: "Yes", color: UIColorFromHex(0x9b59b6, alpha: 1), iconImage: customIcon)
			alertview.setTextTheme(.Light)
		case 4:
			let alertview = JSSAlertView().show(self, title: "Check it out", text: "This alert is using a custom font: Clear Sans to be specific")
			alertview.setTitleFont("ClearSans-Light")
			alertview.setTextFont("ClearSans")
			alertview.setButtonFont("ClearSans-Bold")
		case 5:
			JSSAlertView().info(self, title: "Heads up!", text: "This is the built-in .info style", buttonText: "Aight then")
		case 6:
			JSSAlertView().success(self, title: "Great success", text: "This is the built-in .success style")
		case 7:
			JSSAlertView().warning(self, title: "Take warning", text: "This is the built-in .warning style")
		case 8:
			JSSAlertView().danger(self, title: "Oh, shit.", text: "This is the built-in .danger style")
		case 9:
			let alertview = JSSAlertView().show(self, title: "Standard alert", text: "A standard alert with some text looks like this", buttonText: "Yep", cancelButtonText: "Nope")
			alertview.addAction(closeCallback)
			alertview.addCancelAction(cancelCallback)
		case 10:
			let customIcon = UIImage(named: "lightbulb")
			let alertview = JSSAlertView().show(self, title: "Kitchen sink", text: "Here's a modal alert with descriptive text, an icon, custom fonts and a custom color", buttonText: "Sweet", color: UIColorFromHex(0xE0107A, alpha: 1), iconImage: customIcon)
			alertview.addAction(closeCallback)
			alertview.setTitleFont("ClearSans-Bold")
			alertview.setTextFont("ClearSans")
			alertview.setButtonFont("ClearSans-Light")
			alertview.setTextTheme(.Light)
		case 11:
			JSSAlertView().show(self, title: "Delayed!", text: "This alert is using a custom font: Clear Sans to be specific", delay: 3)

			
		default:
			print("Nada")
		}
	}
	
	// MARK: - JSSAlertView callbacks
	
	func closeCallback() {
		print("Close callback called")
	}
	
	func cancelCallback() {
		print("Cancel callback called")
	}
	
}
