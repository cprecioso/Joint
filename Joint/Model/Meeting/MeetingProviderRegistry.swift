//
//  MeetingProviderRegistry.swift
//  Joint
//
//  Created by Carlos Precioso on 13/09/2020.
//  Copyright © 2020 Carlos Precioso. All rights reserved.
//

import Foundation

class MeetingProviderRegistry {
	static let shared = MeetingProviderRegistry()
	private init() {}

	let parsers = [
		parseZoomMeeting
	]

	func dataFor(url: URL) -> MeetingProviderData? {
		for parser in parsers {
			if let data = parser(url) {
				return data
			}
		}
		return nil
	}
}
