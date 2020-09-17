//
//  MainView.swift
//  Joint
//
//  Created by Carlos Precioso on 11/09/2020.
//  Copyright © 2020 Carlos Precioso. All rights reserved.
//

import EventKit
import SwiftUI

enum PermissionStatus {
	case unasked,
		rejected,
		allowed
}

struct MainView: View {
	@State var permissionStatus: EKAuthorizationStatus = EKEventStore.authorizationStatus(
		for: .event)

	func refresh() {
		self.permissionStatus = EKEventStore.authorizationStatus(
			for: .event)
	}

	var body: some View {
		ZStack<AnyView>(alignment: .center) {
			switch permissionStatus {
			case .notDetermined: return AnyView(UnaskedView(refresherFn: refresh))

			case .authorized:
				return AnyView(
					ScrollView {
						MeetingList()
					})

			default:
				return AnyView(RejectedView())
			}
		}
		.onAppear(perform: refresh)
		.frame(maxWidth: .infinity, maxHeight: .infinity)
	}
}

struct MainView_Previews: PreviewProvider {
	static var previews: some View {
		return Group {
			MainView()
		}
	}
}
