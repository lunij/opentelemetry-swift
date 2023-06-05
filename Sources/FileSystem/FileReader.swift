/*
 * Copyright The OpenTelemetry Authors
 * SPDX-License-Identifier: Apache-2.0
 */

import Foundation

public struct Batch {
    /// Data read from file
    public let data: Data
    /// File from which `data` was read.
    public let file: ReadableFile

    public init(data: Data, file: ReadableFile) {
        self.data = data
        self.file = file
    }
}

public protocol FileReader {
    func readNextBatch() -> Batch?

    func onRemainingBatches(process: (Batch) -> ()) -> Bool

    func markBatchAsRead(_ batch: Batch)
}

public final class OrchestratedFileReader: FileReader {
    /// Orchestrator producing reference to readable file.
    private let orchestrator: FilesOrchestrator

    /// Files marked as read.
    private var filesRead: [ReadableFile] = []

    public init(orchestrator: FilesOrchestrator) {
        self.orchestrator = orchestrator
    }

    // MARK: - Reading batches

    public func readNextBatch() -> Batch? {
        if let file = orchestrator.getReadableFile(excludingFilesNamed: Set(filesRead.map { $0.name })) {
            do {
                let fileData = try file.read()
                return Batch(data: fileData, file: file)
            } catch {
                return nil
            }
        }

        return nil
    }

    /// This method  gets remaining files at once, and process each file after with the block passed.
    /// Currently called from flush method
    public func onRemainingBatches(process: (Batch) -> ()) -> Bool {
        do {
            try orchestrator.getAllFiles(excludingFilesNamed: Set(filesRead.map { $0.name }))?.forEach {
                let fileData = try $0.read()
                process(Batch(data: fileData, file: $0))
            }
        } catch {
            return false
        }
        return true
    }

    // MARK: - Accepting batches

    public func markBatchAsRead(_ batch: Batch) {
        orchestrator.delete(readableFile: batch.file)
        filesRead.append(batch.file)
    }
}
