//
//  Joint_macOSApp.swift
//  Joint
//
//  Created by Carlos Precioso on 30/09/2020.
//  Copyright © 2020 Carlos Precioso. All rights reserved.
//

import SwiftUI

struct Joint_macOSApp: View {
	let env: Env

	var body: some View {
		MainView()
			.environmentObject(self.env)
	}
}
