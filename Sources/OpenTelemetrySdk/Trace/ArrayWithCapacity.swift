/*
 * Copyright The OpenTelemetry Authors
 * SPDX-License-Identifier: Apache-2.0
 */

import Foundation

/// An array-like struct that has a maximum capacity,
/// when it reaces a maximum it discards first inserted elements
public struct ArrayWithCapacity<T> {
    private(set) var array = [T]()
    public let capacity: Int

    public init(capacity: Int) {
        self.capacity = capacity
    }

    public mutating func append(_ item: T) {
        array.append(item)
        if array.count > capacity {
            _ = array.removeFirst()
        }
    }
}

extension ArrayWithCapacity: MutableCollection {
    public var startIndex: Int { array.startIndex }
    public var endIndex: Int { array.endIndex }

    public subscript(_ index: Int) -> T {
        get { array[index] }
        set { array[index] = newValue }
    }

    public func index(after index: Int) -> Int {
        array.index(after: index)
    }
}
