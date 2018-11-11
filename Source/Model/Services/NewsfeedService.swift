//
//  NewsfeedService.swift
//  VKChallenge
//
//  Created by Evgenii Rtishchev on 10/11/2018.
//  Copyright © 2018 Evgenii Rtishchev. All rights reserved.
//

import Foundation

enum NewsfeedServiceError: Error {
	case modelParsing
	case noPostsResponse
}

/// Шаблон репозиторий или CRUD-интерфейс по работе с новостной лентой, возращает массив объектов Post
final class NewsfeedService {
	let vkService: VKService
	
	init(vkService: VKService) {
		self.vkService = vkService
	}
	
	func get(from: String? = nil, completion:@escaping ([Post], String?, Error?) -> Void) {
		var params =  [(name: "source_ids", value: "friends,groups,pages"),
					   (name: "filters", value: "post"),
					   (name: "count", value: "20")
		]
		if let startFrom = from {
			params.append((name: "start_from", value: startFrom))
		}
		vkService.get(with: "newsfeed.get", params: params, completion: { [weak self] (data, error) in
			if let error = error {
				DispatchQueue.main.async {
					completion([], nil, error)
				}
			} else {
				let response = self?.parseJSON(json: data)
				DispatchQueue.main.async {
					if let error = response?.error {
						completion([], nil, error)
					} else if let posts = response?.posts {
						completion(posts, response?.nextFrom, nil)
					} else {
						completion([], nil, NewsfeedServiceError.noPostsResponse)
					}
				}
			}
		})
	}
}

// MARK: - response parsing, model mapping

private extension NewsfeedService {
	
	func parseJSON(json: Any?) -> (posts: [Post], nextFrom: String?, error: Error?) {
		guard let dict = json as? [String : Any], let response = dict["response"] as? [String: Any] else {
			return ([], nil, NewsfeedServiceError.modelParsing)
		}
		guard let items = response["items"] as? [[String: Any]] else {
			return ([], nil, NewsfeedServiceError.modelParsing)
		}
		var profiles = [Int: Profile]()
		if let profilesJson = response["profiles"] as? [[String: Any]] {
			for item in profilesJson {
				let profileResponse = ProfileParser.parse(profileJSON: item)
				if let profile = profileResponse.profile, profileResponse.error == nil {
					profiles[profile.id] = profile
				}
			}
		}
		var groups = [Int: Group]()
		if let groupsJson = response["groups"] as? [[String: Any]] {
			for item in groupsJson {
				let groupsResponse = GroupParser.parse(groupJSON: item)
				if let group = groupsResponse.group, groupsResponse.error == nil {
					groups[group.id] = group
				}
			}
		}
		var posts = [Post]()
		for item in items {
			// TODO можно убрать raise ошибки, если не прошла валидации одного поста, а просто не включать его в итоговую выдачу, как сделано для профилей
			let postResponse = PostParser.parse(postJson: item, profiles: profiles, groups: groups)
			if let error = postResponse.error {
				return ([], nil, error)
			} else if let post = postResponse.post {
				posts.append(post)
			}
		}
		let nextFrom = response["next_from"] as? String
		return (posts, nextFrom, nil)
	}
}
