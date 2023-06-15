//
// Copyright The OpenTelemetry Authors
// SPDX-License-Identifier: Apache-2.0
//

import Foundation

protocol FileManagerProtocol {
    var temporaryDirectory: URL { get }

    func contentsOfDirectory(at url: URL, includingPropertiesForKeys keys: [URLResourceKey]?, options mask: FileManager.DirectoryEnumerationOptions) throws -> [URL]
    func createDirectory(at url: URL, withIntermediateDirectories createIntermediates: Bool, attributes: [FileAttributeKey: Any]?) throws
    func createFile(atPath path: String, contents data: Data?, attributes attr: [FileAttributeKey: Any]?) -> Bool
    func fileExists(atPath path: String) -> Bool
    func removeItem(at URL: URL) throws
    func urls(for directory: FileManager.SearchPathDirectory, in domainMask: FileManager.SearchPathDomainMask) -> [URL]
}

extension FileManagerProtocol {
    func contentsOfDirectory(at url: URL, includingPropertiesForKeys keys: [URLResourceKey]? = nil, options: FileManager.DirectoryEnumerationOptions = []) throws -> [URL] {
        try contentsOfDirectory(at: url, includingPropertiesForKeys: keys, options: options)
    }

    func createDirectory(at url: URL, withIntermediateDirectories createIntermediates: Bool = true) throws {
        try createDirectory(at: url, withIntermediateDirectories: createIntermediates, attributes: nil)
    }

    func createFile(atPath path: String, contents: Data? = nil, attributes: [FileAttributeKey: Any]? = nil) -> Bool {
        createFile(atPath: path, contents: contents, attributes: attributes)
    }

    func createFile(at url: URL, contents: Data? = nil, attributes: [FileAttributeKey: Any]? = nil) -> Bool {
        createFile(atPath: url.path, contents: contents, attributes: attributes)
    }

    func fileExists(at url: URL) -> Bool {
        fileExists(atPath: url.path)
    }
}

extension FileManager: FileManagerProtocol {}
