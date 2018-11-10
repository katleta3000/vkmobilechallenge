//
//  UIImage+Round.swift
//  VKChallenge
//
//  Created by Evgenii Rtishchev on 10/11/2018.
//  Copyright © 2018 Evgenii Rtishchev. All rights reserved.
//

import UIKit

extension UIImage {
	
	var roundedImage: UIImage? {
		let rect = CGRect(origin:CGPoint(x: 0, y: 0), size: self.size)
		UIGraphicsBeginImageContextWithOptions(self.size, false, 1)
		UIBezierPath(
			roundedRect: rect,
			cornerRadius: self.size.height
			).addClip()
		self.draw(in:rect)
		return UIGraphicsGetImageFromCurrentImageContext()
	}
}
