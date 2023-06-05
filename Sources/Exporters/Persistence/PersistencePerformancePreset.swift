/*
 * Copyright The OpenTelemetry Authors
 * SPDX-License-Identifier: Apache-2.0
 */

import FileSystem
import Foundation

internal protocol ExportPerformancePreset {
    /// First export delay (in seconds).
    /// It is used as a base value until no more files eligible for export are found - then `defaultExportDelay` is used as a new base.
    var initialExportDelay: TimeInterval { get }
    /// Default exports interval (in seconds).
    /// At runtime, the export interval ranges from `minExportDelay` to `maxExportDelay` depending
    /// on delivery success or failure.
    var defaultExportDelay: TimeInterval { get }
    /// Mininum  interval of data export (in seconds).
    var minExportDelay: TimeInterval { get }
    /// Maximum interval of data export (in seconds).
    var maxExportDelay: TimeInterval { get }
    /// If export succeeds or fails, current interval is changed by this rate. Should be less or equal `1.0`.
    /// E.g: if rate is `0.1` then `delay` can be increased or decreased by `delay * 0.1`.
    var exportDelayChangeRate: Double { get }
}

public struct PersistencePerformancePreset: Equatable, StoragePerformancePreset, ExportPerformancePreset {
    // MARK: - StoragePerformancePreset

    public let maxFileSize: UInt64
    public let maxDirectorySize: UInt64
    public let maxFileAgeForWrite: TimeInterval
    public let minFileAgeForRead: TimeInterval
    public let maxFileAgeForRead: TimeInterval
    public let maxObjectsInFile: Int
    public let maxObjectSize: UInt64
    let synchronousWrite: Bool

    // MARK: - ExportPerformancePreset

    let initialExportDelay: TimeInterval
    let defaultExportDelay: TimeInterval
    let minExportDelay: TimeInterval
    let maxExportDelay: TimeInterval
    let exportDelayChangeRate: Double

    // MARK: - Predefined presets

    /// Default performance preset.
    public static let `default` = lowRuntimeImpact

    /// Performance preset optimized for low runtime impact.
    /// Minimalizes number of data requests send to the server.
    public static let lowRuntimeImpact = PersistencePerformancePreset(
        // persistence
        maxFileSize: 4 * 1_024 * 1_024, // 4MB
        maxDirectorySize: 512 * 1_024 * 1_024, // 512 MB
        maxFileAgeForWrite: 4.75,
        minFileAgeForRead: 4.75 + 0.5, // `maxFileAgeForWrite` + 0.5s margin
        maxFileAgeForRead: 18 * 60 * 60, // 18h
        maxObjectsInFile: 500,
        maxObjectSize: 256 * 1_024, // 256KB
        synchronousWrite: false,

        // export
        initialExportDelay: 5, // postpone to not impact app launch time
        defaultExportDelay: 5,
        minExportDelay: 1,
        maxExportDelay: 20,
        exportDelayChangeRate: 0.1
    )

    /// Performance preset optimized for instant data delivery.
    /// Minimalizes the time between receiving data form the user and delivering it to the server.
    public static let instantDataDelivery = PersistencePerformancePreset(
        // persistence
        maxFileSize: `default`.maxFileSize,
        maxDirectorySize: `default`.maxDirectorySize,
        maxFileAgeForWrite: 2.75,
        minFileAgeForRead: 2.75 + 0.5, // `maxFileAgeForWrite` + 0.5s margin
        maxFileAgeForRead: `default`.maxFileAgeForRead,
        maxObjectsInFile: `default`.maxObjectsInFile,
        maxObjectSize: `default`.maxObjectSize,
        synchronousWrite: true,

        // export
        initialExportDelay: 0.5, // send quick to have a chance for export in short-lived app extensions
        defaultExportDelay: 3,
        minExportDelay: 1,
        maxExportDelay: 5,
        exportDelayChangeRate: 0.5 // reduce significantly for more exports in short-lived app extensions
    )
}
