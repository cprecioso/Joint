//
//  Provider.swift
//  Joint
//
//  Created by Carlos Precioso on 16/09/2020.
//  Copyright © 2020 Carlos Precioso. All rights reserved.
//

import Foundation

fileprivate let providers: [(URL) -> MeetingProviderData?] = [
	parseZoomMeeting,
	parseJitsiMeeting,
	parseVeertlyMeeting,
]

func providerDataFor(url: URL) -> MeetingProviderData? {
	for parser in providers {
		if let data = parser(url) {
			return data
		}
	}
	return nil
}
