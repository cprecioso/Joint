//
//  VeertlyMeeting.swift
//  Joint
//
//  Created by Carlos Precioso on 27/09/2020.
//  Copyright © 2020 Carlos Precioso. All rights reserved.
//

import Foundation

func parseVeertlyMeeting(_ url: URL) -> MeetingProviderData? {
	if let params = extractParams(url) {
		let launchUrls = createUrls(params)
		return MeetingProviderData(
			serviceId: "app.veertly.com",
			meetingId: params.meetingName,
			launchUrls: launchUrls)
	}
	return nil
}

fileprivate struct VeertlyParams {
	let meetingName: String
	let meetingUrl: URL
}

fileprivate func extractParams(_ url: URL) -> VeertlyParams? {
	guard
		url.host == "app.veertly.com" && url.pathComponents.count >= 3
			&& url.pathComponents[1] == "v"
	else {
		return nil
	}

	return VeertlyParams(
		meetingName: url.pathComponents[2],
		meetingUrl: url
	)

}

fileprivate func createUrls(_ params: VeertlyParams) -> [URL] {
	return [params.meetingUrl]
}
