//
//  JitsiMeeting.swift
//  Joint
//
//  Created by Carlos Precioso on 16/09/2020.
//  Copyright © 2020 Carlos Precioso. All rights reserved.
//

import Foundation

func parseJitsiMeeting(_ url: URL) -> MeetingProviderData? {
	if let params = extractParams(url) {
		let launchUrls = createUrls(params)
		return MeetingProviderData(
			serviceId: "meet.jit.si",
			meetingId: params.meetingName,
			launchUrls: launchUrls)
	}
	return nil
}

fileprivate struct JitsiParams {
	let meetingName: String
}

fileprivate func extractParams(_ url: URL) -> JitsiParams? {
	guard
		url.host == "meet.jit.si" && url.pathComponents.count >= 2
			&& !(url.pathComponents[1].isEmpty)
	else {
		return nil
	}

	return JitsiParams(
		meetingName: url.pathComponents[1]
	)

}

fileprivate func createUrls(_ params: JitsiParams) -> [URL] {
	return
		([
			"org.jitsi.meet://meet.jit.si/\(params.meetingName)",
			"https://meet.jit.si/\(params.meetingName)",
		].compactMap { URL(string: $0) })
}
