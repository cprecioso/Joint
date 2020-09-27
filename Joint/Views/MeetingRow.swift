//
//  MeetingRow.swift
//  Joint
//
//  Created by Carlos Precioso on 13/09/2020.
//  Copyright © 2020 Carlos Precioso. All rights reserved.
//

import SwiftUI

struct MeetingRow: View {
	var meeting: Meeting
	static let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect().share()

	@State var status: MeetingStatus?
	@State var timeDescription: String?

	var body: some View {
		HStack {
			VStack(alignment: .leading) {
				Group {
					switch self.status {
					case .past:
						Text(meeting.title)
							.font(.footnote)
							.foregroundColor(.gray)
					case .present:
						Text(meeting.title)
							.font(.headline)
					default:
						Text(meeting.title)
							.font(.footnote)
					}
				}
				.lineLimit(2)
				Text(timeDescription ?? self.describeMeeting(currentDate: Date()))
					.font(.footnote)
					.foregroundColor(.gray)
			}
			Spacer()
			Button(
				"Go",
				action: {
					let _ = self.meeting.open()
				})
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

struct MeetingRow_Previews: PreviewProvider {
	static var previews: some View {
		return MeetingRow(
			meeting: Meeting(
				title: "Hola", from: Date(), to: Date(timeIntervalSinceNow: 10),
				url: URL(string: "https://zoom.us/j/123")!)!)
	}
}
