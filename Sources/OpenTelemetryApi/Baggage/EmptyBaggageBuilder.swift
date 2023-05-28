/*
 * Copyright The OpenTelemetry Authors
 * SPDX-License-Identifier: Apache-2.0
 */

import Foundation

class EmptyBaggageBuilder: BaggageBuilder {
    func setParent(_: Baggage?) -> Self {
        self
    }

    func setNoParent() -> Self {
        self
    }

    func put(key _: EntryKey, value _: EntryValue, metadata _: EntryMetadata?) -> Self {
        self
    }

    func remove(key _: EntryKey) -> Self {
        self
    }

    func build() -> Baggage {
        EmptyBaggage.instance
    }

    init() {}
}
