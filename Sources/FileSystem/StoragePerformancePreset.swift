/*
 * Copyright The OpenTelemetry Authors
 * SPDX-License-Identifier: Apache-2.0
 */

import Foundation

public protocol StoragePerformancePreset {
    /// Maximum size of a single file (in bytes).
    /// Each feature (logging, tracing, ...) serializes its objects data to that file for later export.
    /// If last written file is too big to append next data, new file is created.
    var maxFileSize: UInt64 { get }
    /// Maximum size of data directory (in bytes).
    /// Each feature uses separate directory.
    /// If this size is exceeded, the oldest files are deleted until this limit is met again.
    var maxDirectorySize: UInt64 { get }
    /// Maximum age qualifying given file for reuse (in seconds).
    /// If recently used file is younger than this, it is reused - otherwise: new file is created.
    var maxFileAgeForWrite: TimeInterval { get }
    /// Minimum age qualifying given file for export (in seconds).
    /// If the file is older than this, it is exported (and then deleted if export succeeded).
    /// It has an arbitrary offset  (~0.5s) over `maxFileAgeForWrite` to ensure that no export can start for the file being currently written.
    var minFileAgeForRead: TimeInterval { get }
    /// Maximum age qualifying given file for export (in seconds).
    /// Files older than this are considered obsolete and get deleted without exporting.
    var maxFileAgeForRead: TimeInterval { get }
    /// Maximum number of serialized objects written to a single file.
    /// If number of objects in recently used file reaches this limit, new file is created for new data.
    var maxObjectsInFile: Int { get }
    /// Maximum size of serialized object data (in bytes).
    /// If serialized object data exceeds this limit, it is skipped (not written to file and not exported).
    var maxObjectSize: UInt64 { get }
}
