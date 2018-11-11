//
//  ViewController.swift
//  VKChallenge
//
//  Created by Evgenii Rtishchev on 09/11/2018.
//  Copyright © 2018 Evgenii Rtishchev. All rights reserved.
//

import UIKit

final class NewsViewController: UIViewController {
	
	// DI
	let vkService = ServiceLocator.shared.vkService
	let newsfeedService = ServiceLocator.shared.newsfeedService
	let userService = ServiceLocator.shared.userService
	let imageService = ServiceLocator.shared.imageService
	
	// Interface
	private let refreshControl = UIRefreshControl()
	@IBOutlet private weak var tableView: UITableView!
	@IBOutlet private weak var topBar: UIView!
	@IBOutlet private weak var topBarHeight: NSLayoutConstraint!
	@IBOutlet private weak var headerView: UIView!
	@IBOutlet private weak var searchBar: UISearchBar!
	@IBOutlet private weak var headerImageView: UIImageView!
	@IBOutlet private weak var footerView: UIView!
	@IBOutlet private weak var footerLoader: UIActivityIndicatorView!
	@IBOutlet private weak var footerLabel: UILabel!
	
	// Data & models
	private var postData = [PostPresentation]()
	private var nextFrom: String?
	private var loadingMore: Bool = false
	
	// MARK: - life cycle
	
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
		
		func setupTopBar() {
			topBar.layer.masksToBounds = false
			topBar.layer.shadowOffset = CGSize(width: 0, height: 2)
			topBar.layer.shadowRadius = 8;
			topBar.layer.shadowColor = UIColor.black.cgColor
			topBar.layer.shadowOpacity = 0.1;
			topBarHeight.constant = UIApplication.shared.statusBarFrame.size.height
			topBar.setNeedsLayout()
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
			headerImageView.image = UIImage(named: "user_default")
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
		
		func setupFooter() {
			tableView.tableFooterView = footerView
			footerLabel.font = UIFont(name: "SFProText-Regular", size: 13)
			footerLabel.textColor = UIColor(red: 0.56, green: 0.58, blue: 0.6, alpha: 1)
		}
		
		func setupTableForSmoothScroll() {
			tableView.estimatedRowHeight = 0;
			tableView.estimatedSectionHeaderHeight = 0;
			tableView.estimatedSectionFooterHeight = 0;
		}
		
		super.viewDidLoad()
		setupBackground()
		setupTopBar()
		setupHeader()
		setupFooter()
		setupTableForSmoothScroll()
		setupRefreshControl()
		refreshControl.beginRefreshing()
		getNewsfeed()
	}
}

// MARK: actions and logic

extension NewsViewController {
	
	@objc private func pulledToRefresh() {
		getNewsfeed()
	}
	
	private func stopRefreshing() {
		if self.refreshControl.isRefreshing {
			self.refreshControl.endRefreshing()
		}
	}
	
	private func getNewsfeed(from: String? = nil) {
		newsfeedService.get(from: from) { [unowned self] (posts, nextFrom, wasLoadingMore, error) in
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
						if wasLoadingMore {
							self.postData.append(contentsOf: presentations)
						} else {
							self.postData = presentations
						}
						self.tableView.reloadData()
						self.loadingMore = false
						self.footerLoader.stopAnimating()
						self.stopRefreshing()
						self.footerLabel.isHidden = false
						self.footerLabel.text = FooterPresentation.text(for: presentations.count)
						self.nextFrom = nextFrom
					}
				}
			}
		}
	}
	
	@objc func clickedShowFull(sender: UIButton) {
		postData[sender.tag].isCompact = false
		let post = postData[sender.tag]
		let indexPath = IndexPath(row: sender.tag, section: 0)
		if let cell = tableView.cellForRow(at: indexPath) as? PostTableCell {
			tableView.beginUpdates()
			cell.updateContent(text: post.text, textHeight: post.textHeight, totalHeight: post.totalHeight, limited: post.isCompact)
			tableView.endUpdates()
		}
	}
}

// MARK: table view delegates & data source

extension NewsViewController: UITableViewDelegate, UITableViewDataSource {
	
	func scrollViewDidScroll(_ scrollView: UIScrollView) {
		UIView.animate(withDuration: 0.25) {
			self.topBar.alpha = scrollView.contentOffset.y > 0 ? 1 : 0
		}
		searchBar.resignFirstResponder()
		let currentOffset = scrollView.contentOffset.y
		let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height
		let deltaOffset = maximumOffset - currentOffset
		let additionalOffset = -(UIApplication.shared.statusBarFrame.height)
		if deltaOffset < additionalOffset && !loadingMore && nextFrom != nil && postData.count > 0 {
			loadingMore = true
			footerLabel.isHidden = true
			footerLoader.startAnimating()
			getNewsfeed(from: nextFrom)
		}
	}
	
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		let post = postData[indexPath.row]
		return post.isCompact ? post.compactHeight() : post.totalHeight
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
		cell.avatar?.image = UIImage(named: "user_default")
		if let url = post.imageUrl {
			imageService.get(urlString: url, round: true) { image in
				cell.avatar?.image = image
			}
		}
		cell.likes?.text = post.likes
		cell.comments?.text = post.comments
		cell.reposts?.text = post.reposts
		cell.updateViewsIcon(countString: post.views)
		cell.updateContent(text: post.text, textHeight: post.textHeight, totalHeight: post.isCompact ? post.compactHeight() : post.totalHeight, limited: post.isCompact)
		cell.showFull?.tag = indexPath.row
		cell.showFull?.addTarget(self, action: #selector(clickedShowFull), for: .touchUpInside)
		
		return cell
	}
}

