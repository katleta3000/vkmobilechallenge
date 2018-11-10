//
//  ImageService.swift
//  VKChallenge
//
//  Created by Evgenii Rtishchev on 10/11/2018.
//  Copyright © 2018 Evgenii Rtishchev. All rights reserved.
//

import UIKit

final class ImageService {
	let session: URLSession
	let MB = 1024 * 1024
	
	init() {
		let configuration = URLSessionConfiguration.default
		configuration.urlCache = URLCache(memoryCapacity: 50 * MB, diskCapacity: 50 * MB, diskPath: "images")
		session = URLSession(configuration: configuration)
	}

	func get(urlString: String, round: Bool = false, completion: @escaping (UIImage?) -> Void) {
		guard let url = URL(string: urlString) else {
			DispatchQueue.main.sync {
				completion(nil);
			}
			return
		}
		session.dataTask(with: url) { (data, response, error) in
			if let data = data {
				var image = UIImage(data: data)
				if round {
					image = image?.roundedImage
				}
				DispatchQueue.main.async {
					completion(image)
				}
			} else {
				DispatchQueue.main.async {
					completion(nil)
				}
			}
		}.resume()
	}
}
