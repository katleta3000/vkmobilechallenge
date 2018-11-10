//
//  ViewController.swift
//  VKChallenge
//
//  Created by Evgenii Rtishchev on 09/11/2018.
//  Copyright © 2018 Evgenii Rtishchev. All rights reserved.
//

import UIKit

final class NewsViewController: UIViewController {
	let newsfeedService = ServiceLocator.shared.newsfeed
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		newsfeedService.get(completion: { (posts, error) in
			
		})
	}
}

