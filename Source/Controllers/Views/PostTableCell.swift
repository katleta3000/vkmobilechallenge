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
	weak var avatar: UIImageView?
	weak var author: UILabel?
	weak var date: UILabel?
	
	func setup() {
		backgroundColor = .clear
		if containerView == nil {
			let view = UIView(frame: CGRect(x: 8, y: 6, width: bounds.size.width - 16, height: bounds.size.height - 12))
			view.backgroundColor = .white
			view.layer.cornerRadius = 10
			addSubview(view)
			containerView = view
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
	}
}
