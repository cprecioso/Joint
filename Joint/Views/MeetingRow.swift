//
//  MeetingRow.swift
//  Joint
//
//  Created by Carlos Precioso on 13/09/2020.
//  Copyright © 2020 Carlos Precioso. All rights reserved.
//

import SwiftUI

extension Text {
	fileprivate func applyStatus(_ status: MeetingStatus?) -> some View {
		switch status {
		case .past: return self.font(.footnote).foregroundColor(.gray)
		case .present: return self.font(.headline)
		default: return self.font(.footnote)
		}
	}
}

struct MeetingRow: View {
	var meeting: Meeting
	static let timer =
		Timer
		.publish(every: 1, on: .main, in: .common)
		.autoconnect()
		.share()

	@State var status: MeetingStatus?
	@State var timeDescription: String?

	var navigationLabel: some View {
		HStack {
			VStack(alignment: .leading) {
				Text(meeting.title)
					.applyStatus(self.status)
					.lineLimit(2)
				Text(timeDescription ?? self.describeMeeting(currentDate: Date()))
					.font(.footnote)
					.foregroundColor(.gray)
			}
			Spacer()
			Button("Join", action: { self.meeting.open() })
		}
	}

	var body: some View {
		Group {
			#if os(iOS)
				NavigationLink(
					destination: EventView(event: self.meeting.event),
					label: { self.navigationLabel }
				)
			#else
				self.navigationLabel
			#endif
		}
		.padding()
		.onReceive(MeetingRow.timer) { date in
			self.status = self.meeting.calcStatus(from: date)
			self.timeDescription = self.describeMeeting(currentDate: date)
		}
		.background(
			status == .present
				? Rectangle()
					.foregroundColor(.accentColor)
					.opacity(0.3)
				: nil
		)
	}

	func describeMeeting(currentDate: Date) -> String {
		if currentDate >= meeting.interval.end {
			return "finished"
		}

		let formatter = RelativeDateTimeFormatter()
		formatter.formattingContext = .standalone
		return formatter.localizedString(for: meeting.interval.start, relativeTo: currentDate)
	}
}
