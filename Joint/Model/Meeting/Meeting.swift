//
//  Meeting.swift
//  Joint
//
//  Created by Carlos Precioso on 12/09/2020.
//  Copyright © 2020 Carlos Precioso. All rights reserved.
//

struct Meeting: Codable, Identifiable {
	init?(title: String, from startDate: Date, to endDate: Date, url: URL) {
		self.title = title
		self.interval = DateInterval(start: startDate, end: endDate)
		guard let providerData = MeetingProviderRegistry.shared.dataFor(url: url) else {
			return nil
		}
		self._providerData = providerData
	}

	var id: String {
		"\(self._providerData.serviceId):\(self._providerData.meetingId):\(interval.description)"
	}

	let title: String
	let interval: DateInterval

	var launchUrls: [URL] {
		self._providerData.launchUrls

	}

	private var _providerData: MeetingProviderData
}

struct MeetingProviderData: Codable {
	let serviceId: String
	let meetingId: String
	let launchUrls: [URL]
}

#if os(macOS)
	import Cocoa

	extension Meeting {
		func open() -> Bool {
			for url in self.launchUrls {
				if NSWorkspace.shared.open(url) {
					return true
				}
			}
			return false
		}
	}
#endif
