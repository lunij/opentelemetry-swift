/*
 * Copyright The OpenTelemetry Authors
 * SPDX-License-Identifier: Apache-2.0
 */

import Foundation
import OpenTelemetryApi

class LoggingTracer: Tracer {
    let tracerName = "LoggingTracer"

    var binaryFormat: BinaryFormattable = LoggingBinaryFormat()
    var textFormat: TextMapPropagator = W3CTraceContextPropagator()

    func spanBuilder(spanName: String) -> SpanBuilder {
        LoggingSpanBuilder(tracer: self, spanName: spanName)
    }

    class LoggingSpanBuilder: SpanBuilder {
        private var tracer: Tracer
        private var isRootSpan: Bool = false
        private var spanContext: SpanContext?
        private var name: String

        init(tracer: Tracer, spanName: String) {
            self.tracer = tracer
            name = spanName
        }

        func startSpan() -> Span {
            LoggingSpan(name: name, kind: .client)
        }

        func setParent(_ parent: Span) -> Self {
            spanContext = parent.context
            return self
        }

        func setParent(_ parent: SpanContext) -> Self {
            spanContext = parent
            return self
        }

        func setNoParent() -> Self {
            isRootSpan = true
            return self
        }

        func addLink(spanContext _: SpanContext) -> Self {
            self
        }

        func addLink(spanContext _: SpanContext, attributes _: [String: AttributeValue]) -> Self {
            self
        }

        func setSpanKind(spanKind _: SpanKind) -> Self {
            self
        }

        func setStartTime(time _: Date) -> Self {
            self
        }

        func setAttribute(key _: String, value _: AttributeValue) -> Self {
            self
        }

        func setActive(_: Bool) -> Self {
            self
        }
    }
}
