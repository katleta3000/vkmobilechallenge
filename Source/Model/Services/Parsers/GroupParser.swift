//
//  GroupParser.swift
//  VKChallenge
//
//  Created by Evgenii Rtishchev on 11/11/2018.
//  Copyright © 2018 Evgenii Rtishchev. All rights reserved.
//

import Foundation

enum GroupParserError: Error {
	case noGroupId
	case noName
}

final class GroupParser {
	
	static func parse(groupJSON: [String: Any]) -> (group: Group?, error: Error?) {
		guard let groupId = groupJSON["id"] as? Int else {
			return (nil, GroupParserError.noGroupId)
		}
		guard let name = groupJSON["name"] as? String else {
			return (nil, GroupParserError.noName)
		}
		var group = Group()
		group.id = groupId
		group.name = name
		
		if let url = groupJSON["photo_100"] as? String {
			group.photoUrl = url
		}
		if let deactivated = groupJSON["deactivated"] as? String {
			if deactivated == "deleted" {
				group.problem = .deleted
			} else if deactivated == "banned" {
				group.problem = .banned
			}
		}
		return (group, nil)
	}
}
