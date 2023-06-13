/*
 * Copyright The OpenTelemetry Authors
 * SPDX-License-Identifier: Apache-2.0
 */

import Foundation
import OpenTelemetrySdk

// a persistence exporter decorator for `SpanData`.
// specialization of `PersistenceExporterDecorator` for `SpanExporter`.
public class PersistenceSpanExporterDecorator: SpanExporter {
    struct SpanDecoratedExporter: DecoratedExporter {
        typealias SignalType = SpanData
        
        private let spanExporter: SpanExporter
        
        init(spanExporter: SpanExporter) {
            self.spanExporter = spanExporter
        }

        func export(values: [SpanData]) -> DataExportStatus {
            _ = spanExporter.export(spans: values)
            return DataExportStatus(needsRetry: false)
        }
    }
    
    private let spanExporter: SpanExporter
    private let persistenceExporter: PersistenceExporterDecorator<SpanDecoratedExporter>
    
    public init(
        spanExporter: SpanExporter,
        storageDirectory: URL,
        exportCondition: @escaping () -> Bool = { true },
        performancePreset: PersistencePerformancePreset = .default
    ) throws {
        self.spanExporter = spanExporter
        self.persistenceExporter = PersistenceExporterDecorator<SpanDecoratedExporter>(
            decoratedExporter: SpanDecoratedExporter(spanExporter: spanExporter),
            storageDirectory: storageDirectory,
            exportCondition: exportCondition,
            performancePreset: performancePreset
        )
    }
    
    public func export(spans: [SpanData]) -> SpanExporterResultCode {
        do {
            try persistenceExporter.export(values: spans)
            return .success
        } catch {
            return .failure
        }
    }
    
    public func flush() -> SpanExporterResultCode {
        persistenceExporter.flush()
        return spanExporter.flush()
    }
    
    public func shutdown() {
        persistenceExporter.flush()
        spanExporter.shutdown()
    }
}
