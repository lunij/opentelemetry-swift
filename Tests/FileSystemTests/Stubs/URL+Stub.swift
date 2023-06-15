//
// Copyright The OpenTelemetry Authors
// SPDX-License-Identifier: Apache-2.0
// 

import Foundation

extension URL {
    static var fakeDirectoryURL: URL {
        URL(fileURLWithPath: "/fake", isDirectory: true)
    }

    static var fakeFileURL: URL {
        URL(fileURLWithPath: "/fake", isDirectory: false)
    }
}
