/*
 * Copyright The OpenTelemetry Authors
 * SPDX-License-Identifier: Apache-2.0
 */

import FileSystemTestKit
import OpenTelemetryApi
import OpenTelemetrySdk
@testable import PersistenceExporter
import XCTest

class PersistenceMetricExporterDecoratorTests: XCTestCase {
    private let temporaryDirectory = obtainUniqueTemporaryDirectory()

    class MetricExporterMock: MetricExporter {
        
        let onExport: ([Metric]) -> MetricExporterResultCode
        init(onExport: @escaping ([Metric]) -> MetricExporterResultCode) {
            self.onExport = onExport
        }
        
        func export(metrics: [Metric], shouldCancel: (() -> Bool)?) -> MetricExporterResultCode {
            return onExport(metrics)
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
    
    func testWhenExportMetricIsCalled_thenMetricsAreExported() {        
        let metricsExportExpectation = self.expectation(description: "metrics exported")
        
        let mockMetricExporter = MetricExporterMock(onExport: { metrics in
            metrics.forEach { metric in
                if metric.name == "MyCounter" &&
                    metric.namespace == "MyMeter" &&
                    metric.data.count == 1 {
                    
                    if let metricData = metric.data[0] as? SumData<Int>,
                       metricData.sum == 100,
                       metricData.labels ==  ["labelKey": "labelValue"]
                    {
                        metricsExportExpectation.fulfill()
                    }
                    
                }
            }
            
            return .success
        })
                
        let persistenceMetricExporter = PersistenceMetricExporterDecorator(
            metricExporter: mockMetricExporter,
            storageDirectory: temporaryDirectory.url,
            exportCondition: { return true },
            performancePreset: PersistencePerformancePreset.mockWith(
                storagePerformance: StoragePerformanceMock.writeEachObjectToNewFileAndReadAllFiles,
                synchronousWrite: true,
                exportPerformance: ExportPerformanceMock.veryQuick
            )
        )

        let provider = MeterProviderSdk(
            metricProcessor: MetricProcessorSdk(),
            metricExporter: persistenceMetricExporter,
            metricPushInterval: 0.1
        )

        let meter = provider.get(instrumentationName: "MyMeter")

        let myCounter = meter.createIntCounter(name: "MyCounter")
        myCounter.add(value: 100, labels: ["labelKey": "labelValue"])
        
        waitForExpectations(timeout: 10, handler: nil)
    }
}
