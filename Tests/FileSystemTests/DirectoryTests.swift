/*
 * Copyright The OpenTelemetry Authors
 * SPDX-License-Identifier: Apache-2.0
 */

import FileSystem
import XCTest

class DirectoryTests: XCTestCase {
    private let uniqueSubdirectoryName = UUID().uuidString
    private let fileManager = FileManager.default

    // MARK: - Directory creation

    func testCreatesDirectory_whenSinglePathComponent() throws {
        let directory = try Directory.temporaryDirectory.appending(path: uniqueSubdirectoryName).create()

        XCTAssertTrue(fileManager.fileExists(atPath: directory.url.path))

        try directory.delete()
    }

    func testCreatesDirectory_whenMultiplePathComponents() throws {
        let path = uniqueSubdirectoryName + "/subdirectory/another-subdirectory"
        let directory = try Directory.temporaryDirectory.appending(path: path).create()

        XCTAssertTrue(fileManager.fileExists(atPath: directory.url.path))

        try directory.delete()
    }

    // MARK: - File creation

    func testCreatesFile() throws {
        let path = uniqueSubdirectoryName + "/subdirectory/another-subdirectory"
        let directory = try Directory.temporaryDirectory.appending(path: path).create()

        let file = try directory.createFile(named: "abcd")

        XCTAssertEqual(file.url, directory.url.appendingPathComponent("abcd"))
        XCTAssertTrue(fileManager.fileExists(atPath: file.url.path))

        try directory.delete()
    }

    func testRetrievesFile() throws {
        let directory = try Directory.temporaryDirectory.appending(path: uniqueSubdirectoryName).create()
        _ = try directory.createFile(named: "abcd")

        let file = directory.file(named: "abcd")
        XCTAssertEqual(file?.url, directory.url.appendingPathComponent("abcd"))
        XCTAssertTrue(fileManager.fileExists(atPath: file!.url.path))

        try directory.delete()
    }

    func testRetrievesAllFiles() throws {
        let directory = try Directory.temporaryDirectory.appending(path: uniqueSubdirectoryName).create()
        _ = try directory.createFile(named: "f1")
        _ = try directory.createFile(named: "f2")
        _ = try directory.createFile(named: "f3")

        let files = try directory.files()
        XCTAssertEqual(files.count, 3)
        files.forEach { file in XCTAssertTrue(file.url.relativePath.contains(directory.url.relativePath)) }
        files.forEach { file in XCTAssertTrue(fileManager.fileExists(atPath: file.url.path)) }

        try directory.delete()
    }
}
