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
	@IBOutlet private weak var headerView: UIView!
	@IBOutlet private weak var searchBar: UISearchBar!
	@IBOutlet private weak var headerImageView: UIImageView!
	private let refreshControl = UIRefreshControl()
	private var postData = [PostPresentation]()
	
	override func viewDidLoad() {
		
		UIFont.familyNames.forEach({ familyName in
			let fontNames = UIFont.fontNames(forFamilyName: familyName)
			print(familyName, fontNames)
		})
		
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
		func setupTopBar() {
			topBar.layer.masksToBounds = false
			topBar.layer.shadowOffset = CGSize(width: 0, height: 2)
			topBar.layer.shadowRadius = 8;
			topBar.layer.shadowColor = UIColor.black.cgColor
			topBar.layer.shadowOpacity = 0.1;
		}
		func setupHeader() {
			let font = UIFont(name: "SFProText-Regular", size: 16)
			let textFieldAppearance = UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self])
			textFieldAppearance.backgroundColor = UIColor(red: 0, green: 0.11, blue: 0.24, alpha: 0.06)
			textFieldAppearance.font = font
			let labelAppearance = UILabel.appearance(whenContainedInInstancesOf: [UISearchBar.self])
			labelAppearance.textColor = UIColor(red: 0.5, green: 0.55, blue: 0.6, alpha: 1)
			labelAppearance.font = font
			tableView.tableHeaderView = headerView
			headerImageView.image = UIImage(named: "user_default")?.roundedImage
			if let userId = vkService.userId {
				userService.get(userId: userId) { [unowned self] (profiles, error) in
					guard let profile = profiles.first else { return }
					guard let url = profile.photoUrl else { return }
					self.imageService.get(urlString: url, round: true) { [unowned self] image in
						self.headerImageView.image = image
					}
				}
			}
		}
		super.viewDidLoad()
		setupBackground()
		setupTopBar()
		setupHeader()
		setupRefreshControl()
		refreshControl.beginRefreshing()
		getNewsfeed()
	}
	
	@objc private func pulledToRefresh() {
		getNewsfeed()
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
					let presentations = posts.map({ post -> PostPresentation in
						return PostPresentation(with: post)
					})
					DispatchQueue.main.async {
						self.postData = presentations
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
	
	func scrollViewDidScroll(_ scrollView: UIScrollView) {
		UIView.animate(withDuration: 0.25) {
			self.topBar.alpha = scrollView.contentOffset.y > -44 ? 1 : 0
		}
		searchBar.resignFirstResponder()
	}
	
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
		
		let post = postData[indexPath.row]
		cell.author?.text = post.author
		cell.date?.text = post.date
		
		return cell
	}
}

