//
//  PostPresentationModel.swift
//  VKChallenge
//
//  Created by Evgenii Rtishchev on 10/11/2018.
//  Copyright © 2018 Evgenii Rtishchev. All rights reserved.
//

import UIKit

struct PostPresentation {
	let maxWidth = UIScreen.main.bounds.size.width - 40
	let totalHeight: CGFloat
	let textHeight: CGFloat
	let imageUrl: String?
	let author: String
	let date: String
	let likes: String
	let reposts: String
	let comments: String
	let views: String
	let text: NSAttributedString?

	init(with post: Post) {
		
		func prepareAuthor() -> String {
			if let problem = post.user?.problem ?? post.group?.problem {
				return problem.rawValue
			} else if let user = post.user {
				if let firstName = user.firstName, let lastName = user.lastName {
					return "\(firstName) \(lastName)"
				} else if let firstName = user.firstName {
					return firstName
				} else if let lastName = user.lastName {
					return lastName
				} else {
					return ""
				}
			} else if let group = post.group {
				return group.name
			} else {
				return ""
			}
		}
		
		func prepareDate() -> String {
			let formatter = DateFormatter()
			formatter.dateFormat = "d MMM в HH:mm"
			return formatter.string(from: post.date)
		}
		
		func prepareViews() -> String {
			let count = post.views
			if count < 1000 {
				return "\(post.views)"
			} else if count < 10000 {
				return String(format: "%.1fK", Float(count) / 1000)
			} else {
				return String(format: "%.0fK", floorf(Float(count) / 1000))
			}
		}
		
		author = prepareAuthor()
		date = prepareDate()
		imageUrl = post.user?.photoUrl ?? post.group?.photoUrl
		likes = "\(post.likes)"
		reposts = "\(post.reposts)"
		comments = "\(post.comments)"
		views = prepareViews()
		
		if let text = post.text, text.count > 0 {
			let attributedString = NSMutableAttributedString(string: text)
			let range = NSMakeRange(0, attributedString.string.count - 1)
			if let font = UIFont(name: "SFProText-Regular", size: 15) {
				attributedString.addAttributes([NSAttributedString.Key.font: font], range: range)
			}
			attributedString.addAttributes([NSAttributedString.Key.kern: -0.17], range: range)
			let paragraphStyle = NSMutableParagraphStyle()
			paragraphStyle.lineBreakMode = .byWordWrapping
			paragraphStyle.lineSpacing = 4
			attributedString.addAttributes([NSAttributedString.Key.paragraphStyle: paragraphStyle], range: range)
			
			let size = attributedString.boundingRect(with: CGSize(width: maxWidth, height: CGFloat.greatestFiniteMagnitude), options: [.usesLineFragmentOrigin, .usesFontLeading], context: nil)
			
			self.text = attributedString
			textHeight = size.height
		} else {
			self.text = nil
			textHeight = 0
		}
		totalHeight = 118 + textHeight // минимум 12 (отступ до аватарки) + 36 (аватарка) + 10 (отступ до текста) + 6 (отступ до нижнего бара) + 48 (нижний бар) + 12 (отсупы самого бабла)
	}
}
