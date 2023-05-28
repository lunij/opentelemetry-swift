/*
 * Copyright The OpenTelemetry Authors
 * SPDX-License-Identifier: Apache-2.0
 */

import CoreMetrics
import Foundation

extension Array where Element == (String, String) {
    var dictionary: [String: String] {
        Dictionary(self, uniquingKeysWith: { lhs, _ in lhs })
    }
}
