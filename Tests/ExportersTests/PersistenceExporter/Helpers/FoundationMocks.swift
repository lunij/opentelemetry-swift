/*
 * Copyright The OpenTelemetry Authors
 * SPDX-License-Identifier: Apache-2.0
 */

import Foundation

struct ErrorMock: Error, CustomStringConvertible {
    let description: String

    init(_ description: String = "") {
        self.description = description
    }
}

struct FailingCodableMock: Codable {
    init() {}
    
    init(from decoder: Decoder) throws {
        throw ErrorMock("Failing codable failed to decode")
    }
    
    func encode(to encoder: Encoder) throws {
        throw ErrorMock("Failing codable failed to encode")
    }
}
