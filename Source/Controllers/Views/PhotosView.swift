//
//  PhotosView.swift
//  VKChallenge
//
//  Created by Evgenii Rtishchev on 11/11/2018.
//  Copyright © 2018 Evgenii Rtishchev. All rights reserved.
//

import UIKit

final class MyImageView: UIImageView {
	deinit {
		print("dealloc")
	}
}

final class PhotosView: UIView {
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		backgroundColor = .red
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	// Вот и полетел от нехватки времени MVC, сервис прям во View прилетел :(. Хотя бы DI
	func update(photos: [Photo], imageService: ImageService) {
		for view in subviews {
			view.removeFromSuperview()
		}
		if photos.count == 1, let photo = photos.first, let url = photo.url {
			let imageView = MyImageView(frame: bounds)
			imageService.get(urlString: url) { image in
				imageView.image = image
			}
			imageView.backgroundColor = UIColor(red: 235/255, green: 237/255, blue: 240/255, alpha: 1)
			imageView.contentMode = .scaleAspectFill
			imageView.clipsToBounds = true
			addSubview(imageView)
		}
	}
}
