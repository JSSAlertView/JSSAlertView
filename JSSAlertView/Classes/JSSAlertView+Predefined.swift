//
//  JSSAlertView+Predefined.swift
//  Pods
//
//  Created by Tomas Sykora, jr. on 05/11/2016.
//
//

import UIKit

extension JSSAlertView {
	@discardableResult
	open func info(_ viewController: UIViewController,
	               title: String,
	               text: String? = nil,
	               buttonText: String? = nil,
	               cancelButtonText: String? = nil,
	               delay: Double? = nil,
	               timeLeft: UInt? = nil) -> JSSAlertViewResponder {


		let alertview = show(viewController,
		                     title: title,
		                     text: text,
		                     noButtons: noButtons,
		                     buttonText: buttonText,
		                     cancelButtonText: cancelButtonText,
		                     color: UIColorFromHex(0x3498db, alpha: 1),
		                     iconImage: iconImage,
		                     delay: delay,
		                     timeLeft: timeLeft)


		alertview.setTextTheme(.light)
		return alertview
	}

	@discardableResult
	open func success(_ viewController: UIViewController,
	                  title: String,
	                  text: String?=nil,
	                  buttonText: String? = nil,
	                  cancelButtonText: String? = nil,
	                  delay: Double?=nil,
	                  timeLeft: UInt? = nil) -> JSSAlertViewResponder {

		return show(viewController,
		            title: title,
		            text: text,
		            noButtons: noButtons,
		            buttonText: buttonText,
		            cancelButtonText: cancelButtonText,
		            color: UIColorFromHex(0x2ecc71, alpha: 1),
		            iconImage: iconImage,
		            delay: delay,
		            timeLeft: timeLeft)

	}

	@discardableResult
	open func warning(_ viewController: UIViewController,
	                  title: String,
	                  text: String?=nil,
	                  buttonText: String? = nil,
	                  cancelButtonText: String? = nil,
	                  delay: Double?=nil,
	                  timeLeft: UInt? = nil) -> JSSAlertViewResponder {

		return show(viewController,
		            title: title,
		            text: text,
		            noButtons: noButtons,
		            buttonText: buttonText,
		            cancelButtonText: cancelButtonText,
		            color: UIColorFromHex(0xf1c40f, alpha: 1),
		            iconImage: iconImage,
		            delay: delay,
		            timeLeft: timeLeft)

	}

	@discardableResult
	open func danger(_ viewController: UIViewController,
	                 title: String,
	                 text: String?=nil,
	                 buttonText: String? = nil,
	                 cancelButtonText: String?=nil,
	                 delay: Double?=nil,
	                 timeLeft: UInt? = nil) -> JSSAlertViewResponder {


		let alertview = show(viewController,
		                     title: title,
		                     text: text,
		                     noButtons: noButtons,
		                     buttonText: buttonText,
		                     cancelButtonText: cancelButtonText,
		                     color: UIColorFromHex(0xe74c3c, alpha: 1),
		                     iconImage: iconImage,
		                     delay: delay,
		                     timeLeft: timeLeft)
		alertview.setTextTheme(.light)
		return alertview
	}
}
