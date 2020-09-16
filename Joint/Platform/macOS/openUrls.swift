//
//  macOS.swift
//  Joint
//
//  Created by Carlos Precioso on 16/09/2020.
//  Copyright © 2020 Carlos Precioso. All rights reserved.
//

import AppKit
import Foundation

func openUrls(_ urls: [URL], completion: ((Bool) -> Void)? = nil) {
	_openUrls(urls[...], in: NSWorkspace.shared, completion: completion ?? { _ in })
}

fileprivate let config: NSWorkspace.OpenConfiguration = {
	let config = NSWorkspace.OpenConfiguration()
	config.promptsUserIfNeeded = false
	return config
}()

fileprivate func _openUrls(
	_ urls: Array<URL>.SubSequence, in workspace: NSWorkspace, completion: @escaping (Bool) -> Void
) {
	if let url = urls.first {
		workspace.open(url, configuration: config) { _, err in
			if err == nil {
				completion(true)
			} else {
				_openUrls(urls.dropFirst(), in: workspace, completion: completion)
			}
		}
	} else {
		completion(false)
	}
}
