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

public class JSSAlertView: UIViewController {
	
	var containerView:UIView!
	var alertBackgroundView:UIView!
	var dismissButton:UIButton!
	var cancelButton:UIButton!
	var buttonLabel:UILabel!
	var cancelButtonLabel:UILabel!
	var titleLabel:UILabel!
	var textView:UITextView!
	weak var rootViewController:UIViewController!
	var iconImage:UIImage!
	var iconImageView:UIImageView!
	var closeAction:(()->Void)!
	var cancelAction:(()->Void)!
	var isAlertOpen:Bool = false
	var noButtons: Bool = false
	
	enum FontType {
		case Title, Text, Button
	}
	var titleFont = "HelveticaNeue-Light"
	var textFont = "HelveticaNeue"
	var buttonFont = "HelveticaNeue-Bold"
	
	var defaultColor = UIColorFromHex(0xF2F4F4, alpha: 1)
	
	public enum TextColorTheme {
		case Dark, Light
	}
	var darkTextColor = UIColorFromHex(0x000000, alpha: 0.75)
	var lightTextColor = UIColorFromHex(0xffffff, alpha: 0.9)
	
	enum ActionType {
		case Close, Cancel
	}
	
	let baseHeight:CGFloat = 160.0
	var alertWidth:CGFloat = 290.0
	let buttonHeight:CGFloat = 70.0
	let padding:CGFloat = 20.0
	
	var viewWidth:CGFloat?
	var viewHeight:CGFloat?
	
	// Allow alerts to be closed/renamed in a chainable manner
	public class JSSAlertViewResponder {
		let alertview: JSSAlertView
		
		public init(alertview: JSSAlertView) {
			self.alertview = alertview
		}
		
		public func addAction(action: ()->Void) {
			self.alertview.addAction(action)
		}
		
		public func addCancelAction(action: ()->Void) {
			self.alertview.addCancelAction(action)
		}
		
		public func setTitleFont(fontStr: String) {
			self.alertview.setFont(fontStr, type: .Title)
		}
		
		public func setTextFont(fontStr: String) {
			self.alertview.setFont(fontStr, type: .Text)
		}
		
		public func setButtonFont(fontStr: String) {
			self.alertview.setFont(fontStr, type: .Button)
		}
		
		public func setTextTheme(theme: TextColorTheme) {
			self.alertview.setTextTheme(theme)
		}
		
		@objc func close() {
			self.alertview.closeView(false)
		}
	}
	
	func setFont(fontStr: String, type: FontType) {
		switch type {
		case .Title:
			self.titleFont = fontStr
			if let font = UIFont(name: self.titleFont, size: 24) {
				self.titleLabel.font = font
			} else {
				self.titleLabel.font = UIFont.systemFontOfSize(24)
			}
		case .Text:
			if self.textView != nil {
				self.textFont = fontStr
				if let font = UIFont(name: self.textFont, size: 16) {
					self.textView.font = font
				} else {
					self.textView.font = UIFont.systemFontOfSize(16)
				}
			}
		case .Button:
			self.buttonFont = fontStr
			if let font = UIFont(name: self.buttonFont, size: 24) {
				self.buttonLabel.font = font
			} else {
				self.buttonLabel.font = UIFont.systemFontOfSize(24)
			}
		}
		// relayout to account for size changes
		self.viewDidLayoutSubviews()
	}
	
	func setTextTheme(theme: TextColorTheme) {
		switch theme {
		case .Light:
			recolorText(lightTextColor)
		case .Dark:
			recolorText(darkTextColor)
		}
	}
	
	func recolorText(color: UIColor) {
		titleLabel.textColor = color
		if textView != nil {
			textView.textColor = color
		}
		if self.noButtons == false {
			buttonLabel.textColor = color
			if cancelButtonLabel != nil {
				cancelButtonLabel.textColor = color
			}
		}
		
	}
	
