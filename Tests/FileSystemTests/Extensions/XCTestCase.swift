//
// Copyright The OpenTelemetry Authors
// SPDX-License-Identifier: Apache-2.0
//

import XCTest

extension XCTestCase {
    func catchError<E: Error>(_ closure: () throws -> Void) throws -> E? {
        var catchedError: E?
        do {
            try closure()
        } catch let error as E {
            catchedError = error
        }
        return catchedError
    }
}
