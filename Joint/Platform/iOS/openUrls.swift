//
//  macOS.swift
//  Joint
//
//  Created by Carlos Precioso on 16/09/2020.
//  Copyright © 2020 Carlos Precioso. All rights reserved.
//

import UIKit

func openUrls(_ urls: [URL], completion: ((Bool) -> Void)? = nil) {
	_openUrls(urls[...], in: UIApplication.shared, completion: completion ?? { _ in })
}

fileprivate func _openUrls(
	_ urls: Array<URL>.SubSequence, in app: UIApplication, completion: @escaping (Bool) -> Void
) {
	if let url = urls.first {
		app.open(url) { opened in
			if opened {
				completion(true)
			} else {
				_openUrls(urls.dropFirst(), in: app, completion: completion)
			}
		}
	} else {
		completion(false)
	}
}
