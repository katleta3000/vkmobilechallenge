//
//  ProfileParser.swift
//  VKChallenge
//
//  Created by Evgenii Rtishchev on 10/11/2018.
//  Copyright © 2018 Evgenii Rtishchev. All rights reserved.
//

import UIKit

enum ProfileParserError: Error {
	case noUserId
}

final class ProfileParser {
	
	static func parse(profileJSON: [String: Any]) -> (profile: Profile?, error: Error?) {
		guard let userId = profileJSON["id"] as? Int else {
			return (nil, ProfileParserError.noUserId)
		}
		var profile = Profile()
		profile.id = userId
		
		if let firstName = profileJSON["first_name"] as? String {
			profile.firstName = firstName
		}
		if let lastName = profileJSON["last_name"] as? String {
			profile.lastName = lastName
		}
		if let url = profileJSON["photo_100"] as? String {
			profile.photoUrl = url
		}
		if let deactivated = profileJSON["deactivated"] as? String {
			if deactivated == "deleted" {
				profile.problem = .deleted
			} else if deactivated == "banned" {
				profile.problem = .banned
			}
		}
		return (profile, nil)
	}
}
