/*
 * Copyright The OpenTelemetry Authors
 * SPDX-License-Identifier: Apache-2.0
 */

import XCTest
@testable import OpenTelemetryApi

final class DefaultMeterProviderTests: XCTestCase {
    override func setUp() {
        DefaultMeterProvider.reset()
    }

    func testDefault() {
        let defaultMeter = DefaultMeterProvider.instance.get(instrumentationName: "", instrumentationVersion: nil)
        XCTAssert(defaultMeter is ProxyMeter)
        let otherMeter = DefaultMeterProvider.instance.get(instrumentationName: "named meter", instrumentationVersion: nil)
        XCTAssert(otherMeter is ProxyMeter)
        XCTAssert(defaultMeter is ProxyMeter)

        let counter = defaultMeter.createDoubleCounter(name: "ctr")
        XCTAssert(counter.internalCounter is NoopCounterMetric<Double>)
    }

    func testSetDefault() {
        let factory = TestMeter()
        DefaultMeterProvider.setDefault(meterFactory: factory)
        XCTAssert(DefaultMeterProvider.initialized)

        let defaultMeter = DefaultMeterProvider.instance.get(instrumentationName: "", instrumentationVersion: nil)
        XCTAssert(defaultMeter is TestNoopMeter)

        let otherMeter = DefaultMeterProvider.instance.get(instrumentationName: "named meter", instrumentationVersion: nil)
        XCTAssert(otherMeter is TestNoopMeter)

        let counter = defaultMeter.createIntCounter(name: "ctr")
        XCTAssert(counter.internalCounter is NoopCounterMetric<Int>)
    }

    func testSetDefaultTwice() {
        let factory = TestMeter()
        DefaultMeterProvider.setDefault(meterFactory: factory)

        let factory2 = TestMeter()
        DefaultMeterProvider.setDefault(meterFactory: factory2)

        XCTAssert(DefaultMeterProvider.instance === factory)
    }

    func testUpdateDefault_CachedTracer() {
        let defaultMeter = DefaultMeterProvider.instance.get(instrumentationName: "", instrumentationVersion: nil)
        let noOpCounter = defaultMeter.createDoubleCounter(name: "ctr")
        XCTAssert(noOpCounter.internalCounter is NoopCounterMetric<Double>)

        DefaultMeterProvider.setDefault(meterFactory: TestMeter())
        let counter = defaultMeter.createDoubleCounter(name: "ctr")
        XCTAssert(counter.internalCounter is NoopCounterMetric<Double>)
    }
}

class TestMeter: MeterProvider {
    func get(instrumentationName _: String, instrumentationVersion _: String?) -> Meter {
        TestNoopMeter()
    }
}

class TestNoopMeter: Meter {
    func createRawDoubleHistogram(name _: String) -> AnyRawHistogramMetric<Double> {
        AnyRawHistogramMetric<Double>(NoopRawHistogramMetric<Double>())
    }

    func createRawIntHistogram(name _: String) -> AnyRawHistogramMetric<Int> {
        AnyRawHistogramMetric<Int>(NoopRawHistogramMetric<Int>())
    }

    func createRawDoubleCounter(name _: String) -> AnyRawCounterMetric<Double> {
        AnyRawCounterMetric<Double>(NoopRawCounterMetric<Double>())
    }

    func createRawIntCounter(name _: String) -> AnyRawCounterMetric<Int> {
        AnyRawCounterMetric<Int>(NoopRawCounterMetric<Int>())
    }

    func createIntCounter(name _: String, monotonic _: Bool) -> AnyCounterMetric<Int> {
        AnyCounterMetric<Int>(NoopCounterMetric<Int>())
    }

    func createDoubleCounter(name _: String, monotonic _: Bool) -> AnyCounterMetric<Double> {
        AnyCounterMetric<Double>(NoopCounterMetric<Double>())
    }

    func createIntMeasure(name _: String, absolute _: Bool) -> AnyMeasureMetric<Int> {
        AnyMeasureMetric<Int>(NoopMeasureMetric<Int>())
    }

    func createDoubleMeasure(name _: String, absolute _: Bool) -> AnyMeasureMetric<Double> {
        AnyMeasureMetric<Double>(NoopMeasureMetric<Double>())
    }

    func createIntHistogram(name _: String, explicitBoundaries _: [Int]? = nil, absolute _: Bool) -> AnyHistogramMetric<Int> {
        AnyHistogramMetric<Int>(NoopHistogramMetric<Int>())
    }

    func createDoubleHistogram(name _: String, explicitBoundaries _: [Double]? = nil, absolute _: Bool) -> AnyHistogramMetric<Double> {
        AnyHistogramMetric<Double>(NoopHistogramMetric<Double>())
    }

    func createIntObserver(name _: String, absolute _: Bool, callback _: @escaping (IntObserverMetric) -> Void) -> IntObserverMetric {
        NoopIntObserverMetric()
    }

    func createDoubleObserver(name _: String, absolute _: Bool, callback _: @escaping (DoubleObserverMetric) -> Void) -> DoubleObserverMetric {
        NoopDoubleObserverMetric()
    }

    func createIntObservableGauge(name _: String, callback _: @escaping (IntObserverMetric) -> Void) -> IntObserverMetric {
        NoopIntObserverMetric()
    }

    func createDoubleObservableGauge(name _: String, callback _: @escaping (DoubleObserverMetric) -> Void) -> DoubleObserverMetric {
        NoopDoubleObserverMetric()
    }

    func getLabelSet(labels _: [String: String]) -> LabelSet {
        LabelSet.empty
    }
}
