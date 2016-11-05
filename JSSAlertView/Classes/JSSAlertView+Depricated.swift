//
//  JSSAlertView+Depricated.swift
//  Pods
//
//  Created by Tomas Sykora, jr. on 05/11/2016.
//
//

import UIKit

extension JSSAlertView {
	@discardableResult
	@available(*, deprecated, message: "Due Swift3 API notation changes use self.showAboveViewController(...")
	open func show(_ viewController: UIViewController,
	               title: String,
	               text: String?=nil,
	               noButtons: Bool = false,
	               buttonText: String? = nil,
	               cancelButtonText: String? = nil,
	               color: UIColor? = nil,
	               iconImage: UIImage? = nil,
	               delay: Double? = nil) -> JSSAlertViewResponder {

		return self.showAboveViewController(viewController: viewController,
		                                    title: title,
		                                    text: text,
		                                    withoutButtons: noButtons,
		                                    cancelButtonText: cancelButtonText,
		                                    extraButtonText: buttonText,
		                                    color: color,
		                                    icon: iconImage,
		                                    withDelay: delay)
		
		
	}
}
