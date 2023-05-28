/*
 * Copyright The OpenTelemetry Authors
 * SPDX-License-Identifier: Apache-2.0
 */

import Foundation
import OpenTelemetryApi
@testable import OpenTelemetrySdk

struct TestUtils {
    static func dateFromNanos(_ nanos: UInt64) -> Date {
        Date(timeIntervalSince1970: Double(nanos) / 1_000_000_000)
    }

    static func generateRandomAttributes() -> [String: AttributeValue] {
        var result = [String: AttributeValue]()
        let name = UUID().uuidString
        let attribute = AttributeValue.string(UUID().uuidString)
        result[name] = attribute
        return result
    }

    static func makeBasicSpan() -> SpanData {
        SpanData(traceId: TraceId(),
                 spanId: SpanId(),
                 traceFlags: TraceFlags(),
                 traceState: TraceState(),
                 resource: Resource(),
                 instrumentationScope: InstrumentationScopeInfo(),
                 name: "spanName",
                 kind: .server,
                 startTime: Date(timeIntervalSince1970: 100_000_000_000 + 100),
                 endTime: Date(timeIntervalSince1970: 200_000_000_000 + 200),
                 hasRemoteParent: false,
                 hasEnded: true)
    }

    static func createSpanWithSampler(tracerSdkFactory: TracerProviderSdk, tracer: Tracer, spanName: String, sampler: Sampler) -> SpanBuilder {
        createSpanWithSampler(tracerSdkFactory: tracerSdkFactory, tracer: tracer, spanName: spanName, sampler: sampler, attributes: [String: AttributeValue]())
    }

    static func createSpanWithSampler(tracerSdkFactory: TracerProviderSdk, tracer: Tracer, spanName: String, sampler: Sampler, attributes: [String: AttributeValue]) -> SpanBuilder {
        tracerSdkFactory.sharedState.setSampler(sampler)
        let builder = tracer.spanBuilder(spanName: spanName)
        for attribute in attributes {
            builder.setAttribute(key: attribute.key, value: attribute.value)
        }
        return builder
    }
}
