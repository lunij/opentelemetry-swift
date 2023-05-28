/*
 * Copyright The OpenTelemetry Authors
 * SPDX-License-Identifier: Apache-2.0
 */

import OpenTelemetryApi
import XCTest
@testable import OpenTelemetrySdk

class TracerSdkTests: XCTestCase {
    let spanName = "span_name"
    let instrumentationScopeName = "TracerSdkTest"
    let instrumentationScopeVersion = "semver:0.2.0"
    var instrumentationScopeInfo: InstrumentationScopeInfo!
    var span = SpanMock()
    var spanProcessor = SpanProcessorMock()
    var tracerSdkFactory = TracerProviderSdk()
    var tracer: TracerSdk!

    override func setUp() {
        instrumentationScopeInfo = InstrumentationScopeInfo(name: instrumentationScopeName, version: instrumentationScopeVersion)
        tracer = (tracerSdkFactory.get(instrumentationName: instrumentationScopeName, instrumentationVersion: instrumentationScopeVersion) as! TracerSdk)
    }

    func testDefaultGetCurrentSpan() {
        XCTAssertNil(OpenTelemetry.instance.contextProvider.activeSpan)
    }

    func testDefaultSpanBuilder() {
        XCTAssertTrue(tracer.spanBuilder(spanName: spanName) is SpanBuilderSdk)
    }

    func testGetCurrentSpan() {
        XCTAssertNil(OpenTelemetry.instance.contextProvider.activeSpan)
        // Make sure context is detached even if test fails.
        // TODO: Check context bahaviour
//        let origContext = ContextUtils.withSpan(span)
//        XCTAssertTrue(tracer.currentSpan === span)
//        XCTAssertTrue(tracer.currentSpan is PropagatedSpan)
    }

    func testGetCurrentSpan_WithSpan() {
        XCTAssertNil(OpenTelemetry.instance.contextProvider.activeSpan)
        OpenTelemetry.instance.contextProvider.setActiveSpan(span)
        XCTAssertTrue(OpenTelemetry.instance.contextProvider.activeSpan === span)
        span.end()
        XCTAssertNil(OpenTelemetry.instance.contextProvider.activeSpan)
    }

    func testGetInstrumentationScopeInfo() {
        XCTAssertEqual(tracer.instrumentationScopeInfo, instrumentationScopeInfo)
    }

    func testPropagatesInstrumentationScopeInfoToSpan() {
        let readableSpan = tracer.spanBuilder(spanName: "spanName").startSpan() as? ReadableSpan
        XCTAssertEqual(readableSpan?.instrumentationScopeInfo, instrumentationScopeInfo)
    }
}
