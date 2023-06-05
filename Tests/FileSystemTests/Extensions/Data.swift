//
// Copyright The OpenTelemetry Authors
// SPDX-License-Identifier: Apache-2.0
// 

import Foundation

extension Data {
    var utf8String: String { String(decoding: self, as: UTF8.self) }
}
