//
//  JSSAlertViewResponder.swift
//  Pods
//
//  Created by Tomas Sykora, jr. on 05/11/2016.
//
//

import UIKit


open class JSSAlertViewResponder {
	let alertview: JSSAlertView

	public init(alertview: JSSAlertView) {
		self.alertview = alertview
	}

	open func addAction(_ action: @escaping ()->Void) {
		self.alertview.addAction(action)
	}

	open func addCancelAction(_ action: @escaping ()->Void) {
		self.alertview.addCancelAction(action)
	}

	open func setTitleFont(_ fontStr: String) {
		self.alertview.setFont(fontStr, type: .title)
	}

	open func setTextFont(_ fontStr: String) {
		self.alertview.setFont(fontStr, type: .text)
	}

	open func setButtonFont(_ fontStr: String) {
		self.alertview.setFont(fontStr, type: .button)
	}

	open func setTextTheme(_ theme: TextColorTheme) {
		self.alertview.setTextTheme(theme)
	}

	@objc func close() {
		self.alertview.closeView(false)
	}
}
