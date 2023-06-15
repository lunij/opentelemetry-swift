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

    public init(_ path: String) {
        self.init(url: URL(fileURLWithPath: path, isDirectory: true))
    }

    /// Creates directory on disk.
    @discardableResult
    public func create() throws -> Directory {
        try createDirectory(using: fileManager)
    }

    @discardableResult
    internal func createDirectory(using fileManager: FileManagerProtocol) throws -> Directory {
        do {
            try fileManager.createDirectory(at: url)
        } catch {
            throw DirectoryError.directoryCreationFailed(path: url.path, context: String(describing: error))
        }
        return self
    }

    /// Deletes directory from disk.
    @discardableResult
    public func delete() throws -> Directory {
        try deleteDirectory(using: fileManager)
    }

    @discardableResult
    internal func deleteDirectory(using fileManager: FileManagerProtocol) throws -> Directory {
        do {
            try fileManager.removeItem(at: url)
        } catch {
            throw DirectoryError.directoryDeletionFailed(path: url.path, context: String(describing: error))
        }
        return self
    }

    /// Creates file with given name.
    @discardableResult
    public func createFile(named fileName: String) throws -> File {
        try createFile(named: fileName, using: fileManager)
    }

    @discardableResult
    internal func createFile(named fileName: String, using fileManager: FileManagerProtocol) throws -> File {
        let fileURL = url.appendingPathComponent(fileName, isDirectory: false)
        guard fileManager.createFile(at: fileURL) else {
            throw FileError.fileCreationFailed(path: fileURL.path)
        }
        return File(url: fileURL)
    }

    /// Returns file with given name.
    public func file(named fileName: String) -> File? {
        file(named: fileName, using: fileManager)
    }

    internal func file(named fileName: String, using fileManager: FileManagerProtocol) -> File? {
        let fileURL = url.appendingPathComponent(fileName, isDirectory: false)
        if fileManager.fileExists(at: fileURL) {
            return File(url: fileURL)
        } else {
            return nil
        }
    }

    /// Returns all files of this directory.
    public func files() throws -> [File] {
        try files(using: fileManager)
    }

    internal func files(using fileManager: FileManagerProtocol) throws -> [File] {
        try fileManager
            .contentsOfDirectory(at: url, includingPropertiesForKeys: [.isRegularFileKey, .canonicalPathKey])
            .map { url in File(url: url) }
    }

    /// Appends a given path to the existing path of this directory.
    public func appending(path: String) -> Directory {
        .init(url: url.appendingPathComponent(path, isDirectory: true))
    }

    /// System's directory for storing caches
    public static func cachesDirectory() throws -> Directory {
        try cachesDirectory(using: fileManager)
    }

    internal static func cachesDirectory(using fileManager: FileManagerProtocol) throws -> Directory {
        guard let url = fileManager.urls(for: .cachesDirectory, in: .userDomainMask).first else {
            throw DirectoryError.cachesDirectoryNotFound
        }
        return Directory(url: url)
    }

    /// System's directory for storing temporary files and folders
    public static var temporaryDirectory: Directory {
        temporaryDirectory(using: fileManager)
    }

    internal static func temporaryDirectory(using fileManager: FileManagerProtocol) -> Directory {
        Directory(url: fileManager.temporaryDirectory)
    }
}

public enum DirectoryError: Error, Equatable {
    case cachesDirectoryNotFound
    case directoryCreationFailed(path: String, context: String)
    case directoryDeletionFailed(path: String, context: String)
}
