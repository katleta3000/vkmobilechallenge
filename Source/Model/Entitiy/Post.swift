//
//  Post.swift
//  VKChallenge
//
//  Created by Evgenii Rtishchev on 10/11/2018.
//  Copyright © 2018 Evgenii Rtishchev. All rights reserved.
//

import Foundation

struct Post {
	var text: String?
	var likes: UInt = 0
	var views: UInt = 0
	var comments: UInt = 0
	var reposts: UInt = 0
	var date: Date!
	var photos: [Photo]?
}
