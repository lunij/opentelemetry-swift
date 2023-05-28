/*
 * Copyright The OpenTelemetry Authors
 * SPDX-License-Identifier: Apache-2.0
 */

import Foundation
import OpenTelemetryApi

/// Interface for getting the current time.
public protocol Clock: AnyObject {
    /// Obtains the current time for this clock.
    var now: Date { get }
}

public extension Clock {
    var nanoTime: UInt64 { now.timeIntervalSince1970.toNanoseconds }
}

public func == (lhs: Clock, rhs: Clock) -> Bool {
    lhs.now == rhs.now
}
