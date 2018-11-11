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
	private weak var textContentLabel: UILabel?
	private weak var limitView: UIView?
	weak var avatar: UIImageView?
	weak var author: UILabel?
	weak var date: UILabel?
	weak var likes: UILabel?
	weak var comments: UILabel?
	weak var reposts: UILabel?
	weak var showFull: UIButton?
	// TODO синхронизовать константы с PostPresentation – это же так легко, вынести их в отдельную структуру и проще будет и без magic numbers
	let topOffsetToText: CGFloat = 58
	let bottomViewHeight: CGFloat = 48
	let limitHeight: CGFloat = 28
	
	func setup() {
		backgroundColor = .clear
		if containerView == nil {
			let view = UIView(frame: CGRect(x: 8, y: 6, width: bounds.size.width - 16, height: bounds.size.height - 12))
			view.backgroundColor = .white
			view.layer.cornerRadius = 10
			view.clipsToBounds = true
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
		if textContentLabel == nil {
			let label = UILabel(frame: CGRect(x: 12, y: 58, width: containerView!.bounds.size.width - 24, height: 20))
			// а здесь я словил удивительный баг – если раскомментировать строчку ниже, то у таблицы будет периодически отрисовываться сепаратор
			// label.backgroundColor = .white
			label.textColor = UIColor(red: 0.17, green: 0.18, blue: 0.19, alpha: 1)
			label.font = UIFont(name: "SFProText-Regular", size: 15)
			label.numberOfLines = 0
			containerView!.addSubview(label)
			textContentLabel = label
		}
		if limitView == nil {
			let view = UIView(frame: CGRect(x: 12, y: 0, width: containerView!.bounds.size.width - 24, height: limitHeight))
			view.backgroundColor = .white
			containerView!.addSubview(view)
			limitView = view
		}
		if bottomView == nil {
			let view = UIView(frame: CGRect(x: 0, y: containerView!.bounds.size.height - bottomViewHeight, width: containerView!.bounds.size.width, height: bottomViewHeight))
			view.backgroundColor = .white
			view.layer.cornerRadius = 10
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
		if showFull == nil {
			let view = UIButton(frame: CGRect())
			view.backgroundColor = .clear
			view.setTitle("Показать полностью", for: .normal)
			view.titleLabel?.font = UIFont(name: "SFProText-Medium", size: 14)
			// TODO спросить цвет – в Figma его нет, использую пипетку, на белом фоне эффект будет тот же
			view.setTitleColor(UIColor(red: 85/255, green: 140/255, blue: 202/255, alpha: 1), for: .normal)
			view.titleLabel?.textAlignment = .left
			view.sizeToFit()
			containerView!.addSubview(view)
			showFull = view
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
	
	func updateContent(text: NSAttributedString?, textHeight: CGFloat, totalHeight: CGFloat, photosHeight: CGFloat, limited: Bool) {
		
		limitView?.alpha = limited ? 1 : 0
		showFull?.alpha = limited ? 1 : 0

		if var frame = containerView?.frame {
			frame.size.height = totalHeight - 12
			containerView?.frame = frame
		}
		
		if var frame = textContentLabel?.frame {
			frame.size.height = textHeight
			textContentLabel?.frame = frame
		}
		
		if var frame = limitView?.frame, let containerHeight = containerView?.bounds.size.height {
			frame.origin.y = containerHeight - bottomViewHeight - limitHeight - photosHeight
			limitView?.frame = frame
		}
		
		if var buttonFrame = showFull?.frame, let limitFrame = limitView?.frame {
			let newHeight: CGFloat = 32
			buttonFrame.origin.x = 12
			buttonFrame.size.height = newHeight
			buttonFrame.origin.y = limitFrame.origin.y - (newHeight - limitFrame.size.height) / 2
			showFull?.frame = buttonFrame
		}
		
		if var frame = bottomView?.frame, let containerHeight = containerView?.bounds.size.height {
			frame.origin.y = containerHeight - bottomViewHeight
			bottomView?.frame = frame
		}
		textContentLabel?.attributedText = text
	}
}
