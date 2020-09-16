//
//  MeetingFinder.swift
//  Joint
//
//  Created by Carlos Precioso on 11/09/2020.
//  Copyright © 2020 Carlos Precioso. All rights reserved.
//

import Combine
import EventKit

fileprivate func getUrlsFromEvent(_ evt: EKEvent) -> Set<URL> {
	var set = Set<URL>()

	if let url = evt.url {
		set.insert(url)
	}

	if let input = evt.notes,
		let detector = try? NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)
	{
		let matches = detector.matches(in: input, options: [], range: NSMakeRange(0, input.count))

		for match in matches {
			guard let range = Range(match.range, in: input) else { continue }
			let urlStr = input[range]
			guard let url = URL(string: String(urlStr)) else { continue }
			set.insert(url)
		}
	}

	return set
}

let eventStore = EKEventStore()

func fetchMeetings(from store: EKEventStore) -> [Meeting] {
	let pred = store.predicateForEvents(
		withStart: Date(
			timeIntervalSinceNow: -86400 /* 24 hours ago */),
		end: Date(timeIntervalSinceNow: 1_209_600 /* 2 weeks in the future */),
		calendars: nil)

	let events = store.events(matching: pred)

	var entries: [Meeting] = []

	for event in events {
		for url in getUrlsFromEvent(event) {
			if let meeting = Meeting(
				title: event.title, from: event.startDate, to: event.endDate, url: url)
			{
				entries.append(meeting)
			}
		}
	}

	return entries
}

func makeMeetingPublisher() -> AnyPublisher<[Meeting], Never> {
	return Just(eventStore)
		.flatMap(maxPublishers: .max(1)) { store in
			NotificationCenter.default.publisher(for: .EKEventStoreChanged, object: store)
				.map { _ in store }
				.prepend(store)
		}
		.map { store in fetchMeetings(from: store) }
		.eraseToAnyPublisher()
}
