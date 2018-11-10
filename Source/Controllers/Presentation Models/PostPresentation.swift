//
//  PostPresentationModel.swift
//  VKChallenge
//
//  Created by Evgenii Rtishchev on 10/11/2018.
//  Copyright © 2018 Evgenii Rtishchev. All rights reserved.
//

import UIKit

struct PostPresentation {
	let height: CGFloat
	let imageUrl: String?
	let author: String
	let date: String
	let likes: String
	let reposts: String
	let comments: String
	let views: String

	init(with post: Post) {
		
		func prepareAuthor() -> String {
			if let user = post.user {
				if let firstName = user.firstName, let lastName = user.lastName {
					return "\(firstName) \(lastName)"
				} else if let firstName = user.firstName {
					return firstName
				} else if let lastName = user.lastName {
					return lastName
				} else {
					return ""
				}
			} else {
				return ""
			}
		}
		
		func prepareDate() -> String {
			let formatter = DateFormatter()
			formatter.dateFormat = "d MMM в HH:mm"
			return formatter.string(from: post.date)
		}
		
		author = prepareAuthor()
		date = prepareDate()
		imageUrl = post.user?.photoUrl
		likes = "\(post.likes)"
		reposts = "\(post.reposts)"
		comments = "\(post.comments)"
		views = ""
		height = 120
	}
	
	
}
