/*
 * Copyright The OpenTelemetry Authors
 * SPDX-License-Identifier: Apache-2.0
 */

import Foundation
import OpenTelemetryApi

internal class HistogramMetricSdk<T: SignedNumeric & Comparable>: HistogramMetric {
    public private(set) var boundInstruments = [LabelSet: BoundHistogramMetricSdkBase<T>]()
    let metricName: String
    let explicitBoundaries: [T]?

    init(name: String, explicitBoundaries: [T]? = nil) {
        metricName = name
        self.explicitBoundaries = explicitBoundaries
    }

    func bind(labelset: LabelSet) -> BoundHistogramMetric<T> {
        var boundInstrument = boundInstruments[labelset]
        if boundInstrument == nil {
            boundInstrument = createMetric()
            boundInstruments[labelset] = boundInstrument!
        }
        return boundInstrument!
    }

    func bind(labels: [String: String]) -> BoundHistogramMetric<T> {
        bind(labelset: LabelSet(labels: labels))
    }

    func createMetric() -> BoundHistogramMetricSdkBase<T> {
        BoundHistogramMetricSdk<T>(explicitBoundaries: explicitBoundaries)
    }
}
