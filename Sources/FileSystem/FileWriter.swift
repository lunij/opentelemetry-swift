/*
 * Copyright The OpenTelemetry Authors
 * SPDX-License-Identifier: Apache-2.0
 */

import Foundation

public protocol FileWriter {
    func write(data: Data)

    func writeSync(data: Data)

    func flush()
}

public final class OrchestratedFileWriter: FileWriter {
    /// Orchestrator producing reference to writable file.
    private let orchestrator: FilesOrchestrator
    /// Queue used to synchronize files access (read / write) and perform decoding on background thread.
    internal let queue = DispatchQueue(label: "com.otel.filesystem.filewriter", target: .global(qos: .userInteractive))

    public init(orchestrator: FilesOrchestrator) {
        self.orchestrator = orchestrator
    }

    // MARK: - Writing data

    public func write(data: Data) {
        queue.async { [weak self] in
            self?.synchronizedWrite(data: data)
        }
    }

    public func writeSync(data: Data) {
        queue.sync { [weak self] in
            self?.synchronizedWrite(data: data, syncOnEnd: true)
        }
    }

    private func synchronizedWrite(data: Data, syncOnEnd: Bool = false) {
        do {
            let file = try orchestrator.getWritableFile(writeSize: UInt64(data.count))
            try file.append(data: data, synchronized: syncOnEnd)
        } catch {}
    }

    public func flush() {
        queue.sync(flags: .barrier) {}
    }
}
