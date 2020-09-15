//
//  ZoomMeeting.swift
//  Joint
//
//  Created by Carlos Precioso on 12/09/2020.
//  Copyright © 2020 Carlos Precioso. All rights reserved.
//

import Foundation

func parseZoomMeeting(_ url: URL) -> MeetingProviderData? {
	if let params = extractParams(url) {
		let launchUrls = createUrls(params)
		return MeetingProviderData(
			serviceId: "zoom.us",
			meetingId: params.conferenceId,
			launchUrls: launchUrls)
	}
	return nil
}

fileprivate struct ZoomParams {
	let conferenceId: String,
		conferencePassword: String?
}

fileprivate func extractParams(_ url: URL) -> ZoomParams? {
	if url.host?.hasSuffix("zoom.us") ?? false {
		if url.pathComponents.count >= 3 && url.pathComponents[1] == "j"
			&& !(url.pathComponents[2].isEmpty)
		{
			return ZoomParams(
				conferenceId: url.pathComponents[2],
				conferencePassword: URLComponents(url: url, resolvingAgainstBaseURL: false)?
					.queryItems?.first {
						$0.name == "pwd" && !($0.value?.isEmpty ?? true)
					}?.value
			)
		}
	}

	return nil
}

fileprivate func createUrls(_ params: ZoomParams) -> [URL] {
	return
		([
			"zoommtg://zoom.us/join?confno=\(params.conferenceId)&pwd=\(params.conferencePassword ?? "")",
			"zoomus://zoom.us/join?confno=\(params.conferenceId)&pwd=\(params.conferencePassword ?? "")",
			"https://zoom.us/j/\(params.conferenceId)?pwd=\(params.conferencePassword ?? "")",
		].compactMap { URL(string: $0) })
}
