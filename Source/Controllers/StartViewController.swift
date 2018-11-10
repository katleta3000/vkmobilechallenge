//
//  StartViewController.swift
//  VKChallenge
//
//  Created by Evgenii Rtishchev on 09/11/2018.
//  Copyright © 2018 Evgenii Rtishchev. All rights reserved.
//

import UIKit
import VKSdkFramework

/// Начальный контроллер, основная задача – авторизация и перенаправление на экран c newsfeed
final class StartViewController: UIViewController {
	let vkService = ServiceLocator.shared.vkService
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		vkService.setup(with: self)
	}
}

extension StartViewController: VKServiceDelegate {
	
	func authorizationFinished() {
		performSegue(withIdentifier: "NewsViewController", sender: nil)
	}
	
	func vkSdkNeedCaptchaEnter(_ captchaError: VKError!) {
		// TODO реализовать UI для ввода капчи
	}
	
	func vkSdkShouldPresent(_ controller: UIViewController!) {
		present(controller, animated: true, completion: nil);
	}
}
