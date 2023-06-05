/*
 * Copyright The OpenTelemetry Authors
 * SPDX-License-Identifier: Apache-2.0
 */

import Foundation

public enum FileSystemError: Error {
    case createFileError(path: URL)
    case createDirectoryError(path: URL, error: Error)
    case obtainCacheLibraryError
    case dataExceedsMaxSizeError(dataSize: UInt64, maxSize: UInt64)
}
