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
	@IBOutlet private weak var tableView: UITableView!
	@IBOutlet private weak var topBar: UIView!
	private let refreshControl = UIRefreshControl()
	private var postData = [Post]()
	
	override func viewDidLoad() {
		func setupRefreshControl() {
			if #available(iOS 10.0, *) {
				tableView.refreshControl = refreshControl
			} else {
				tableView.addSubview(refreshControl)
			}
			refreshControl.addTarget(self, action: #selector(pulledToRefresh), for: .valueChanged)
		}
		func setupBackground() {
			let view = UIView(frame: self.view.bounds)
			let gradient = CAGradientLayer()
			gradient.frame = view.bounds
			let startColor = UIColor(red: 0.97, green: 0.97, blue: 0.98, alpha: 1)
			let endColor = UIColor(red: 0.92, green: 0.93, blue: 0.94, alpha: 1)
			gradient.colors = [startColor.cgColor, endColor.cgColor]
			view.layer.insertSublayer(gradient, at: 0)
			self.view.insertSubview(view, belowSubview: tableView)
			tableView.backgroundColor = .clear
		}
		super.viewDidLoad()
		setupBackground()
		setupRefreshControl()
		refreshControl.beginRefreshing()
		getNewsfeed()
	}
	
	@objc private func pulledToRefresh() {
		stopRefreshing()
	}
	
	private func stopRefreshing() {
		if self.refreshControl.isRefreshing {
			self.refreshControl.endRefreshing()
		}
	}
	
	private func getNewsfeed() {
		newsfeedService.get { [unowned self] (posts, error) in
			DispatchQueue.global(qos: .userInitiated).async {
				if let _ = error {
					// TODO обработать ошибку
					DispatchQueue.main.async {
						self.stopRefreshing()
					}
				} else {
					// добавить преобразование моделей
					DispatchQueue.main.async {
						self.postData = posts
						self.stopRefreshing()
						self.tableView.reloadData()
					}
				}
			}
		}
	}
}

// MARK: table view delegates & data source

extension NewsViewController: UITableViewDelegate, UITableViewDataSource {
	
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return 100
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return postData.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath) as! PostTableCell
		cell.backgroundColor = .white
		cell.setup()
		cell.textLabel?.text = "test"
		return cell
	}
}

