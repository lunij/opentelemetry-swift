/*
 * Copyright The OpenTelemetry Authors
 * SPDX-License-Identifier: Apache-2.0
 */

#if !os(watchOS)

import Foundation
import OpenTelemetryApi
import OpenTelemetrySdk
import os

/// A span processor that decorates spans with the origin attribute
@available(macOS 10.14, iOS 12.0, tvOS 12.0, *)
public class SignPostIntegration: SpanProcessor {
    public let isStartRequired = true
    public let isEndRequired = true
    public let osLog = OSLog(subsystem: "OpenTelemetry", category: .pointsOfInterest)

    public init() {}

    public func onStart(parentContext _: SpanContext?, span: ReadableSpan) {
        let signpostID = OSSignpostID(log: osLog, object: self)
        os_signpost(.begin, log: osLog, name: "Span", signpostID: signpostID, "%{public}@", span.name)
    }

    public func onEnd(span _: ReadableSpan) {
        let signpostID = OSSignpostID(log: osLog, object: self)
        os_signpost(.end, log: osLog, name: "Span", signpostID: signpostID)
    }

    public func shutdown() {}
    public func forceFlush(timeout _: TimeInterval? = nil) {}
}

#endif
