//
// Copyright The OpenTelemetry Authors
// SPDX-License-Identifier: Apache-2.0
//

@testable import FileSystem
import Foundation

final class FileManagerMock: FileManagerProtocol {
    enum Call: Equatable {
        case contents(String)
        case contentsOfDirectory(String, [URLResourceKey]?, FileManager.DirectoryEnumerationOptions)
        case contentsOfDirectoryAtPath(String)
        case createDirectory(String, Bool, Dictionary<FileAttributeKey, Any>.Keys?)
        case createDirectoryAtPath(String, Bool, Dictionary<FileAttributeKey, Any>.Keys?)
        case createFile(String)
        case fileExists(String)
        case moveItem(String, String)
        case removeItem(String)
        case temporaryDirectory
        case urls(FileManager.SearchPathDirectory, FileManager.SearchPathDomainMask)
    }

    var calls: [Call] = []

    var currentDirectoryPath = "fake"

    var temporaryDirectory: URL = .fakeDirectoryURL

    var contentsReturnValue: Data?
    func contents(atPath path: String) -> Data? {
        calls.append(.contents(path))
        return contentsReturnValue
    }

    var contentsOfDirectoryError: Error?
    var contentsOfDirectoryReturnValue: [URL]?
    var contentsOfDirectoryReturnValues: [[URL]] = []
    func contentsOfDirectory(at url: URL, includingPropertiesForKeys keys: [URLResourceKey]?, options mask: FileManager.DirectoryEnumerationOptions) throws -> [URL] {
        calls.append(.contentsOfDirectory(url.path, keys, mask))

        if !contentsOfDirectoryReturnValues.isEmpty {
            return contentsOfDirectoryReturnValues.removeFirst()
        }

        if let value = contentsOfDirectoryReturnValue {
            return value
        }

        throw contentsOfDirectoryError ?? FakeError()
    }

    var contentsOfDirectoryAtPathReturnValue: [String] = []
    func contentsOfDirectory(atPath path: String) throws -> [String] {
        calls.append(.contentsOfDirectoryAtPath(path))
        return contentsOfDirectoryAtPathReturnValue
    }

    var createDirectoryError: Error?
    func createDirectory(at url: URL, withIntermediateDirectories createIntermediates: Bool, attributes: [FileAttributeKey: Any]?) throws {
        calls.append(.createDirectory(url.path, createIntermediates, attributes?.keys))

        if let createDirectoryError {
            throw createDirectoryError
        }
    }

    var createDirectoryAtPathError: Error?
    func createDirectory(atPath path: String, withIntermediateDirectories createIntermediates: Bool, attributes: [FileAttributeKey: Any]?) throws {
        calls.append(.createDirectoryAtPath(path, createIntermediates, attributes?.keys))

        if let createDirectoryAtPathError {
            throw createDirectoryAtPathError
        }
    }

    var createFileReturnValue = false
    func createFile(atPath path: String, contents data: Data?, attributes attr: [FileAttributeKey: Any]?) -> Bool {
        calls.append(.createFile(path))
        return createFileReturnValue
    }

    var fileExistsReturnValue = false
    func fileExists(atPath path: String) -> Bool {
        calls.append(.fileExists(path))
        return fileExistsReturnValue
    }

    var removeItemError: Error?
    func removeItem(at url: URL) throws {
        calls.append(.removeItem(url.path))

        if let removeItemError {
            throw removeItemError
        }
    }

    var urlsReturnValue: [URL] = []
    func urls(for directory: FileManager.SearchPathDirectory, in domainMask: FileManager.SearchPathDomainMask) -> [URL] {
        calls.append(.urls(directory, domainMask))
        return urlsReturnValue
    }
}
