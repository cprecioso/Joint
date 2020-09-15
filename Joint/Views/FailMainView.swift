//
//  FailMainView.swift
//  Joint
//
//  Created by Carlos Precioso on 13/09/2020.
//  Copyright © 2020 Carlos Precioso. All rights reserved.
//

import EventKit
import SwiftUI

struct RejectedView: View {
	var body: some View {
		VStack {
			Text("We can't access your calendar").font(.callout)
			Text("Please allow access to Calendar data in the System Preferences.")
			Button("Open System Preferences") {
				NSWorkspace.shared.open(
					URL(
						string:
							"x-apple.systempreferences:com.apple.preference.security?Privacy_Calendars"
					)!)
			}
			Text("Once you've allowed access, please restart the app.")
		}.padding()
			.multilineTextAlignment(.center)
	}
}

struct UnaskedView: View {
	var refresherFn: (() -> Void)? = nil

	var body: some View {
		VStack {
			Text("We need access to your calendar").font(.callout)
			Text("We will scan upcoming events and show you any online meetings here.")
			Button("Allow Calendar access") {
				EKEventStore().requestAccess(to: .event) { _, _ in
					if let fn = self.refresherFn {
						fn()
					}
				}
			}
			Text(
				"This app doesn't connect to the internet, and it doesn't store your calendar data anywhere."
			)
		}.padding()
			.multilineTextAlignment(.center)
	}
}

struct EmptyView: View {
	var body: some View {
		VStack {
			Text("Free as a bird").font(.callout)
			Text("We can't find any meetings with videoconference links for the next two weeks.")
				.foregroundColor(Color.gray)
		}.padding()
			.multilineTextAlignment(.center)
	}
}

struct FailMainView_Previews: PreviewProvider {
	static var previews: some View {
		Group {
			RejectedView()
			UnaskedView()
			EmptyView()
		}
	}
}
