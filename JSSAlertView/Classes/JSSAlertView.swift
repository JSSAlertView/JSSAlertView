//
//  JSSAlertView
//  JSSAlertView
//
//  Created by Jay Stakelon on 9/16/14.
//  Copyright (c) 2014 Jay Stakelon / https://github.com/stakes  - all rights reserved.
//
//  Inspired by and modeled after https://github.com/vikmeup/SCLAlertView-Swift
//  by Victor Radchenko: https://github.com/vikmeup
//

import Foundation
import UIKit

open class JSSAlertView: UIViewController {

	var containerView: UIView!
	var alertBackgroundView: UIView!
	var dismissButton: UIButton!
	var cancelButton: UIButton!
	var buttonLabel: UILabel!
	var cancelButtonLabel: UILabel!
	var titleLabel: UILabel!
    var timerLabel:UILabel!
	var textView: UITextView!
	weak var rootViewController: UIViewController!
	var iconImage: UIImage!
	var iconImageView: UIImageView!
	var closeAction: (()->Void)!
	var cancelAction: (()->Void)!
	var isAlertOpen: Bool = false
	var noButtons: Bool = false

    var timeLeft: UInt?
    
	enum FontType {
		case title, text, button, timer
	}
	var titleFont = "HelveticaNeue-Light"
	var textFont = "HelveticaNeue"
	var buttonFont = "HelveticaNeue-Bold"
    var timerFont = "HelveticaNeue"

	var defaultColor = UIColorFromHex(0xF2F4F4, alpha: 1)

	public enum TextColorTheme {
		case dark, light
	}
	var darkTextColor = UIColorFromHex(0x000000, alpha: 0.75)
	var lightTextColor = UIColorFromHex(0xffffff, alpha: 0.9)

	enum ActionType {
		case close, cancel
	}

	let baseHeight: CGFloat = 160.0
	var alertWidth: CGFloat = 290.0
	let buttonHeight: CGFloat = 70.0
	let padding: CGFloat = 20.0

	var viewWidth: CGFloat?
	var viewHeight: CGFloat?

	// Allow alerts to be closed/renamed in a chainable manner
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
        
        open func setTimerFont(_ fontStr: String) {
            self.alertview.setFont(fontStr, type: .timer)
        }

		open func setTextTheme(_ theme: TextColorTheme) {
			self.alertview.setTextTheme(theme)
		}

