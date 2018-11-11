//
//  FooterPresentation.swift
//  VKChallenge
//
//  Created by Evgenii Rtishchev on 11/11/2018.
//  Copyright © 2018 Evgenii Rtishchev. All rights reserved.
//

import Foundation

final class FooterPresentation {
	
	static func text(for postsCount: Int) -> String {
		// 1, 21, 31, 41, 101, 1001, запись (2 последние != 11, а последняя == 1)
		// 2, 3, 4, 22, 23, 54, 1133 записи (2 последние != 12, 13, 14, а последняя == 2, 3, 4
		// 0, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 111, 1012 записей (всё остальное)
		switch postsCount {
		case 1, 21, 31, 41, 51, 61, 71, 81, 91:
			return "1 запись"
		case 2, 3, 4, 22, 23, 24, 32, 33, 34, 42, 43, 44, 52, 53, 54, 62, 63, 64, 72, 73, 74, 82, 83, 84, 92, 93, 94:
			return String(format: "%d записи", postsCount)
		case _ where postsCount > 100:
			let last2Digits = postsCount % 100
			let lastDigit = postsCount % 10
			
			switch lastDigit {
			case 1 where last2Digits != 11:
				return String(format: "%d запись", postsCount)
			case 2...4 where last2Digits < 11 && last2Digits > 14:
				return String(format: "%d записи", postsCount)
			default:
				return String(format: "%d записей", postsCount)
			}
		default:
			return String(format: "%d записей", postsCount)
		}
	}
}