	override public init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
		super.init(nibName:nibNameOrNil, bundle:nibBundleOrNil)
	}
	
	public required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override public func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	
	public override func viewDidLayoutSubviews() {
		super.viewWillLayoutSubviews()
		let size = self.rootViewControllerSize()
		self.viewWidth = size.width
		self.viewHeight = size.height
		
		var yPos:CGFloat = 0.0
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
		let titleAttr = [NSFontAttributeName:titleLabel.font]
		let titleSize = CGSize(width: contentWidth, height: 90)
		let titleRect = titleString.boundingRectWithSize(titleSize, options: NSStringDrawingOptions.UsesLineFragmentOrigin, attributes: titleAttr, context: nil)
		yPos += padding
		self.titleLabel.frame = CGRect(x: self.padding, y: yPos, width: self.alertWidth - (self.padding*2), height: ceil(titleRect.size.height))
		yPos += ceil(titleRect.size.height)
		
		
		// position text
		if self.textView != nil {
			let textString = textView.text! as NSString
			let textAttr = [NSFontAttributeName:textView.font as! AnyObject]
			let realSize = textView.sizeThatFits(CGSizeMake(contentWidth, CGFloat.max))
			let textSize = CGSize(width: contentWidth, height: CGFloat(fmaxf(Float(90.0), Float(realSize.height))))
			let textRect = textString.boundingRectWithSize(textSize, options: NSStringDrawingOptions.UsesLineFragmentOrigin, attributes: textAttr, context: nil)
			self.textView.frame = CGRect(x: self.padding, y: yPos, width: self.alertWidth - (self.padding*2), height: ceil(textRect.size.height)*2)
			yPos += ceil(textRect.size.height) + padding/2
		}
		
		// position the buttons
		
		if self.noButtons == false {
			yPos += self.padding
			
			var buttonWidth = self.alertWidth
			if self.cancelButton != nil {
				buttonWidth = self.alertWidth/2
				self.cancelButton.frame = CGRect(x: 0, y: yPos, width: buttonWidth-0.5, height: self.buttonHeight)
				if self.cancelButtonLabel != nil {
					self.cancelButtonLabel.frame = CGRect(x: self.padding, y: (self.buttonHeight/2) - 15, width: buttonWidth - (self.padding*2), height: 30)
				}
			}
			
			let buttonX = buttonWidth == self.alertWidth ? 0 : buttonWidth
			self.dismissButton.frame = CGRect(x: buttonX, y: yPos, width: buttonWidth, height: self.buttonHeight)
			if self.buttonLabel != nil {
				self.buttonLabel.frame = CGRect(x: self.padding, y: (self.buttonHeight/2) - 15, width: buttonWidth - (self.padding*2), height: 30)
			}
			
			// set button fonts
			if self.buttonLabel != nil {
				buttonLabel.font = UIFont(name: self.buttonFont, size: 20)
			}
			if self.cancelButtonLabel != nil {
				cancelButtonLabel.font = UIFont(name: self.buttonFont, size: 20)
			}
			yPos += self.buttonHeight
		}else{
			yPos += self.padding
		}
		
		
		// size the background view
		self.alertBackgroundView.frame = CGRect(x: 0, y: 0, width: self.alertWidth, height: yPos)
		
		// size the container that holds everything together
		self.containerView.frame = CGRect(x: (self.viewWidth!-self.alertWidth)/2, y: (self.viewHeight! - yPos)/2, width: self.alertWidth, height: yPos)
	}
	
	
	
	public func info(viewController: UIViewController, title: String, text: String?=nil, buttonText: String?=nil, cancelButtonText: String?=nil, delay: Double?=nil) -> JSSAlertViewResponder {
		let alertview = self.show(viewController, title: title, text: text, buttonText: buttonText, cancelButtonText: cancelButtonText, color: UIColorFromHex(0x3498db, alpha: 1), delay: delay)
		alertview.setTextTheme(.Light)
		return alertview
	}
	
	public func success(viewController: UIViewController, title: String, text: String?=nil, buttonText: String?=nil, cancelButtonText: String?=nil, delay: Double?=nil) -> JSSAlertViewResponder {
		return self.show(viewController, title: title, text: text, buttonText: buttonText, cancelButtonText: cancelButtonText, color: UIColorFromHex(0x2ecc71, alpha: 1), delay: delay)
	}
	
	public func warning(viewController: UIViewController, title: String, text: String?=nil, buttonText: String?=nil, cancelButtonText: String?=nil, delay: Double?=nil) -> JSSAlertViewResponder {
		return self.show(viewController, title: title, text: text, buttonText: buttonText, cancelButtonText: cancelButtonText, color: UIColorFromHex(0xf1c40f, alpha: 1), delay: delay)
	}
	
	public func danger(viewController: UIViewController, title: String, text: String?=nil, buttonText: String?=nil, cancelButtonText: String?=nil, delay: Double?=nil) -> JSSAlertViewResponder {
		let alertview = self.show(viewController, title: title, text: text, buttonText: buttonText, cancelButtonText: cancelButtonText, color: UIColorFromHex(0xe74c3c, alpha: 1), delay: delay)
		alertview.setTextTheme(.Light)
		return alertview
	}
	
	public func show(viewController: UIViewController, title: String, text: String?=nil, noButtons: Bool?=false, buttonText: String?=nil, cancelButtonText: String?=nil, color: UIColor?=nil, iconImage: UIImage?=nil, delay: Double?=nil) -> JSSAlertViewResponder {
		self.rootViewController = viewController
		
		if((viewController.navigationController) != nil) {
			self.rootViewController = viewController.navigationController
		}
		
		if rootViewController.isKindOfClass(UITableViewController){
			let tableViewController = rootViewController as! UITableViewController
			tableViewController.tableView.scrollEnabled = false
		}
		self.rootViewController.addChildViewController(self)
		self.rootViewController.view.addSubview(view)
		
		self.view.backgroundColor = UIColorFromHex(0x000000, alpha: 0.7)
		
		var baseColor:UIColor?
		if let customColor = color {
			baseColor = customColor
		} else {
			baseColor = self.defaultColor
		}
		let textColor = self.darkTextColor
		
		let sz = self.screenSize()
		self.viewWidth = sz.width
		self.viewHeight = sz.height
		
		self.view.frame.size = sz
		
		// Container for the entire alert modal contents
		self.containerView = UIView()
		self.view.addSubview(self.containerView!)
		
		// Background view/main color
		self.alertBackgroundView = UIView()
		alertBackgroundView.backgroundColor = baseColor
		alertBackgroundView.layer.cornerRadius = 4
		alertBackgroundView.layer.masksToBounds = true
		self.containerView.addSubview(alertBackgroundView!)
		
		// Icon
		self.iconImage = iconImage
		if self.iconImage != nil {
			self.iconImageView = UIImageView(image: self.iconImage)
			self.containerView.addSubview(iconImageView)
		}
		
		// Title
		self.titleLabel = UILabel()
		titleLabel.textColor = textColor
		titleLabel.numberOfLines = 0
		titleLabel.textAlignment = .Center
		titleLabel.font = UIFont(name: self.titleFont, size: 24)
		titleLabel.text = title
		self.containerView.addSubview(titleLabel)
		
		// View text
		if let text = text {
			self.textView = UITextView()
			self.textView.userInteractionEnabled = false
			textView.editable = false
			textView.textColor = textColor
			textView.textAlignment = .Center
			textView.font = UIFont(name: self.textFont, size: 16)
			textView.backgroundColor = UIColor.clearColor()
			textView.text = text
			self.containerView.addSubview(textView)
		}
		
		// Button
		self.noButtons = true
		if noButtons == false {
			self.noButtons = false
			self.dismissButton = UIButton()
			let buttonColor = UIImage.withColor(adjustBrightness(baseColor!, amount: 0.8))
			let buttonHighlightColor = UIImage.withColor(adjustBrightness(baseColor!, amount: 0.9))
			dismissButton.setBackgroundImage(buttonColor, forState: .Normal)
			dismissButton.setBackgroundImage(buttonHighlightColor, forState: .Highlighted)
			dismissButton.addTarget(self, action: #selector(JSSAlertView.buttonTap), forControlEvents: .TouchUpInside)
			alertBackgroundView!.addSubview(dismissButton)
			// Button text
			self.buttonLabel = UILabel()
			buttonLabel.textColor = textColor
			buttonLabel.numberOfLines = 1
			buttonLabel.textAlignment = .Center
			if let text = buttonText {
				buttonLabel.text = text
			} else {
				buttonLabel.text = "OK"
			}
			dismissButton.addSubview(buttonLabel)
			
			// Second cancel button
			if cancelButtonText != nil {
				self.cancelButton = UIButton()
				let buttonColor = UIImage.withColor(adjustBrightness(baseColor!, amount: 0.8))
				let buttonHighlightColor = UIImage.withColor(adjustBrightness(baseColor!, amount: 0.9))
				cancelButton.setBackgroundImage(buttonColor, forState: .Normal)
				cancelButton.setBackgroundImage(buttonHighlightColor, forState: .Highlighted)
				cancelButton.addTarget(self, action: #selector(JSSAlertView.cancelButtonTap), forControlEvents: .TouchUpInside)
				alertBackgroundView!.addSubview(cancelButton)
				// Button text
				self.cancelButtonLabel = UILabel()
				cancelButtonLabel.alpha = 0.7
				cancelButtonLabel.textColor = textColor
				cancelButtonLabel.numberOfLines = 1
				cancelButtonLabel.textAlignment = .Center
				cancelButtonLabel.text = cancelButtonText
				
				cancelButton.addSubview(cancelButtonLabel)
			}
		}
		
		// Animate it in
		self.view.alpha = 0
		UIView.animateWithDuration(0.2, animations: {
			self.view.alpha = 1
		})
		self.containerView.frame.origin.x = self.view.center.x
		self.containerView.center.y = -500
		UIView.animateWithDuration(0.5, delay: 0.05, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.5, options: [], animations: {
			self.containerView.center = self.view.center
			self.containerView.center = CGPoint(x: UIScreen.mainScreen().bounds.size.width / 2 , y: UIScreen.mainScreen().bounds.size.width / 2)
			
			}, completion: { finished in
				if let d = delay {
					let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(d * Double(NSEC_PER_SEC)))
					dispatch_after(delayTime, dispatch_get_main_queue()) {
						self.closeView(true)
					}
				}

		})
		
		isAlertOpen = true
		return JSSAlertViewResponder(alertview: self)
	}
	
	func addAction(action: ()->Void) {
		self.closeAction = action
	}
	
	func buttonTap() {
		closeView(true, source: .Close);
	}
	
	func addCancelAction(action: ()->Void) {
		self.cancelAction = action
	}
	
	func cancelButtonTap() {
		closeView(true, source: .Cancel);
	}
	
	func closeView(withCallback:Bool, source:ActionType = .Close) {
		UIView.animateWithDuration(0.3, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5, options: [], animations: {
			self.containerView.center.y = self.view.center.y + self.viewHeight!
			}, completion: { finished in
				UIView.animateWithDuration(0.1, animations: {
					self.view.alpha = 0
					}, completion: { finished in
						if withCallback {
							if let action = self.closeAction where source == .Close {
								action()
							}
							else if let action = self.cancelAction where source == .Cancel {
								action()
							}
						}
						if self.rootViewController.isKindOfClass(UITableViewController){
							let tableViewController = self.rootViewController as! UITableViewController
							tableViewController.tableView.scrollEnabled = true
						}
						self.removeView()
				})
				
		})
	}
	
	func removeView() {
		isAlertOpen = false
		self.removeFromParentViewController()
		self.view.removeFromSuperview()
	}
	
	func rootViewControllerSize() -> CGSize {
		let size = self.rootViewController.view.frame.size
		if (NSFoundationVersionNumber <= NSFoundationVersionNumber_iOS_7_1) && UIInterfaceOrientationIsLandscape(UIApplication.sharedApplication().statusBarOrientation) {
			return CGSizeMake(size.height, size.width)
		}
		return size
	}
	
	func screenSize() -> CGSize {
		let screenSize = UIScreen.mainScreen().bounds.size
		if (NSFoundationVersionNumber <= NSFoundationVersionNumber_iOS_7_1) && UIInterfaceOrientationIsLandscape(UIApplication.sharedApplication().statusBarOrientation) {
			return CGSizeMake(screenSize.height, screenSize.width)
		}
		return screenSize
	}
	
	override public func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
		if let touch = touches.first {
			let locationPoint = touch.locationInView(self.view)
			let converted = self.containerView.convertPoint(locationPoint, fromView: self.view)
			if self.containerView.pointInside(converted, withEvent: event){
				if self.noButtons == true {
					closeView(true, source: .Cancel)
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
	class func withColor(color: UIColor) -> UIImage {
		let rect = CGRectMake(0, 0, 1, 1)
		UIGraphicsBeginImageContext(rect.size)
		let context = UIGraphicsGetCurrentContext()
		
		CGContextSetFillColorWithColor(context, color.CGColor)
		CGContextFillRect(context, rect)
		
		let image = UIGraphicsGetImageFromCurrentImageContext()
		UIGraphicsEndImageContext()
		
		return image
	}
}

// For any hex code 0xXXXXXX and alpha value,
// return a matching UIColor
public func UIColorFromHex(rgbValue:UInt32, alpha:Double=1.0)->UIColor {
	let red = CGFloat((rgbValue & 0xFF0000) >> 16)/256.0
	let green = CGFloat((rgbValue & 0xFF00) >> 8)/256.0
	let blue = CGFloat(rgbValue & 0xFF)/256.0
	
	return UIColor(red:red, green:green, blue:blue, alpha:CGFloat(alpha))
}

// For any UIColor and brightness value where darker <1
// and lighter (>1) return an altered UIColor.
//
// See: http://a2apps.com.au/lighten-or-darken-a-uicolor/
public func adjustBrightness(color:UIColor, amount:CGFloat) -> UIColor {
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