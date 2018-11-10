//
//  PostService.swift
//  VKChallenge
//
//  Created by Evgenii Rtishchev on 10/11/2018.
//  Copyright © 2018 Evgenii Rtishchev. All rights reserved.
//

import Foundation

enum PostServiceError: Error {
	case modelParsing
	case noPostDate
	case noPostsResponse
}

/// Шаблон репозиторий или CRUD-интерфейс, задача которого реализовать работу с объектами типа Post
final class PostService {
	let vkService: VKService
	
	init(vkService: VKService) {
		self.vkService = vkService
	}
	
	func get(completion:@escaping ([Post], Error?) -> Void) {
		vkService.get(with: "newsfeed.get", params: nil, completion: { [weak self] (data, error) in
			if let error = error {
				completion([], error)
			} else {
				DispatchQueue.global(qos: .userInitiated).async {
					let response = self?.parseJSON(json: data)
					DispatchQueue.main.sync {
						if let error = response?.error {
							completion([], error)
						} else if let posts = response?.posts {
							completion(posts, nil)
						} else {
							completion([], PostServiceError.noPostsResponse)
						}
					}
				}
			}
		})
	}
}

// MARK: - response parsing, model mapping

private extension PostService {
	
	func parseJSON(json: Any?) -> (posts: [Post], error: Error?) {
		guard let dict = json as? [String : Any], let response = dict["response"] as? [String: Any] else {
			return ([], PostServiceError.modelParsing)
		}
		guard let items = response["items"] as? [[String: Any]] else {
			return ([], PostServiceError.modelParsing)
		}
		var posts = [Post]()
		for item in items {
			// TODO можно убрать raise ошибки, если не прошла валидации одного поста, а просто не включать его в итоговую выдачу
			let postResponse = parsePost(postJson: item)
			if let error = postResponse.error {
				return ([], error)
			} else if let post = postResponse.post {
				posts.append(post)
			}
		}
		return (posts, nil)
	}
	
	func parsePost(postJson: [String: Any]) -> (post: Post?, error: Error?) {
		var post = Post()
		
		if let dateTimestamp = postJson["date"] as? TimeInterval {
			post.date = Date(timeIntervalSince1970: dateTimestamp)
		} else {
			return (nil, PostServiceError.noPostDate)
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
		post.text = postJson["text"] as? String
		return (post, nil)
	}
}
