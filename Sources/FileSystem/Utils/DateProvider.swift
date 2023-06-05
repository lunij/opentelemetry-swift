/*
 * Copyright The OpenTelemetry Authors
 * SPDX-License-Identifier: Apache-2.0
 */

import Foundation

/// Interface for date provider used for files orchestration.
public protocol DateProvider {
    func currentDate() -> Date
}

public struct SystemDateProvider: DateProvider {
    public init() {}

    @inlinable
    public func currentDate() -> Date { return Date() }
}
