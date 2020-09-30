//
//  Joint_iOSApp.swift
//  Joint iOS
//
//  Created by Carlos Precioso on 30/09/2020.
//  Copyright © 2020 Carlos Precioso. All rights reserved.
//

import SwiftUI

@main
struct Joint_iOSApp: App {
	@Environment(\.openURL) var openURL: OpenURLAction

	var body: some Scene {
		WindowGroup {
			NavigationView {
				MainView()
					.environmentObject(Env())
					.navigationTitle(Text("Joint"))
			}
			.navigationViewStyle(StackNavigationViewStyle())
        }
	}
    
    
}
