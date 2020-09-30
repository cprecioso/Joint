//
//  MeetingList.swift
//  Joint
//
//  Created by Carlos Precioso on 13/09/2020.
//  Copyright © 2020 Carlos Precioso. All rights reserved.
//

import SwiftUI

struct MeetingList: View {
	let meetingPublisher = makeMeetingPublisher().makeConnectable().autoconnect()

	@EnvironmentObject var env: Env

	@State var meetings: [Meeting] = []

	var body: some View {
		Group {
			if self.meetings.count > 0 {
				ForEach(meetings.filter { $0.interval.end > Date() }) {
					MeetingRow(meeting: $0)
				}
			} else {
				Text("No meetings in the next two weeks")
					.padding()
			}
		}
		.onReceive(self.meetingPublisher) { self.meetings = $0 }
		.onReceive(MeetingRow.timer) { date in
			self.env.statusBarMessage = self.meetings.getCurrent(from: date)
				.map { $0.title }
				.joined(separator: " | ")
		}
	}
}

struct MeetingList_Previews: PreviewProvider {
	static var previews: some View {
		let asset = NSDataAsset(name: "entries")!
		let entries = try! JSONDecoder().decode([Meeting].self, from: asset.data)

		return Group {
			MeetingList(meetings: [])
			VStack { MeetingList(meetings: entries) }
		}
	}
}
