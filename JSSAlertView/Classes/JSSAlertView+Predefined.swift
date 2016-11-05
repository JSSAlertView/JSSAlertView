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
	               delay: Double? = nil) -> JSSAlertViewResponder {


		let alertview = showAboveViewController(viewController: viewController,
		                                        title: title,
		                                        text: text,
		                                        withoutButtons: noButtons,
		                                        cancelButtonText: cancelButtonText,
		                                        extraButtonText: buttonText,
		                                        color: UIColorFromHex(0x3498db, alpha: 1),
		                                        icon: iconImage,
		                                        withDelay: delay)


		alertview.setTextTheme(.light)
		return alertview
	}

	@discardableResult
	open func success(_ viewController: UIViewController,
	                  title: String,
	                  text: String?=nil,
	                  buttonText: String? = nil,
	                  cancelButtonText: String? = nil,
	                  delay: Double?=nil) -> JSSAlertViewResponder {

		return showAboveViewController(viewController: viewController,
		                               title: title,
		                               text: text,
		                               withoutButtons: noButtons,
		                               cancelButtonText: cancelButtonText,
		                               extraButtonText: buttonText,
		                               color: UIColorFromHex(0x2ecc71, alpha: 1),
		                               icon: iconImage,
		                               withDelay: delay)

	}

	@discardableResult
	open func warning(_ viewController: UIViewController,
	                  title: String,
	                  text: String?=nil,
	                  buttonText: String? = nil,
	                  cancelButtonText: String? = nil,
	                  delay: Double?=nil) -> JSSAlertViewResponder {

		return showAboveViewController(viewController: viewController,
		                               title: title,
		                               text: text,
		                               withoutButtons: noButtons,
		                               cancelButtonText: cancelButtonText,
		                               extraButtonText: buttonText,
		                               color: UIColorFromHex(0xf1c40f, alpha: 1),
		                               icon: iconImage,
		                               withDelay: delay)

	}

	@discardableResult
	open func danger(_ viewController: UIViewController,
	                 title: String,
	                 text: String?=nil,
	                 buttonText: String? = nil,
	                 cancelButtonText: String?=nil,
	                 delay: Double?=nil) -> JSSAlertViewResponder {


		let alertview = showAboveViewController(viewController: viewController,
		                                        title: title,
		                                        text: text,
		                                        withoutButtons: noButtons,
		                                        cancelButtonText: cancelButtonText,
		                                        extraButtonText: buttonText,
		                                        color: UIColorFromHex(0xe74c3c, alpha: 1),
		                                        icon: iconImage,
		                                        withDelay: delay)
		alertview.setTextTheme(.light)
		return alertview
	}
}
