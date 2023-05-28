/*
 * Copyright The OpenTelemetry Authors
 * SPDX-License-Identifier: Apache-2.0
 */

import Foundation
@testable import OpenTelemetryApi

class BaggageMock: Baggage {
    static func baggageBuilder() -> BaggageBuilder {
        EmptyBaggageBuilder()
    }

    func getEntries() -> [Entry] {
        [Entry]()
    }

    func getEntryValue(key _: EntryKey) -> EntryValue? {
        nil
    }
}
