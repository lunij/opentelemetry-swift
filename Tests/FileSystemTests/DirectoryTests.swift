/*
 * Copyright The OpenTelemetry Authors
 * SPDX-License-Identifier: Apache-2.0
 */

@testable import FileSystem
import XCTest

final class DirectoryTests: XCTestCase {
    private var mockFileManager: FileManagerMock!

    override func setUp() {
        super.setUp()
        mockFileManager = .init()
    }

    func test_initializesDirectoryWithURL() throws {
        let directory = Directory(url: .fakeDirectoryURL)

        XCTAssertEqual(directory.url, .fakeDirectoryURL)
    }

    func test_initializesDirectoryWithString() throws {
        let directory = Directory("/fake")

        XCTAssertEqual(directory.url, .fakeDirectoryURL)
    }

    func test_initializesCachesDirectory() throws {
        mockFileManager.urlsReturnValue = [
            .fakeDirectoryURL.appendingPathComponent("caches", isDirectory: true),
            .fakeDirectoryURL.appendingPathComponent("another-directory", isDirectory: true)
        ]

        let directory = try Directory.cachesDirectory(using: mockFileManager)

        XCTAssertEqual(directory.url.path, "/fake/caches")
        XCTAssertEqual(mockFileManager.calls, [.urls(.cachesDirectory, .userDomainMask)])
    }

    func test_failesInitializingCachesDirectory() throws {
        mockFileManager.urlsReturnValue = []

        let error: DirectoryError? = try catchError {
            _ = try Directory.cachesDirectory(using: mockFileManager)
        }

        XCTAssertEqual(error, .cachesDirectoryNotFound)
        XCTAssertEqual(mockFileManager.calls, [.urls(.cachesDirectory, .userDomainMask)])
    }

    func test_createsDirectory() throws {
        try Directory("/fake1/fake2").createDirectory(using: mockFileManager)

        XCTAssertEqual(mockFileManager.calls, [.createDirectory("/fake1/fake2", true, nil)])
    }

    func test_failsCreatingDirectory() throws {
        mockFileManager.createDirectoryError = FakeError()
        let directory = Directory("/fake1/fake2")

        let error: DirectoryError? = try catchError {
            try directory.createDirectory(using: mockFileManager)
        }

        XCTAssertEqual(error, .directoryCreationFailed(path: "/fake1/fake2", context: "FakeError()"))
        XCTAssertEqual(mockFileManager.calls, [.createDirectory("/fake1/fake2", true, nil)])
    }

    func test_deletesDirectory() throws {
        try Directory("/fake1/fake2").deleteDirectory(using: mockFileManager)

        XCTAssertEqual(mockFileManager.calls, [.removeItem("/fake1/fake2")])
    }

    func test_failsDeletingDirectory() throws {
        mockFileManager.removeItemError = FakeError()
        let directory = Directory("/fake1/fake2")

        let error: DirectoryError? = try catchError {
            try directory.deleteDirectory(using: mockFileManager)
        }

        XCTAssertEqual(error, .directoryDeletionFailed(path: "/fake1/fake2", context: "FakeError()"))
        XCTAssertEqual(mockFileManager.calls, [.removeItem("/fake1/fake2")])
    }

    func test_appendsPath() {
        let directory = Directory("/fake1")

        XCTAssertEqual(directory.appending(path: "fake2").url.path, "/fake1/fake2")
        XCTAssertEqual(directory.appending(path: "fake2/fake3").url.path, "/fake1/fake2/fake3")
        XCTAssertEqual(directory.appending(path: "/fake2").url.path, "/fake1//fake2") // no smartness expected (yet)
    }

    // MARK: - File handling

    func test_createsFile() throws {
        mockFileManager.createFileReturnValue = true
        let directory = Directory("/fake1/fake2")

        let file = try directory.createFile(named: "abcd", using: mockFileManager)

        XCTAssertEqual(file.name, "abcd")
        XCTAssertEqual(mockFileManager.calls, [
            .createFile("/fake1/fake2/abcd")
        ])
    }

