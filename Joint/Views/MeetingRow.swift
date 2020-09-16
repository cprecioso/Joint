//
//  MeetingRow.swift
//  Joint
//
//  Created by Carlos Precioso on 13/09/2020.
//  Copyright © 2020 Carlos Precioso. All rights reserved.
//

import SwiftUI

fileprivate enum Status: String {
	case future = "future"
	case present = "present"
	case past = "past"
}

struct MeetingRow: View {
	var meeting: Meeting
	let timer = Timer.publish(every: 10, on: .main, in: .common).autoconnect()

	fileprivate func calcStatus(from currentTime: Date) -> Status {
		let diff = (currentTime.distance(to: self.meeting.interval.start))
		if diff > (5 /* minutes */ * 60 /* seconds */) {
			return .future
		} else if diff > -(5 /* minutes */ * 60 /* seconds */) {
			return .present
		} else {
			return .past
		}
	}

	@State fileprivate var status: Status? = nil

	var body: some View {
		HStack {
			VStack(alignment: .leading) {
				({ () -> Text in
					switch self.status ?? calcStatus(from: Date()) {
					case .future:
						return Text(meeting.title)
							.font(.footnote)
					case .present:
						return Text(meeting.title)
							.font(.headline)
					case .past:
						return Text(meeting.title)
							.font(.footnote).foregroundColor(.gray)
					}
				}()).lineLimit(2)
				Text(self.describeMeeting(meeting)).font(.footnote).foregroundColor(
					.gray)
			}
			Spacer()
			Button(
				"Go",
				action: {
					let _ = self.meeting.open()
				})
		}
		.padding()
		.onReceive(timer) {
			self.status = self.calcStatus(from: $0)
		}
		.background(
			status == .present
				? Rectangle()
					.foregroundColor(.accentColor).opacity(0.3)
				: nil
		)
	}

	func describeMeeting(_ meeting: Meeting) -> String {
		let currentDate = Date()

		if currentDate >= meeting.interval.end {
			return "finished"
		}

		let formatter = RelativeDateTimeFormatter()
		formatter.formattingContext = .standalone
		return formatter.localizedString(for: meeting.interval.start, relativeTo: currentDate)
	}
}

struct MeetingRow_Previews: PreviewProvider {
	static var previews: some View {
		return MeetingRow(
			meeting: Meeting(
				title: "Hola", from: Date(), to: Date(timeIntervalSinceNow: 10),
				url: URL(string: "https://zoom.us/j/123")!)!)
	}
}
