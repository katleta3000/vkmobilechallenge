//
//  ServiceLocator.swift
//  VKChallenge
//
//  Created by Evgenii Rtishchev on 09/11/2018.
//  Copyright © 2018 Evgenii Rtishchev. All rights reserved.
//

import Foundation

/// Шаблон сервис-локатор, который обеспечивает распространение зависимостей
final class ServiceLocator {
	static let shared = ServiceLocator()
	let vkService = VKService()
	let newsfeed: NewsfeedService
	
	private init() {
		newsfeed = NewsfeedService(vkService: vkService)
	}
	
}
