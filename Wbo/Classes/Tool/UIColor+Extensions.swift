//
//  UIColor+Extensions.swift
//  BrightKit
//
//  Created by Benni on 22.07.14.
//  Copyright (c) 2014 Natural High Code. All rights reserved.
//

import UIKit

enum DisplayMode: Int {
	case Percent
	case ToOne
	case To255
}

extension UIColor {
	
	convenience init(red: Int, green: Int, blue: Int) {
		let _red = CGFloat(red) / CGFloat(255)
		let _green = CGFloat(green) / CGFloat(255)
		let _blue = CGFloat(blue) / CGFloat(255)
		self.init(red:_red, green: _green, blue: _blue, alpha: 1.0)
	}
	
	convenience init(hex: Int, alpha: CGFloat = 1.0) {
		let red = CGFloat((hex & 0xFF0000) >> 16) / 255.0
		let green = CGFloat((hex & 0xFF00) >> 8) / 255.0
		let blue = CGFloat((hex & 0xFF)) / 255.0
		self.init(red:red, green:green, blue:blue, alpha:alpha)
	}
	
	
	var red: CGFloat {
		return self.rgba.red
	}
	var green: CGFloat {
		return self.rgba.green
	}
	var blue: CGFloat {
		return self.rgba.blue
	}
	var alpha: CGFloat {
		return self.rgba.alpha
	}
	var rgba: (red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) {
		return (CGColorGetComponents(self.CGColor)[0], CGColorGetComponents(self.CGColor)[1], CGColorGetComponents(self.CGColor)[2], CGColorGetComponents(self.CGColor)[3])
	}
	
	var cyan: CGFloat {
		return self.cmyk.cyan
	}
	var magenta: CGFloat {
		return self.cmyk.magenta
	}
	var yellow: CGFloat {
		return self.cmyk.yellow
	}
	var black: CGFloat {
		return self.cmyk.black
	}
	var cmyk: (cyan: CGFloat, magenta: CGFloat, yellow: CGFloat, black: CGFloat) {
		var c, m, y, k: CGFloat
		
		if (self.red == 0 && self.green == 0 && self.blue == 0) {
			c = 0; m = 0; y = 0; k = 1;
			return (c, m, y, k)
		}
		
		c = 1 - self.red
		m = 1 - self.green
		y = 1 - self.blue
		
		let min = c.min(m).min(y)
		
		c = (c - min) / (1 - min)
		m = (m - min) / (1 - min)
		y = (y - min) / (1 - min)
		k = min
		
		return (c, m, y, k)
	}
	
//	var hexValue: Int {
//		return ((Int)(self.red * 255) << 16) + ((Int)(self.green * 255) << 8) + (Int)(self.blue * 255)
//	}

	func getRGBValue(mode: DisplayMode) -> String? {
		var (red, green, blue, _) = self.rgba
		var invalidMode = false
		let formatter = NSNumberFormatter()
		formatter.locale = NSLocale.currentLocale()
		
		switch mode {
		case .Percent:
			formatter.numberStyle = NSNumberFormatterStyle.PercentStyle
		case .ToOne:
			formatter.numberStyle = NSNumberFormatterStyle.DecimalStyle
			formatter.maximumFractionDigits = 2
		case .To255:
			formatter.numberStyle = NSNumberFormatterStyle.DecimalStyle
			formatter.maximumFractionDigits = 0
			red *= 255;	green *= 255; blue *= 255
		default:
			invalidMode = true
		}
		
		return invalidMode ? nil : "(\(formatter.stringFromNumber(red)!), \(formatter.stringFromNumber(green)!), \(formatter.stringFromNumber(blue)!))"
	}
	
	func getCMYKValue(mode: DisplayMode) -> String? {
		var (cyan, magenta, yellow, black) = self.cmyk
		var invalidMode = false
		let formatter = NSNumberFormatter()
		formatter.locale = NSLocale.currentLocale()
		
		switch mode {
		case .Percent:
			formatter.numberStyle = NSNumberFormatterStyle.PercentStyle
		case .ToOne:
			formatter.numberStyle = NSNumberFormatterStyle.DecimalStyle
			formatter.maximumFractionDigits = 2
		case .To255:
			formatter.numberStyle = NSNumberFormatterStyle.DecimalStyle
			formatter.maximumFractionDigits = 0
			cyan *= 255; magenta *= 255; yellow *= 255; black *= 255
		default:
			invalidMode = true
		}

		return invalidMode ? nil : "(\(formatter.stringFromNumber(cyan)!), \(formatter.stringFromNumber(magenta)!), \(formatter.stringFromNumber(yellow)!), \(formatter.stringFromNumber(black)!))"
	}
	
	func getHSBValue(mode: DisplayMode) -> String {
		return ""
	}
	
	func getHexValue(mode: DisplayMode) -> String {
		return ""
	}
	
}



