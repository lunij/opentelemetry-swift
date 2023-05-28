/*
 * Copyright The OpenTelemetry Authors
 * SPDX-License-Identifier: Apache-2.0
 */

import Foundation
import OpenTelemetryApi
import OpenTelemetrySdk

class SpanMock: Span {
    var name: String = ""

    var kind: SpanKind {
        .client
    }

    var context = SpanContext.create(traceId: TraceId.random(), spanId: SpanId.random(), traceFlags: TraceFlags(), traceState: TraceState())

    var isRecording: Bool = false

    var status: Status = .unset

    func end() {
        OpenTelemetry.instance.contextProvider.removeContextForSpan(self)
    }

    func end(time _: Date) { end() }

    func updateName(name _: String) {}

    func setAttribute(key _: String, value _: AttributeValue?) {}

    func addEvent(name _: String) {}

    func addEvent(name _: String, attributes _: [String: AttributeValue]) {}

    func addEvent(name _: String, timestamp _: Date) {}

    func addEvent(name _: String, attributes _: [String: AttributeValue], timestamp _: Date) {}

    var description: String = "SpanMock"
}
