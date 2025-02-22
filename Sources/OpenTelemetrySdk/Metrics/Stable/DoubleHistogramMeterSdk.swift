//
// Copyright The OpenTelemetry Authors
// SPDX-License-Identifier: Apache-2.0
// 

import Foundation
import OpenTelemetryApi

public struct DoubleHistogramMeterSdk : DoubleHistogram, Instrument {
    public var instrumentDescriptor: InstrumentDescriptor
    public var storage : WritableMetricStorage

    init(instrumentDescriptor : InstrumentDescriptor, storage: inout WritableMetricStorage) {
        self.instrumentDescriptor = instrumentDescriptor
        self.storage = storage
    }
    
    public mutating func record(value: Double) {
        record(value: value, attributes: [String:AttributeValue]())
    }
    
    public mutating func record(value: Double, attributes: [String : OpenTelemetryApi.AttributeValue]) {
        
    }
        
}