    func test_failsCreatingFile() throws {
        mockFileManager.createFileReturnValue = false
        let directory = Directory("/fake1/fake2")

        let error: FileError? = try catchError {
            try directory.createFile(named: "abcd", using: mockFileManager)
        }

        XCTAssertEqual(error, .fileCreationFailed(path: "/fake1/fake2/abcd"))
        XCTAssertEqual(mockFileManager.calls, [
            .createFile("/fake1/fake2/abcd")
        ])
    }

    func test_initializesFileObject_whenFileExists() throws {
        mockFileManager.fileExistsReturnValue = true
        let directory = Directory("/fake1/fake2")

        let file = directory.file(named: "abcd", using: mockFileManager)

        XCTAssertEqual(file?.name, "abcd")
    }

    func test_initializesNoFileObject_whenFileDoesNotExist() throws {
        mockFileManager.fileExistsReturnValue = false
        let directory = Directory("/fake1/fake2")

        let file = directory.file(named: "abcd", using: mockFileManager)

        XCTAssertNil(file)
        XCTAssertEqual(mockFileManager.calls, [.fileExists("/fake1/fake2/abcd")])
    }

    func test_initializesAllFileObjects() throws {
        mockFileManager.contentsOfDirectoryReturnValue = [
            .fakeFileURL, .fakeFileURL, .fakeFileURL
        ]
        let directory = Directory("/fake1/fake2")

        let files = try directory.files(using: mockFileManager)

        XCTAssertEqual(files, [File(url: .fakeFileURL), File(url: .fakeFileURL), File(url: .fakeFileURL)])
        XCTAssertEqual(mockFileManager.calls, [.contentsOfDirectory("/fake1/fake2", [.isRegularFileKey, .canonicalPathKey], [])])
    }
}

final class DirectoryIntegrationTests: XCTestCase {
    private let uniqueSubdirectoryName = UUID().uuidString
    private let fileManager = FileManager.default

    func test_createsDirectory_whenSinglePathComponent() throws {
        let directory = try Directory.temporaryDirectory.appending(path: uniqueSubdirectoryName).create()

        XCTAssertTrue(fileManager.fileExists(atPath: directory.url.path))

        try directory.delete()
    }

    func test_createsDirectory_whenMultiplePathComponents() throws {
        let path = uniqueSubdirectoryName + "/subdirectory/another-subdirectory"
        let directory = try Directory.temporaryDirectory.appending(path: path).create()

        XCTAssertTrue(fileManager.fileExists(atPath: directory.url.path))

        try directory.delete()
    }

    func test_createsDirectory_whenFileURL() throws {
        let url = fileManager.temporaryDirectory.appendingPathComponent("FakeFile.swift", isDirectory: false)
        let directory = try Directory(url: url).create()

        XCTAssertTrue(fileManager.fileExists(atPath: directory.url.path))

        try directory.delete()
    }

    // MARK: - File handling

    func test_createsFile() throws {
        let path = uniqueSubdirectoryName + "/subdirectory/another-subdirectory"
        let directory = try Directory.temporaryDirectory.appending(path: path).create()

        let file = try directory.createFile(named: "abcd")

        XCTAssertEqual(file.url, directory.url.appendingPathComponent("abcd"))
        XCTAssertTrue(fileManager.fileExists(atPath: file.url.path))

        try directory.delete()
    }

    func test_initializesFileObject() throws {
        let directory = try Directory.temporaryDirectory.appending(path: uniqueSubdirectoryName).create()
        _ = try directory.createFile(named: "abcd")

        let file = directory.file(named: "abcd")
        XCTAssertEqual(file?.url, directory.url.appendingPathComponent("abcd"))
        XCTAssertTrue(fileManager.fileExists(atPath: file!.url.path))

        try directory.delete()
    }

    func test_initializesAllFileObjects() throws {
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
