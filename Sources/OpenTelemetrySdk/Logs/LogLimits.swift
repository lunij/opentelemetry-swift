//
// Copyright The OpenTelemetry Authors
// SPDX-License-Identifier: Apache-2.0
//

import Foundation

public struct LogLimits {
    public static let defaultMaxAttributeCount = 128
    public static let defaultMaxAtributeLength = Int.max
    public let maxAttributeCount: Int
    public let maxAttributeLength: Int

    public init(maxAttributeCount: Int = Self.defaultMaxAttributeCount, maxAttributeLength: Int = Self.defaultMaxAtributeLength) {
        self.maxAttributeCount = maxAttributeCount
        self.maxAttributeLength = maxAttributeLength
    }
}
