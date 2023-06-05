//
// Copyright The OpenTelemetry Authors
// SPDX-License-Identifier: Apache-2.0
// 

import Foundation

extension String {
    var utf8Data: Data { data(using: .utf8)! }
}
