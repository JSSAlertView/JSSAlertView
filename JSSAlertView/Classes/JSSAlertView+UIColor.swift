//
//  JSSAlertView+UIColor.swift
//  Pods
//
//  Created by Tomas Sykora, jr. on 05/11/2016.
//
//

import UIKit

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
