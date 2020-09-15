//
//  Popover.swift
//  Joint
//
//  Created by Carlos Precioso on 13/09/2020.
//  Copyright © 2020 Carlos Precioso. All rights reserved.
//

import Cocoa

class Popover: NSPopover, NSPopoverDelegate {
	override init() {
		super.init()
		self.behavior = .transient
		self.delegate = self
	}

	required init?(coder: NSCoder) {
		super.init(coder: coder)
	}

	func popoverShouldDetach(_ popover: NSPopover) -> Bool {
		return true
	}

	func popoverDidDetach(_ popover: NSPopover) {
		self.behavior = .applicationDefined
	}

	func popoverDidClose(_ notification: Notification) {
		self.behavior = .transient
	}
}
