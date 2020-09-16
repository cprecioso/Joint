//
//  AppDelegate.swift
//  Joint
//
//  Created by Carlos Precioso on 11/09/2020.
//  Copyright © 2020 Carlos Precioso. All rights reserved.
//

import Cocoa
import SwiftUI

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

	var statusItem: NSStatusItem?

	let popover: NSPopover = Popover()

	func applicationDidFinishLaunching(_ aNotification: Notification) {
		let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
		self.statusItem = statusItem
		statusItem.behavior = [.removalAllowed, .terminationOnRemoval]
		if let button = statusItem.button {
			button.image = NSImage(named: "StatusBarIcon-Enabled")
			button.imagePosition = .imageTrailing
			button.action = #selector(self.togglePopover)
		}

		// Create the SwiftUI view that provides the window contents.
		let contentView = MainView()
		popover.contentViewController = NSHostingController(rootView: contentView)
	}

	@objc func togglePopover(_ sender: Any?) {
		if popover.isShown {
			popover.performClose(sender)
		} else {
			if let button = statusItem?.button {
				popover.show(relativeTo: button.bounds, of: button, preferredEdge: NSRectEdge.minY)
			}
		}
	}
}
