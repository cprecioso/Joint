//
//  EventView.swift
//  Joint
//
//  Created by Carlos Precioso on 30/09/2020.
//  Copyright © 2020 Carlos Precioso. All rights reserved.
//

import EventKit
import EventKitUI
import SwiftUI

struct EventViewInternal: UIViewControllerRepresentable {
	typealias UIViewControllerType = EKEventViewController

	var event: EKEvent

	func makeUIViewController(context: Context) -> UIViewControllerType {
		let controller = EKEventViewController()
		controller.event = self.event
		controller.allowsCalendarPreview = true
		return controller
	}

	func updateUIViewController(_ controller: UIViewControllerType, context: Context) {
		controller.event = self.event
	}
}

struct EventView: View {
	var event: EKEvent

	var body: some View {
		EventViewInternal(event: self.event)
			.navigationTitle(self.event.title)
	}
}
