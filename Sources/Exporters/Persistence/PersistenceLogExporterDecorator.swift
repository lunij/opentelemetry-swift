//
// Copyright The OpenTelemetry Authors
// SPDX-License-Identifier: Apache-2.0
//

import Foundation
import OpenTelemetrySdk

// a persistence exporter decorator for `LogRecords`.
// specialization of `PersistenceExporterDecorator` for `MetricExporter`.
public class PersistenceLogExporterDecorator: LogRecordExporter {
    struct LogRecordDecoratedExporter: DecoratedExporter {
        typealias SignalType = ReadableLogRecord

        private let logRecordExporter: LogRecordExporter

        init(logRecordExporter: LogRecordExporter) {
            self.logRecordExporter = logRecordExporter
        }

        func export(values: [ReadableLogRecord]) -> DataExportStatus {
            let result = logRecordExporter.export(logRecords: values)
            return DataExportStatus(needsRetry: result == .failure)
        }
    }
    private let logRecordExporter: LogRecordExporter
    private let persistenceExporter: PersistenceExporterDecorator<LogRecordDecoratedExporter>

    public init(
        logRecordExporter: LogRecordExporter,
        storageDirectory: URL,
        exportCondition: @escaping () -> Bool = { true },
        performancePreset: PersistencePerformancePreset = .default
    ) {
        self.persistenceExporter = PersistenceExporterDecorator<LogRecordDecoratedExporter>(
            decoratedExporter: LogRecordDecoratedExporter(logRecordExporter: logRecordExporter),
            storageDirectory: storageDirectory,
            exportCondition: exportCondition,
            performancePreset: performancePreset
        )
        self.logRecordExporter = logRecordExporter
    }

    public func export(logRecords: [ReadableLogRecord]) -> ExportResult {
        do {
            try persistenceExporter.export(values: logRecords)
            return .success
        } catch {
            return .failure
        }
    }

    public func shutdown() {
        persistenceExporter.flush()
        logRecordExporter.shutdown()
    }

    public func forceFlush() -> ExportResult {
        persistenceExporter.flush()
        return logRecordExporter.forceFlush()
    }
}
