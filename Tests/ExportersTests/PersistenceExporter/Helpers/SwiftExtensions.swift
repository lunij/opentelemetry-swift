/*
 * Copyright The OpenTelemetry Authors
 * SPDX-License-Identifier: Apache-2.0
 */

import Foundation
import XCTest

/*
 Set of general extensions over standard types for writting more readable tests.
 Extensiosn using Persistence domain objects should be put in `PersistenceExtensions.swift`.
 */

extension TimeZone {
    static var UTC: TimeZone { TimeZone(abbreviation: "UTC")! }
    static var EET: TimeZone { TimeZone(abbreviation: "EET")! }
    static func mockAny() -> TimeZone { .EET }
}

extension String {
    var utf8Data: Data { data(using: .utf8)! }
}

extension Data {
    var utf8String: String { String(decoding: self, as: UTF8.self) }
}
