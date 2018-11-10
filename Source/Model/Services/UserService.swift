//
//  UserService.swift
//  VKChallenge
//
//  Created by Evgenii Rtishchev on 10/11/2018.
//  Copyright © 2018 Evgenii Rtishchev. All rights reserved.
//

import Foundation

enum UserServiceError: Error {
	case modelParsing
	case noProfilesResponse
}

/// Шаблон репозиторий или CRUD-интерфейс по работе с профилями пользователей
final class UserService {
	let vkService: VKService
	
	init(vkService: VKService) {
		self.vkService = vkService
	}
	
	func get(userId: String, completion:@escaping ([Profile], Error?) -> Void) {
		let params =  [(name: "user_ids", value: userId), (name: "fields", value: "photo_100")]
		self.vkService.get(with: "users.get", params: params, completion: { [weak self] (data, error) in
			if let error = error {
				DispatchQueue.main.async {
					completion([], error)
				}
			} else {
				let response = self?.parseJSON(json: data)
				DispatchQueue.main.async {
					if let error = response?.error {
						completion([], error)
					} else if let profiles = response?.profiles {
						completion(profiles, nil)
					} else {
						completion([], UserServiceError.noProfilesResponse)
					}
				}
			}
		})
	}
}

// MARK: - response parsing, model mapping

private extension UserService {

	func parseJSON(json: Any?) -> (profiles: [Profile], error: Error?) {
		guard let dict = json as? [String : Any], let items = dict["response"] as? [[String: Any]] else {
			return ([], UserServiceError.modelParsing)
		}
		var profiles = [Profile]()
		for item in items {
			let profileResponse = ProfileParser.parse(profileJSON: item)
			if let profile = profileResponse.profile, profileResponse.error == nil {
				profiles.append(profile)
			}
		}
		return (profiles, nil)
	}
}
