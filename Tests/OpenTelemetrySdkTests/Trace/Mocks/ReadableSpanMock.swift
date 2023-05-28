/*
 * Copyright The OpenTelemetry Authors
 * SPDX-License-Identifier: Apache-2.0
 */

import Foundation
import OpenTelemetryApi
@testable import OpenTelemetrySdk

class ReadableSpanMock: ReadableSpan {
    var hasEnded: Bool = false
    var latency: TimeInterval = 0

    var kind: SpanKind {
        .client
    }

    var instrumentationScopeInfo = InstrumentationScopeInfo()

    var name: String = "ReadableSpanMock"

    var forcedReturnSpanContext: SpanContext?
    var forcedReturnSpanData: SpanData?

    func end() {
        OpenTelemetry.instance.contextProvider.removeContextForSpan(self)
    }

    func end(time _: Date) { end() }

    func toSpanData() -> SpanData {
        forcedReturnSpanData ?? SpanData(traceId: context.traceId,
                                         spanId: context.spanId,
                                         traceFlags: context.traceFlags,
                                         traceState: TraceState(),
                                         resource: Resource(attributes: [String: AttributeValue]()),
                                         instrumentationScope: InstrumentationScopeInfo(),
                                         name: "ReadableSpanMock",
                                         kind: .client,
                                         startTime: Date(timeIntervalSinceReferenceDate: 0),
                                         endTime: Date(timeIntervalSinceReferenceDate: 0),
                                         hasRemoteParent: false)
    }

    var context: SpanContext {
        forcedReturnSpanContext ?? SpanContext.create(traceId: TraceId.random(), spanId: SpanId.random(), traceFlags: TraceFlags(), traceState: TraceState())
    }

    var isRecording: Bool = false

    var status: Status = .unset

    func updateName(name _: String) {}

    func setAttribute(key _: String, value _: AttributeValue?) {}

    func addEvent(name _: String) {}

    func addEvent(name _: String, attributes _: [String: AttributeValue]) {}

    func addEvent(name _: String, timestamp _: Date) {}

    func addEvent(name _: String, attributes _: [String: AttributeValue], timestamp _: Date) {}

    var description: String = "ReadableSpanMock"
}