		@objc func close() {
			self.alertview.closeView(false)
		}
	}

	func setFont(_ fontStr: String, type: FontType) {
		switch type {
		case .title:
			self.titleFont = fontStr
			if let font = UIFont(name: self.titleFont, size: 24) {
				self.titleLabel.font = font
			} else {
				self.titleLabel.font = UIFont.systemFont(ofSize: 24)
			}
		case .text:
			if self.textView != nil {
				self.textFont = fontStr
				if let font = UIFont(name: self.textFont, size: 16) {
					self.textView.font = font
				} else {
					self.textView.font = UIFont.systemFont(ofSize: 16)
				}
			}
		case .button:
			self.buttonFont = fontStr
			if let font = UIFont(name: self.buttonFont, size: 24) {
				self.buttonLabel.font = font
			} else {
				self.buttonLabel.font = UIFont.systemFont(ofSize: 24)
			}
        case .timer:
            self.timerFont = fontStr
            if let font = UIFont(name: self.timerFont, size: 27) {
                self.buttonLabel.font = font
            } else {
                self.buttonLabel.font = UIFont.systemFont(ofSize: 27)
            }
		}
		// relayout to account for size changes
		self.viewDidLayoutSubviews()
	}

	func setTextTheme(_ theme: TextColorTheme) {
		switch theme {
		case .light:
			recolorText(lightTextColor)
		case .dark:
			recolorText(darkTextColor)
		}
	}

	func recolorText(_ color: UIColor) {
		titleLabel.textColor = color
		if textView != nil {
			textView.textColor = color
		}
        if timerLabel != nil {
            timerLabel.textColor = color
        }
		if self.noButtons == false {
			buttonLabel.textColor = color
			if cancelButtonLabel != nil {
				cancelButtonLabel.textColor = color
			}
		}

	}

	override public init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
		super.init(nibName:nibNameOrNil, bundle:nibBundleOrNil)
	}

	public required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	override open func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}

	open override func viewDidLayoutSubviews() {
		super.viewWillLayoutSubviews()
		let size = self.rootViewControllerSize()
		self.viewWidth = size.width
		self.viewHeight = size.height

		var yPos: CGFloat = 0.0
		let contentWidth:CGFloat = self.alertWidth - (self.padding*2)

		// position the icon image view, if there is one
		if self.iconImageView != nil {
			yPos += iconImageView.frame.height
			let centerX = (self.alertWidth-self.iconImageView.frame.width)/2
			self.iconImageView.frame.origin = CGPoint(x: centerX, y: self.padding)
			yPos += padding
		}

		// position the title
		let titleString = titleLabel.text! as NSString
		let titleAttr = [NSFontAttributeName: titleLabel.font!]
		let titleSize = CGSize(width: contentWidth, height: 90)
		let titleRect = titleString.boundingRect(with: titleSize, options: .usesLineFragmentOrigin, attributes: titleAttr, context: nil)
		yPos += padding
		titleLabel.frame = CGRect(x: padding, y: yPos, width: alertWidth - (padding * 2), height: ceil(titleRect.height))
		yPos += ceil(titleRect.height)


		// position text
		if self.textView != nil {
			let textString = textView.text! as NSString
			let textAttr = [NSFontAttributeName: textView.font!]
			let realSize = textView.sizeThatFits(CGSize(width: contentWidth, height: CGFloat.greatestFiniteMagnitude))
			let textSize = CGSize(width: contentWidth, height: CGFloat(fmaxf(Float(90.0), Float(realSize.height))))
			let textRect = textString.boundingRect(with: textSize, options: .usesLineFragmentOrigin, attributes: textAttr, context: nil)
			textView.frame = CGRect(x: padding, y: yPos, width: alertWidth - (padding * 2), height: ceil(textRect.height) * 2)
			yPos += ceil(textRect.height) + padding / 2
		}

        //position timer
        if self.timerLabel != nil {
            let timerString = timerLabel.text!
            let timerAttr = [NSFontAttributeName: timerLabel.font!]
            let timerSize = CGSize(width: contentWidth, height: 20)
            let timerRect = timerString.boundingRect(with: timerSize, options: .usesLineFragmentOrigin, attributes: timerAttr, context: nil)
            self.timerLabel.frame = CGRect(x: self.padding, y: yPos, width: self.alertWidth - (self.padding*2), height: ceil(timerRect.size.height))
            yPos += ceil(timerRect.size.height)
        }
        
		// position the buttons

		if !noButtons {
			yPos += padding
			var buttonWidth = alertWidth
			if cancelButton != nil {
				buttonWidth = alertWidth / 2
				cancelButton.frame = CGRect(x: 0, y: yPos, width: buttonWidth - 0.5, height: buttonHeight)
				if cancelButtonLabel != nil {
					cancelButtonLabel.frame = CGRect(x: padding, y: (buttonHeight / 2) - 15, width: buttonWidth - (padding * 2), height: 30)
				}
			}

			let buttonX = buttonWidth == alertWidth ? 0 : buttonWidth
			dismissButton.frame = CGRect(x: buttonX, y: yPos, width: buttonWidth, height: buttonHeight)
			if buttonLabel != nil {
				buttonLabel.frame = CGRect(x: padding, y: (buttonHeight / 2) - 15, width: buttonWidth - (padding * 2), height: 30)
			}

			// set button fonts
			if buttonLabel != nil {
				buttonLabel.font = UIFont(name: buttonFont, size: 20)
			}
			if cancelButtonLabel != nil {
				cancelButtonLabel.font = UIFont(name: buttonFont, size: 20)
			}
			yPos += buttonHeight
		}else{
			yPos += padding
		}


		// size the background view
		alertBackgroundView.frame = CGRect(x: 0, y: 0, width: alertWidth, height: yPos)

		// size the container that holds everything together
		containerView.frame = CGRect(x: (viewWidth! - alertWidth) / 2, y: (viewHeight! - yPos)/2, width: alertWidth, height: yPos)
	}

	@discardableResult
	open func info(_ viewController: UIViewController, title: String, text: String? = nil, buttonText: String? = nil, cancelButtonText: String? = nil, delay: Double? = nil, timeLeft: UInt? = nil) -> JSSAlertViewResponder {
        let alertview = show(viewController, title: title, text: text, buttonText: buttonText, cancelButtonText: cancelButtonText, color: UIColorFromHex(0x3498db, alpha: 1), delay: delay, timeLeft: timeLeft)
		alertview.setTextTheme(.light)
		return alertview
	}

	@discardableResult
	open func success(_ viewController: UIViewController, title: String, text: String?=nil, buttonText: String? = nil, cancelButtonText: String? = nil, delay: Double?=nil, timeLeft: UInt? = nil) -> JSSAlertViewResponder {
		return self.show(viewController, title: title, text: text, buttonText: buttonText, cancelButtonText: cancelButtonText, color: UIColorFromHex(0x2ecc71, alpha: 1), delay: delay, timeLeft: timeLeft)
	}

	@discardableResult
	open func warning(_ viewController: UIViewController, title: String, text: String?=nil, buttonText: String? = nil, cancelButtonText: String? = nil, delay: Double?=nil, timeLeft: UInt? = nil) -> JSSAlertViewResponder {
		return show(viewController, title: title, text: text, buttonText: buttonText, cancelButtonText: cancelButtonText, color: UIColorFromHex(0xf1c40f, alpha: 1), delay: delay, timeLeft: timeLeft)
	}

	@discardableResult
	open func danger(_ viewController: UIViewController, title: String, text: String?=nil, buttonText: String? = nil, cancelButtonText: String?=nil, delay: Double?=nil, timeLeft: UInt? = nil) -> JSSAlertViewResponder {
		let alertview = self.show(viewController, title: title, text: text, buttonText: buttonText, cancelButtonText: cancelButtonText, color: UIColorFromHex(0xe74c3c, alpha: 1), delay: delay, timeLeft: timeLeft)
		alertview.setTextTheme(.light)
		return alertview
	}

	@discardableResult
	open func show(_ viewController: UIViewController, title: String, text: String?=nil, noButtons: Bool = false, buttonText: String? = nil, cancelButtonText: String? = nil, color: UIColor? = nil, iconImage: UIImage? = nil, delay: Double? = nil, timeLeft: UInt? = nil) -> JSSAlertViewResponder {
		rootViewController = viewController

		view.backgroundColor = UIColorFromHex(0x000000, alpha: 0.7)

		var baseColor:UIColor?
		if let customColor = color {
			baseColor = customColor
		} else {
			baseColor = defaultColor
		}
		let textColor = darkTextColor

		let sz = screenSize()
		viewWidth = sz.width
		viewHeight = sz.height

		view.frame.size = sz

		// Container for the entire alert modal contents
		containerView = UIView()
		view.addSubview(containerView!)

		// Background view/main color
		alertBackgroundView = UIView()
		alertBackgroundView.backgroundColor = baseColor
		alertBackgroundView.layer.cornerRadius = 4
		alertBackgroundView.layer.masksToBounds = true
		containerView.addSubview(alertBackgroundView!)

		// Icon
		self.iconImage = iconImage
		if iconImage != nil {
			iconImageView = UIImageView(image: iconImage)
			containerView.addSubview(iconImageView)
		}

		// Title
		titleLabel = UILabel()
		titleLabel.textColor = textColor
		titleLabel.numberOfLines = 0
		titleLabel.textAlignment = .center
		titleLabel.font = UIFont(name: self.titleFont, size: 24)
		titleLabel.text = title
		containerView.addSubview(titleLabel)

		// View text
		if let text = text {
			textView = UITextView()
			textView.isUserInteractionEnabled = false
			textView.isEditable = false
			textView.textColor = textColor
			textView.textAlignment = .center
			textView.font = UIFont(name: self.textFont, size: 16)
			textView.backgroundColor = UIColor.clear
			textView.text = text
			containerView.addSubview(textView)
		}

        //timer
        if let time = timeLeft {
            self.timerLabel = UILabel()
            timerLabel.textAlignment = .center
            self.timeLeft = time
            self.timerLabel.font = UIFont(name: self.timerFont, size: 27)
            self.timerLabel.textColor = textColor
            self.containerView.addSubview(timerLabel)
            configureTimer()
        }
        
		// Button
		self.noButtons = true
		if !noButtons {
			self.noButtons = false
			dismissButton = UIButton()
			let buttonColor = UIImage.with(color: adjustBrightness(baseColor!, amount: 0.8))
			let buttonHighlightColor = UIImage.with(color: adjustBrightness(baseColor!, amount: 0.9))
			dismissButton.setBackgroundImage(buttonColor, for: .normal)
			dismissButton.setBackgroundImage(buttonHighlightColor, for: .highlighted)
			dismissButton.addTarget(self, action: #selector(buttonTap), for: .touchUpInside)
			alertBackgroundView!.addSubview(dismissButton)
			// Button text
			buttonLabel = UILabel()
			buttonLabel.textColor = textColor
			buttonLabel.numberOfLines = 1
			buttonLabel.textAlignment = .center
			if let text = buttonText {
				buttonLabel.text = text
			} else {
				buttonLabel.text = "OK"
			}
			dismissButton.addSubview(buttonLabel)

			// Second cancel button
			if cancelButtonText != nil {
				cancelButton = UIButton()
				let buttonColor = UIImage.with(color: adjustBrightness(baseColor!, amount: 0.8))
				let buttonHighlightColor = UIImage.with(color: adjustBrightness(baseColor!, amount: 0.9))
				cancelButton.setBackgroundImage(buttonColor, for: .normal)
				cancelButton.setBackgroundImage(buttonHighlightColor, for: .highlighted)
				cancelButton.addTarget(self, action: #selector(JSSAlertView.cancelButtonTap), for: .touchUpInside)
				alertBackgroundView!.addSubview(cancelButton)
				// Button text
				cancelButtonLabel = UILabel()
				cancelButtonLabel.alpha = 0.7
				cancelButtonLabel.textColor = textColor
				cancelButtonLabel.numberOfLines = 1
				cancelButtonLabel.textAlignment = .center
				cancelButtonLabel.text = cancelButtonText

				cancelButton.addSubview(cancelButtonLabel)
			}
		}

		// Animate it in
		view.alpha = 0
		definesPresentationContext = true
		modalPresentationStyle = .overFullScreen
		viewController.present(self, animated: false, completion: {
			// Animate it in
			UIView.animate(withDuration: 0.2) {
				self.view.alpha = 1
			}

			self.containerView.center.x = self.view.center.x
			self.containerView.center.y = -500

			UIView.animate(withDuration: 0.5, delay: 0.05, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.5, options: [], animations: {
				self.containerView.center = self.view.center
				}, completion: { finished in
					self.isAlertOpen = true
					if let d = delay {
						let delayTime = DispatchTime.now() + d * Double(NSEC_PER_SEC)
						DispatchQueue.main.asyncAfter(deadline: delayTime, execute: {
							self.closeView(true)
						})
					}
			})
		})

		return JSSAlertViewResponder(alertview: self)
	}
    
    func configureTimer() {
        
        guard let dateUInt = timeLeft else {
            return
        }
        self.timerLabel.text = stringFromUInt(number: dateUInt)
        
        Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTimerLabel), userInfo: nil, repeats: true)
        
    }
    
    func updateTimerLabel() {
        guard let timeLeftExists = timeLeft else {
            return
        }
        if(timeLeftExists > 0) {
            
            self.timeLeft! -= 1
            self.timerLabel.text = stringFromUInt(number: timeLeft!)
            
        } else {
            closeView(false)
        }
    }
    
    func stringFromUInt(number: UInt) -> String {
        
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm:ss"
        
        let dateComp = NSDateComponents()
        dateComp.second = Int(number)
        
        let date = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)?.date(from: dateComp as DateComponents)
        
        let str = formatter.string(from: date!)
        
        return str
        
    }

	func addAction(_ action: @escaping () -> Void) {
		self.closeAction = action
	}

	func buttonTap() {
		closeView(true, source: .close);
	}

	func addCancelAction(_ action: @escaping () -> Void) {
		self.cancelAction = action
	}

	func cancelButtonTap() {
		closeView(true, source: .cancel);
	}

	func closeView(_ withCallback: Bool, source: ActionType = .close) {
		UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5, options: [], animations: {
			self.containerView.center.y = self.view.center.y + self.viewHeight!
			}, completion: { finished in
				UIView.animate(withDuration: 0.1, animations: {
					self.view.alpha = 0
					}, completion: { finished in
						self.dismiss(animated: false, completion: {

							if withCallback {
								if let action = self.closeAction , source == .close {
									action()
								}
								else if let action = self.cancelAction, source == .cancel {
									action()
								}
							}
						})
				})
		})
	}

	func removeView() {
		isAlertOpen = false
		removeFromParentViewController()
		view.removeFromSuperview()
	}

	func rootViewControllerSize() -> CGSize {
		let size = rootViewController.view.frame.size
		if (NSFoundationVersionNumber <= NSFoundationVersionNumber_iOS_7_1) && UIInterfaceOrientationIsLandscape(UIApplication.shared.statusBarOrientation) {
			return CGSize(width: size.height, height: size.width)
		}
		return size
	}

	func screenSize() -> CGSize {
		let screenSize = UIScreen.main.bounds.size
		if (NSFoundationVersionNumber <= NSFoundationVersionNumber_iOS_7_1) && UIInterfaceOrientationIsLandscape(UIApplication.shared.statusBarOrientation) {
			return CGSize(width: screenSize.height, height: screenSize.width)
		}
		return screenSize
	}

	open override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
		if let touch = touches.first {
			let locationPoint = touch.location(in: view)
			let converted = containerView.convert(locationPoint, from: view)
			if containerView.point(inside: converted, with: event){
				if noButtons {
					closeView(true, source: .cancel)
				}

			}
		}
	}
}

