//
//  AppDelegate.swift
//  Joint
//
//  Created by Carlos Precioso on 11/09/2020.
//  Copyright © 2020 Carlos Precioso. All rights reserved.
//

import Cocoa
import Combine
import SwiftUI

#if !(DEBUG)
import Sparkle
#endif

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

	var statusItem: NSStatusItem?
	var cancellable: AnyCancellable?

	let popover: NSPopover = Popover()
	let env = Env()

    #if !(DEBUG)
    var updater: SUUpdater!
    #endif
    
	func applicationDidFinishLaunching(_ aNotification: Notification) {
		let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
		self.statusItem = statusItem
		statusItem.behavior = [.removalAllowed, .terminationOnRemoval]
		statusItem.isVisible = true
		if let button = statusItem.button {
			button.image = NSImage(named: "StatusBarIcon-Enabled")
			button.imagePosition = .imageOnly
			button.action = #selector(self.togglePopover)
		}

		// Create the SwiftUI view that provides the window contents.
		let contentView = MainView().environmentObject(self.env)
		popover.contentViewController = NSHostingController(rootView: contentView)
        
        #if !(DEBUG)
        updater = SUUpdater.init(for: Bundle.init(for: Self.self))
        updater.checkForUpdatesInBackground()
        #endif
	}

	override init() {
		super.init()
		self.cancellable = env.$statusBarMessage.sink {
			if let button = self.statusItem?.button {
				button.title = $0
				button.imagePosition = $0.isEmpty ? .imageOnly : .imageTrailing
			}
		}
	}

	deinit {
		self.cancellable?.cancel()
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

class Env: ObservableObject {
	@Published var statusBarMessage: String = ""
}
