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
}

/// Шаблон репозиторий или CRUD-интерфейс, который обеспечивает работу с моделями Newsfeed
final class NewsfeedService {
	let vkService: VKService
	
	init(vkService: VKService) {
		self.vkService = vkService
	}
	
	func get(completion:@escaping ([Post], Error?) -> Void) {
		vkService.get(with: "newsfeed.get", params: nil, completion: { (data, error) in
			if let error = error {
				completion([], error)
			} else {
				DispatchQueue.global(qos: .userInitiated).async {
					let response = self.parseJSON(json: data)
					DispatchQueue.main.sync {
						if let error = response.error {
							completion([], error)
						} else {
							completion(response.posts, nil)
						}
					}
				}
			}
		})
	}
	
	private func parseJSON(json: Any?) -> (posts: [Post], error: Error?) {
		guard let response = json as? [String : Any] else {
			return ([], NewsfeedServiceError.modelParsing )
		}
		guard let items = response["response"] as? [String: [String: Any]] else {
			return ([], NewsfeedServiceError.modelParsing)
		}
		for item in items {
			print(item)
		}
		return ([], nil)
	}
}
