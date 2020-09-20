//
//  Meeting.swift
//  Joint
//
//  Created by Carlos Precioso on 12/09/2020.
//  Copyright © 2020 Carlos Precioso. All rights reserved.
//

import Foundation

enum MeetingStatus: String {
	case future = "future"
	case present = "present"
	case past = "past"
}

struct Meeting: Codable, Identifiable {
	init?(title: String, from startDate: Date, to endDate: Date, url: URL) {
		self.title = title
		self.interval = DateInterval(start: startDate, end: endDate)
		guard let providerData = providerDataFor(url: url) else {
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

	func calcStatus(from currentTime: Date) -> MeetingStatus {
		let diff = (currentTime.distance(to: self.interval.start))
		if diff > (5 /* minutes */ * 60 /* seconds */) {
			return .future
		} else if diff > -(5 /* minutes */ * 60 /* seconds */) {
			return .present
		} else {
			return .past
		}
	}

	func open(completion: ((Bool) -> Void)? = nil) {
		return openUrls(self.launchUrls, completion: completion)
	}
}

struct MeetingProviderData: Codable {
	let serviceId: String
	let meetingId: String
	let launchUrls: [URL]
}

extension Sequence where Element == Meeting {
	func getCurrent(from currentTime: Date) -> [Meeting] {
		self.filter { $0.calcStatus(from: currentTime) == .present }
	}
}
