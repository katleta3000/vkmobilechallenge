//
//  PostParser.swift
//  VKChallenge
//
//  Created by Evgenii Rtishchev on 11/11/2018.
//  Copyright © 2018 Evgenii Rtishchev. All rights reserved.
//

import Foundation

enum PostParserError: Error {
	case noPostDate
}

final class PostParser {
	
	static func parse(postJson: [String: Any], profiles: [Int: Profile], groups: [Int: Group]) -> (post: Post?, error: Error?) {
		var post = Post()
		
		if let dateTimestamp = postJson["date"] as? TimeInterval {
			post.date = Date(timeIntervalSince1970: dateTimestamp)
		} else {
			return (nil, PostParserError.noPostDate)
		}
		
		if let comments = postJson["comments"] as? [String: Any], let commentsCount = comments["count"] as? UInt {
			post.comments = commentsCount
		}
		if let likes = postJson["likes"] as? [String: Any], let likesCount = likes["count"] as? UInt {
			post.likes = likesCount
		}
		if let reposts = postJson["reposts"] as? [String: Any], let repostsCount = reposts["count"] as? UInt {
			post.reposts = repostsCount
		}
		if let views = postJson["views"] as? [String: Any], let viewsCount = views["count"] as? UInt {
			post.views = viewsCount
		}
		if let sourceId = postJson["source_id"] as? Int {
			if sourceId > 0, let profile = profiles[sourceId] {
				post.user = profile
			} else if sourceId < 0, let group = groups[abs(sourceId)] {
				post.group = group
			}
		}
		var photos = [Photo]()
		if let attachments = postJson["attachments"] as? [[String: Any]] {
			for attachment in attachments {
				if let type = attachment["type"] as? String,
					type == "photo",
					let photoJSON = attachment["photo"] as? [String: Any],
					let sizes = photoJSON["sizes"] as? [[String: Any]] {
					for sizeItem in sizes {
						if let type = sizeItem["type"] as? String, type == "r", let url = sizeItem["url"] as? String {
							photos.append(Photo(url: url))
						}
					}
				}
			}
		}
		post.photos = photos
		post.text = postJson["text"] as? String
		return (post, nil)
	}
}
