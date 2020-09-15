//
//  EventFinder.swift
//  Joint
//
//  Created by Carlos Precioso on 11/09/2020.
//  Copyright © 2020 Carlos Precioso. All rights reserved.
//

import EventKit

func getUrlsFromEvent(_ evt: EKEvent) -> Set<URL> {
	var set = Set<URL>()

	if let url = evt.url {
		set.insert(url)
	}

	if let detector = try? NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue) {

		let input = evt.description
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

func getEntriesFromEvents() -> [Meeting] {
	let store = EKEventStore()

	let pred = store.predicateForEvents(
		withStart: Date(
			timeIntervalSinceNow: -(24 /* hours */ * 60 /* minutes */ * 60 /* seconds */)),
		end: Date(timeIntervalSinceNow: 1_209_600 /* two weeks */),
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
