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
//		print("dealloc")
	}
}

final class PhotosView: UIView {
	private let barHeight: CGFloat = 39
	private weak var pageControl: UIPageControl?
	private var previousPhotos = [Photo]()
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		backgroundColor = .white
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	// Вот и полетел от нехватки времени MVC, сервис прям во View прилетел :(. Хотя бы DI
	func update(photos: [Photo], imageService: ImageService) {
		// Небольшая оптимизация
		if previousPhotos.count == photos.count, photos.count == 1 {
			if previousPhotos[0].url == photos[0].url {
				return
			}
		} else if previousPhotos.count == photos.count, photos.count > 0 {
			var hasChanges = false
			for i in 0..<photos.count {
				if previousPhotos[i].url != photos[i].url {
					hasChanges = true
					break
				}
			}
			if !hasChanges {
				return
			}
		}
		
		previousPhotos = photos
		
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
			
		} else if photos.count > 1 {
			
			let scrollView = UIScrollView(frame: CGRect(x: 12, y: 0, width: bounds.size.width - 20, height: bounds.size.height - barHeight))
			scrollView.isPagingEnabled = true
			scrollView.clipsToBounds = false
			scrollView.showsHorizontalScrollIndicator = false
			scrollView.delegate = self
			
			let pageControl = UIPageControl()
			pageControl.numberOfPages = photos.count
			pageControl.currentPage = 0
			
			let color = UIColor(red: 0.32, green: 0.51, blue: 0.72, alpha: 1)
			pageControl.tintColor = color
			pageControl.pageIndicatorTintColor = color.withAlphaComponent(0.32)
			pageControl.currentPageIndicatorTintColor = color
			addSubview(pageControl)
			pageControl.center = CGPoint(x: center.x, y: bounds.size.height - (barHeight / 2))
			self.pageControl = pageControl
			
			let photoWidth = scrollView.bounds.size.width
			for (index, photo) in photos.enumerated() {

				let imageView = MyImageView(frame: CGRect(x: CGFloat(index) * photoWidth, y: 0, width: photoWidth - 4, height: bounds.size.height - barHeight))
				if let url = photo.url {
					imageService.get(urlString: url) { image in
						imageView.image = image
					}
				}
				imageView.backgroundColor = UIColor(red: 235/255, green: 237/255, blue: 240/255, alpha: 1)
				imageView.clipsToBounds = true
				imageView.contentMode = .scaleAspectFill
				scrollView.addSubview(imageView)
			}
			scrollView.contentSize = CGSize(width: photoWidth * CGFloat(photos.count), height: scrollView.bounds.size.height)
			addSubview(scrollView)
			
			let dividerView = UIView(frame: CGRect(x: 12, y: bounds.size.height - 1, width: bounds.size.width - 24, height: 0.5))
			dividerView.backgroundColor = UIColor(red: 0.84, green: 0.85, blue: 0.85, alpha: 1)
			addSubview(dividerView)
		}
	}
}

// MARK: - UIScrollViewDelegate

extension PhotosView: UIScrollViewDelegate {
	
	func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
		let pageNumber = round(scrollView.contentOffset.x / scrollView.frame.size.width)
		pageControl?.currentPage = Int(pageNumber)
	}
}
