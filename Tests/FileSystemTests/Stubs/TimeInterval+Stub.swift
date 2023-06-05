//
// Copyright The OpenTelemetry Authors
// SPDX-License-Identifier: Apache-2.0
// 

import Foundation

extension TimeInterval {
    static func fake() -> Self {
        0
    }

    static var fakeDistantFuture: Self {
        .init(integerLiteral: .max)
    }
}
