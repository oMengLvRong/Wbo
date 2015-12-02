//
//  Float+Extensions.swift
//  FlatColors
//
//  Created by Benni on 15.05.15.
//  Copyright (c) 2015 Benni. All rights reserved.
//

import Foundation
import CoreGraphics

extension Float {
	func min(float: Float) -> Float {
		return (self > float) ? float : self
	}
	
	func max(float: Float) -> Float {
		return (self < float) ? float : self
	}
}

extension CGFloat {
	func min(float: CGFloat) -> CGFloat {
		return (self > float) ? float : self
	}
	
	func max(float: CGFloat) -> CGFloat {
		return (self < float) ? float : self
	}
}