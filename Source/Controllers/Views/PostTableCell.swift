//
//  PostTableCell.swift
//  VKChallenge
//
//  Created by Evgenii Rtishchev on 10/11/2018.
//  Copyright © 2018 Evgenii Rtishchev. All rights reserved.
//

import UIKit

final class PostTableCell: UITableViewCell {
	private weak var containerView: UIView?
	private weak var bottomView: UIView?
	private weak var viewsImage: UIImageView?
	private weak var views: UILabel?
	weak var avatar: UIImageView?
	weak var author: UILabel?
	weak var date: UILabel?
	weak var likes: UILabel?
	weak var comments: UILabel?
	weak var reposts: UILabel?
	
	func setup() {
		backgroundColor = .clear
		if containerView == nil {
			let view = UIView(frame: CGRect(x: 8, y: 6, width: bounds.size.width - 16, height: bounds.size.height - 12))
			view.backgroundColor = .white
			view.layer.cornerRadius = 10
			addSubview(view)
			containerView = view
		}
		if bottomView == nil {
			let view = UIView(frame: CGRect(x: 0, y: containerView!.bounds.size.height - 48, width: containerView!.bounds.size.width, height: 48))
			view.backgroundColor = .clear
			containerView!.addSubview(view)
			bottomView = view
			
			let likesImage = UIImageView(frame: CGRect(x: 16, y: 14, width: 24, height: 24))
			bottomView!.addSubview(likesImage)
			likesImage.image = UIImage(named: "likes_icon")
			
			let commentsImage = UIImageView(frame: CGRect(x: 100, y: 14, width: 24, height: 24))
			bottomView!.addSubview(commentsImage)
			commentsImage.image = UIImage(named: "comments_icon")
			
			let repostsImage = UIImageView(frame: CGRect(x: 184, y: 14, width: 24, height: 24))
			bottomView!.addSubview(repostsImage)
			repostsImage.image = UIImage(named: "reposts_icon")
			
			let viewsImage = UIImageView(frame: CGRect(x: 184, y: 16, width: 20, height: 20))
			bottomView!.addSubview(viewsImage)
			viewsImage.image = UIImage(named: "views_icon")
			viewsImage.isHidden = true
			self.viewsImage = viewsImage
		}
		if avatar == nil {
			let view = UIImageView(frame: CGRect(x: 12, y: 12, width: 36, height: 36))
			view.backgroundColor = .white
			containerView!.addSubview(view)
			avatar = view
		}
		if author == nil {
			let view = UILabel(frame: CGRect(x: 58, y: 14, width: containerView!.bounds.size.width - 70, height: 17))
			view.backgroundColor = .white
			view.textColor = UIColor(red: 0.17, green: 0.18, blue: 0.18, alpha: 1)
			view.font = UIFont(name: "SFProText-Medium", size: 14)
			containerView!.addSubview(view)
			author = view
		}
		if date == nil {
			let view = UILabel(frame: CGRect(x: 58, y: 35, width: containerView!.bounds.size.width - 70, height: 15))
			view.backgroundColor = .white
			view.textColor = UIColor(red: 0.5, green: 0.55, blue: 0.6, alpha: 1)
			view.font = UIFont(name: "SFProText-Regular", size: 12)
			containerView!.addSubview(view)
			date = view
		}
		if likes == nil {
			let view = UILabel(frame: CGRect(x: 44, y: 18, width: 55, height: 17))
			view.backgroundColor = .white
			view.textColor = UIColor(red: 0.5, green: 0.55, blue: 0.6, alpha: 1)
			view.font = UIFont(name: "SFProText-Medium", size: 14)
			bottomView!.addSubview(view)
			likes = view
		}
		if comments == nil {
			let view = UILabel(frame: CGRect(x: 128, y: 18, width: 55, height: 17))
			view.backgroundColor = .white
			view.textColor = UIColor(red: 0.5, green: 0.55, blue: 0.6, alpha: 1)
			view.font = UIFont(name: "SFProText-Medium", size: 14)
			bottomView!.addSubview(view)
			comments = view
		}
		if reposts == nil {
			let view = UILabel(frame: CGRect(x: 212, y: 18, width: 55, height: 17))
			view.backgroundColor = .clear
			view.textColor = UIColor(red: 0.5, green: 0.55, blue: 0.6, alpha: 1)
			view.font = UIFont(name: "SFProText-Medium", size: 14)
			bottomView!.addSubview(view)
			reposts = view
		}
		if views == nil {
			let view = UILabel(frame: CGRect(x: 212, y: 18, width: 0, height: 0))
			view.backgroundColor = .white
			view.textColor = UIColor(red: 0.66, green: 0.68, blue: 0.7, alpha: 1)
			view.font = UIFont(name: "SFProText-Regular", size: 14)
			bottomView!.addSubview(view)
			views = view
		}
	}
	
	func updateViewsIcon(countString: String) {
		guard let views = views, let bottomView = bottomView, let viewsImage = viewsImage else { return }
	
		views.text = countString
		views.sizeToFit()
		views.frame = CGRect(x: bottomView.bounds.size.width - 16 - views.bounds.size.width, y: 18, width: views.bounds.size.width, height: 17)
		
		var frame = viewsImage.frame
		frame.origin.x = views.frame.origin.x - frame.size.width - 2
		viewsImage.frame = frame
		viewsImage.isHidden = false
	}
}
