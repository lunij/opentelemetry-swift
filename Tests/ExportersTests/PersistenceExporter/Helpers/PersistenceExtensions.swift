/*
 * Copyright The OpenTelemetry Authors
 * SPDX-License-Identifier: Apache-2.0
 */

@testable import PersistenceExporter
import FileSystem
import Foundation

/*
 Set of Persistence domain extensions over standard types for writting more readable tests.
 Domain agnostic extensions should be put in `SwiftExtensions.swift`.
 */

extension File {
    func makeReadonly() throws {
        try FileManager.default.setAttributes([.immutable: true], ofItemAtPath: url.path)
    }

    func makeReadWrite() throws {
        try FileManager.default.setAttributes([.immutable: false], ofItemAtPath: url.path)
    }
}
