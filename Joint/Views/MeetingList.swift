//
//  MeetingList.swift
//  Joint
//
//  Created by Carlos Precioso on 13/09/2020.
//  Copyright © 2020 Carlos Precioso. All rights reserved.
//

import SwiftUI

struct MeetingList: View {
	@State var meetings: [Meeting] = getEntriesFromEvents()
	let timer = Timer.publish(every: 10, on: .main, in: .common)

	var body: some View {
		if meetings.count > 0 {
			return AnyView(
				ForEach(meetings.filter { $0.interval.end > Date() }) { MeetingRow(meeting: $0) }
					.onReceive(timer) { _ in
						self.meetings = getEntriesFromEvents()
					})
		} else {
			return AnyView(EmptyView())
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
