/*
 * Copyright The OpenTelemetry Authors
 * SPDX-License-Identifier: Apache-2.0
 */

import Foundation

private let fileManager = FileManager.default

/// An abstraction over file system directory where SDK stores its files.
public struct Directory: Equatable {
    public let url: URL

    public init(url: URL) {
        self.url = url
    }

    @discardableResult
    public func create() throws -> Directory {
        do {
            try fileManager.createDirectory(at: url, withIntermediateDirectories: true, attributes: nil)
        } catch {
            throw DirectoryError.directoryCreationFailed(path: url.path, error: error)
        }
        return self
    }

    @discardableResult
    public func delete() throws -> Directory {
        do {
            try fileManager.removeItem(at: url)
        } catch {
            throw DirectoryError.directoryDeletionFailed(path: url.path, error: error)
        }
        return self
    }

    /// Creates file with given name.
    public func createFile(named fileName: String) throws -> File {
        let fileURL = url.appendingPathComponent(fileName, isDirectory: false)
        guard fileManager.createFile(atPath: fileURL.path, contents: nil, attributes: nil) == true else {
            throw FileError.fileCreationFailed(path: fileURL.path)
        }
        return File(url: fileURL)
    }

    /// Returns file with given name.
    public func file(named fileName: String) -> File? {
        let fileURL = url.appendingPathComponent(fileName, isDirectory: false)
        if fileManager.fileExists(atPath: fileURL.path) {
            return File(url: fileURL)
        } else {
            return nil
        }
    }

    /// Returns all files of this directory.
    public func files() throws -> [File] {
        return try fileManager
            .contentsOfDirectory(at: url, includingPropertiesForKeys: [.isRegularFileKey, .canonicalPathKey])
            .map { url in File(url: url) }
    }

    public func appending(path: String) -> Directory {
        .init(url: url.appendingPathComponent(path, isDirectory: true))
    }

    /// System's directory for storing caches
    public static func cachesDirectory() throws -> Directory {
        guard let url = fileManager.urls(for: .cachesDirectory, in: .userDomainMask).first else {
            throw DirectoryError.cachesDirectoryNotFound
        }
        return Directory(url: url)
    }

    /// System's directory for storing temporary files and folders
    public static var temporaryDirectory: Directory {
        Directory(url: fileManager.temporaryDirectory)
    }
}

public enum DirectoryError: Error {
    case cachesDirectoryNotFound
    case directoryCreationFailed(path: String, error: Error)
    case directoryDeletionFailed(path: String, error: Error)
}
