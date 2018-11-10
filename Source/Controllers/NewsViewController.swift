//
//  ViewController.swift
//  VKChallenge
//
//  Created by Evgenii Rtishchev on 09/11/2018.
//  Copyright © 2018 Evgenii Rtishchev. All rights reserved.
//

import UIKit

final class NewsViewController: UIViewController {
	let PostService = ServiceLocator.shared.newsfeed
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		PostService.get(completion: { (posts, error) in
			
		})
	}
}

