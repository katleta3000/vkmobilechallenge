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
	
	func setup() {
		backgroundColor = .clear
		if containerView == nil {
			let view = UIView(frame: CGRect(x: 8, y: 6, width: bounds.size.width - 16, height: bounds.size.height - 12))
			view.backgroundColor = .white
			view.layer.cornerRadius = 10
			addSubview(view)
			containerView = view
		}
	}
}
