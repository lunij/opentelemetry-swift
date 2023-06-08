/*
 * Copyright The OpenTelemetry Authors
 * SPDX-License-Identifier: Apache-2.0
 */

@testable import DatadogExporter
import FileSystem
import Foundation
import XCTest

/// Creates `Directory` pointing to unique subfolder in `/var/folders/`.
/// Does not create the subfolder - it must be later created with `.create()`.
func obtainUniqueTemporaryDirectory() -> Directory {
    let subdirectoryName = "com.datadoghq.ios-sdk-tests-\(UUID().uuidString)"
    let osTemporaryDirectoryURL = URL(fileURLWithPath: NSTemporaryDirectory(), isDirectory: true).appendingPathComponent(subdirectoryName, isDirectory: true)
    print("💡 Obtained temporary directory URL: \(osTemporaryDirectoryURL)")
    return Directory(url: osTemporaryDirectoryURL)
}
