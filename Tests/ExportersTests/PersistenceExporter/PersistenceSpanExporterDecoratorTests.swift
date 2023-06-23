/*
 * Copyright The OpenTelemetry Authors
 * SPDX-License-Identifier: Apache-2.0
 */

import FileSystemTestKit
import OpenTelemetryApi
import OpenTelemetrySdk
@testable import PersistenceExporter
import XCTest

class PersistenceSpanExporterDecoratorTests: XCTestCase {
    private let temporaryDirectory = obtainUniqueTemporaryDirectory()

    class SpanExporterMock: SpanExporter {
        let onExport: ([SpanData]) -> SpanExporterResultCode
        let onFlush: () -> SpanExporterResultCode
        let onShutdown: () -> Void
        
        init(onExport: @escaping ([SpanData]) -> SpanExporterResultCode,
             onFlush: @escaping () -> SpanExporterResultCode = { .success },
             onShutdown: @escaping () -> Void = {})
        {
            self.onExport = onExport
            self.onFlush = onFlush
            self.onShutdown = onShutdown
        }

        @discardableResult func export(spans: [SpanData]) -> SpanExporterResultCode {
            return onExport(spans)
        }
        
        func flush() -> SpanExporterResultCode {
            return onFlush()
        }
                
        func shutdown() {
            onShutdown()
        }
    }
    
    override func setUpWithError() throws {
        super.setUp()
        try temporaryDirectory.create()
    }

    override func tearDownWithError() throws {
        try temporaryDirectory.delete()
        super.tearDown()
    }
    
    func testWhenExportMetricIsCalled_thenSpansAreExported() throws {
        let spansExportExpectation = self.expectation(description: "spans exported")
        let exporterShutdownExpectation = self.expectation(description: "exporter shut down")
        
        let mockSpanExporter = SpanExporterMock(onExport: { spans in
            spans.forEach { span in
                if span.name == "SimpleSpan",
                   span.events.count == 1,
                   span.events.first!.name == "My event"
                {
                    spansExportExpectation.fulfill()
                }
            }
            
            return .success
        }, onShutdown: {
            exporterShutdownExpectation.fulfill()
        })
                
        let persistenceSpanExporter = try PersistenceSpanExporterDecorator(
            spanExporter: mockSpanExporter,
            storageDirectory: temporaryDirectory.url,
            exportCondition: { true },
            performancePreset: PersistencePerformancePreset.mockWith(
                storagePerformance: StoragePerformanceMock.writeEachObjectToNewFileAndReadAllFiles,
                synchronousWrite: true,
                exportPerformance: ExportPerformanceMock.veryQuick
            )
        )

        let instrumentationScopeName = "SimpleExporter"
        let instrumentationScopeVersion = "semver:0.1.0"
        let tracerProviderSDK = TracerProviderSdk()
        OpenTelemetry.registerTracerProvider(tracerProvider: tracerProviderSDK)
        let tracer = tracerProviderSDK.get(instrumentationName: instrumentationScopeName, instrumentationVersion: instrumentationScopeVersion) as! TracerSdk
        
        let spanProcessor = SimpleSpanProcessor(spanExporter: persistenceSpanExporter)
        tracerProviderSDK.addSpanProcessor(spanProcessor)

        simpleSpan(tracer: tracer)
        spanProcessor.shutdown()
        
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    private func simpleSpan(tracer: TracerSdk) {
        let span = tracer.spanBuilder(spanName: "SimpleSpan").setSpanKind(spanKind: .client).startSpan()
        span.addEvent(name: "My event", timestamp: Date())
        span.end()
    }
}
