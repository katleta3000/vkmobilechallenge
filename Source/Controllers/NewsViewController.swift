//
//  ViewController.swift
//  VKChallenge
//
//  Created by Evgenii Rtishchev on 09/11/2018.
//  Copyright © 2018 Evgenii Rtishchev. All rights reserved.
//

import UIKit

final class NewsViewController: UIViewController {
	let vkService = ServiceLocator.shared.vkService
	let newsfeedService = ServiceLocator.shared.newsfeedService
	let userService = ServiceLocator.shared.userService
	let imageService = ServiceLocator.shared.imageService
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		newsfeedService.get(completion: { (posts, error) in
			print(posts)
		})
		
		if let userId = vkService.userId {
			userService.get(userId: userId) { (profile, error) in
				print(profile)
			}
		}
		
		let test = "http://diarioveaonline.com/wp-content/uploads/2018/06/well-images-for-wallpaper-desktop-24.jpg"
		imageService.get(urlString: test) { (image) in
			print(image)
		}
	}
}

