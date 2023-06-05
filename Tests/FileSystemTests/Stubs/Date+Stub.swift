//
// Copyright The OpenTelemetry Authors
// SPDX-License-Identifier: Apache-2.0
// 

import Foundation

extension Date {
    static func fake() -> Date {
        return Date(timeIntervalSinceReferenceDate: 1)
    }
}