// Utility methods + extensions

// Extend UIImage with a method to create
// a UIImage from a solid color
//
// See: http://stackoverflow.com/questions/20300766/how-to-change-the-highlighted-color-of-a-uibutton
public extension UIImage {
	class func with(color: UIColor) -> UIImage {
		let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
		UIGraphicsBeginImageContext(rect.size)
		if let context = UIGraphicsGetCurrentContext() {
			context.setFillColor(color.cgColor)
			context.fill(rect)
		}

		let image = UIGraphicsGetImageFromCurrentImageContext()
		UIGraphicsEndImageContext()

		return image!
	}
}

// For any hex code 0xXXXXXX and alpha value,
// return a matching UIColor
public func UIColorFromHex(_ rgbValue:UInt32, alpha:Double=1.0)->UIColor {
	let red = CGFloat((rgbValue & 0xFF0000) >> 16)/256.0
	let green = CGFloat((rgbValue & 0xFF00) >> 8)/256.0
	let blue = CGFloat(rgbValue & 0xFF)/256.0

	return UIColor(red:red, green:green, blue:blue, alpha:CGFloat(alpha))
}

// For any UIColor and brightness value where darker <1
// and lighter (>1) return an altered UIColor.
//
// See: http://a2apps.com.au/lighten-or-darken-a-uicolor/
public func adjustBrightness(_ color:UIColor, amount:CGFloat) -> UIColor {
	var hue:CGFloat = 0
	var saturation:CGFloat = 0
	var brightness:CGFloat = 0
	var alpha:CGFloat = 0
	if color.getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha) {
		brightness += (amount-1.0)
		brightness = max(min(brightness, 1.0), 0.0)
		return UIColor(hue: hue, saturation: saturation, brightness: brightness, alpha: alpha)
	}
	return color
}
