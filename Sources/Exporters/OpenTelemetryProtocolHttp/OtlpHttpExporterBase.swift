//
// Copyright The OpenTelemetry Authors
// SPDX-License-Identifier: Apache-2.0
//

import Foundation
import OpenTelemetryProtocolExporterCommon
import SwiftProtobuf

public class OtlpHttpExporterBase {
    let endpoint: URL
    let httpClient: HTTPClient

    public init(endpoint: URL, useSession: URLSession? = nil) {
        self.endpoint = endpoint
        if let providedSession = useSession {
            httpClient = HTTPClient(session: providedSession)
        } else {
            httpClient = HTTPClient()
        }
    }

    public func createRequest(body: Message, endpoint: URL) -> URLRequest {
        var request = URLRequest(url: endpoint)

        do {
            request.httpMethod = "POST"
            request.httpBody = try body.serializedData()
            request.setValue(Headers.getUserAgentHeader(), forHTTPHeaderField: Constants.HTTP.userAgent)
            request.setValue("application/x-protobuf", forHTTPHeaderField: "Content-Type")
        } catch {
            print("Error serializing body: \(error)")
        }

        return request
    }

    public func shutdown() {}
}
