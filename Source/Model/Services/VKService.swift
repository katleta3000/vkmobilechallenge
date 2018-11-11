//
//  VKService.swift
//  VKChallenge
//
//  Created by Evgenii Rtishchev on 10/11/2018.
//  Copyright © 2018 Evgenii Rtishchev. All rights reserved.
//

import Foundation
import VKSdkFramework

protocol VKServiceDelegate: VKSdkUIDelegate {
	func authorizationFinished()
}

enum VKServiceError: Error {
	case nilComponents
	case nilUrl
	case noData
	case noResponse
	case connectionError(error: Error)
	case httpError(code: Int)
	case jsonSerialization(error: Error)
}

/// Класс-модель, обеспечивающий работу с API Vkontakte
final class VKService: NSObject {
	private(set) var userId: String?
	private let appID = "6747106"
	private let scope = ["wall", "friends"]
	private let apiString = "https://api.vk.com/method/"
	private let apiVersion = "5.87"
	private var sdkInstance: VKSdk?
	private var accessToken: String?
	private var delegate: VKServiceDelegate?

	func setup(with delegate: VKServiceDelegate) {
		self.delegate = delegate
		sdkInstance = VKSdk.initialize(withAppId: appID)
		sdkInstance?.register(self)
		sdkInstance?.uiDelegate = delegate
		VKSdk.wakeUpSession(scope) { (state, error) in
			// TODO обработать ошибку и различные состояние
			if state == .authorized {
				delegate.authorizationFinished()
			} else {
				VKSdk.authorize(self.scope)
			}
		}
	}
	
	func get(with methodName: String, params: [(name: String, value: String)]?, completion:@escaping (Any?, Error?) -> Void) {
		func raiseError(_ error: Error) {
			completion(nil, error)
		}
		guard var components = URLComponents(string: "\(apiString)\(methodName)") else {
			raiseError(VKServiceError.nilComponents);
			return
		}
		var items = [
			URLQueryItem(name: "access_token", value: accessToken),
			URLQueryItem(name: "v", value: apiVersion)
		]
		if let params = params {
			for param in params {
				items.append(URLQueryItem(name: param.name, value: param.value))
			}
		}
		components.queryItems = items
		guard let url = components.url else {
			raiseError(VKServiceError.nilUrl);
			return
		}
		let request = URLRequest(url: url)
		URLSession.shared.dataTask(with: request) { (data, response, error) in
			if let httpResponse = response as? HTTPURLResponse {
				if let error = error {
					raiseError(VKServiceError.connectionError(error: error))
					return;
				}
				if 200...299 ~= httpResponse.statusCode {
					guard let data = data else {
						raiseError(VKServiceError.noData)
						return;
					}
					do {
						let json = try JSONSerialization.jsonObject(with:data, options: [])
						completion(json, nil)
					} catch let jsonError {
						raiseError(VKServiceError.jsonSerialization(error: jsonError))
					}
				} else {
					raiseError(VKServiceError.httpError(code: httpResponse.statusCode))
				}
			} else {
				raiseError(VKServiceError.noResponse)
			}
		}.resume()
	}
}

extension VKService: VKSdkDelegate {
	
	func vkSdkAccessTokenUpdated(_ newToken: VKAccessToken!, oldToken: VKAccessToken!) {
		// Оказывается newToken может быть nil – произойдёт креш, видимо это обозначает, что токен протух.
		// Давайте на следующий конкурс сделаем мобильный SDK для работы с VK API, ориентированный на Swift? :-)
		if newToken != nil {
			accessToken = newToken.accessToken
			userId = newToken.userId
		}
	}
	
	func vkSdkAuthorizationStateUpdated(with result: VKAuthorizationResult!) {
		if result.state == .authorized {
			delegate?.authorizationFinished()
		} else {
			// TODO обработать изменение стейта авторизации и ошибки
		}
	}
	
	func vkSdkTokenHasExpired(_ expiredToken: VKAccessToken!) {
		// TODO обработать обнуление токена
	}
	
	func vkSdkAccessAuthorizationFinished(with result: VKAuthorizationResult!) {
		if result == nil {
			// TODO обработать ошибку – судя по крешу accessToken, он может быть nil, доверять optional не стоит
			return
		}
		if result.token != nil {
			accessToken = result.token.accessToken
			userId = result.token.userId
		} else {
			// TODO обработать ошибку
		}
		if result.state == .authorized {
			delegate?.authorizationFinished()
		} else {
			// TODO обработать ошибку
		}
	}
	
	func vkSdkUserAuthorizationFailed() {
		// TODO обработать ошибку
	}
}
