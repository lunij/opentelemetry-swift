//
// Copyright The OpenTelemetry Authors
// SPDX-License-Identifier: Apache-2.0
// 

import FileSystem
import Foundation

struct StoragePerformancePresetStub: StoragePerformancePreset {
    let maxFileSize: UInt64
    let maxDirectorySize: UInt64
    let maxFileAgeForWrite: TimeInterval
    let minFileAgeForRead: TimeInterval
    let maxFileAgeForRead: TimeInterval
    let maxObjectsInFile: Int
    let maxObjectSize: UInt64
}

extension StoragePerformancePreset where Self == StoragePerformancePresetStub {
    static var readAllFiles: StoragePerformancePresetStub {
        .init(
            maxFileSize: .max,
            maxDirectorySize: .max,
            maxFileAgeForWrite: 0,
            minFileAgeForRead: -1, // make all files eligible for read
            maxFileAgeForRead: .fakeDistantFuture, // make all files eligible for read
            maxObjectsInFile: .max,
            maxObjectSize: .max
        )
    }

    static var writeEachObjectToNewFileAndReadAllFiles: StoragePerformancePresetStub {
        .init(
            maxFileSize: .max,
            maxDirectorySize: .max,
            maxFileAgeForWrite: 0, // always return new file for writting
            minFileAgeForRead: readAllFiles.minFileAgeForRead,
            maxFileAgeForRead: readAllFiles.maxFileAgeForRead,
            maxObjectsInFile: 1, // write each data to new file
            maxObjectSize: .max
        )
    }

    static var writeAllObjectsToTheSameFile: StoragePerformancePresetStub {
        .init(
            maxFileSize: .max,
            maxDirectorySize: .max,
            maxFileAgeForWrite: .fakeDistantFuture,
            minFileAgeForRead: -1, // make all files eligible for read
            maxFileAgeForRead: .fakeDistantFuture, // make all files eligible for read
            maxObjectsInFile: .max,
            maxObjectSize: .max
        )
    }

    static var lowRuntimeImpact: StoragePerformancePresetStub {
        .init(
            maxFileSize: 4 * 1_024 * 1_024, // 4MB
            maxDirectorySize: 512 * 1_024 * 1_024, // 512 MB
            maxFileAgeForWrite: 4.75,
            minFileAgeForRead: 4.75 + 0.5, // `maxFileAgeForWrite` + 0.5s margin
            maxFileAgeForRead: 18 * 60 * 60, // 18h
            maxObjectsInFile: 500,
            maxObjectSize: 256 * 1_024 // 256KB
        )
    }
}
