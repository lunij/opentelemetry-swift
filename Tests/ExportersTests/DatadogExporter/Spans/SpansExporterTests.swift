/*
 * Copyright The OpenTelemetry Authors
 * SPDX-License-Identifier: Apache-2.0
 */

import OpenTelemetryApi
import XCTest
@testable import DatadogExporter
@testable import OpenTelemetrySdk

class SpansExporterTests: XCTestCase {
    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        super.tearDown()
    }

    func testWhenExportSpanIsCalled_thenTraceIsUploaded() throws {
        #if os(watchOS)
        throw XCTSkip("Test is flaky on watchOS")
        #endif

        var tracesSent = false
        let expec = expectation(description: "traces received")
        let server = HttpTestServer(url: URL(string: "http://localhost:33333"),
                                    config: HttpTestServerConfig(tracesReceivedCallback: {
                                                                     tracesSent = true
                                                                     expec.fulfill()
                                                                 },
                                                                 logsReceivedCallback: nil))
        let sem = DispatchSemaphore(value: 0)
        DispatchQueue.global(qos: .default).async {
            do {
                try server.start(semaphore: sem)
            } catch {
                XCTFail()
                return
            }
        }
        sem.wait()

        let configuration = ExporterConfiguration(serviceName: "serviceName",
                                                  resource: "resource",
                                                  applicationName: "applicationName",
                                                  applicationVersion: "applicationVersion",
                                                  environment: "environment",
                                                  apiKey: "apikey",
                                                  endpoint: Endpoint.custom(
                                                      tracesURL: URL(string: "http://localhost:33333/traces")!,
                                                      logsURL: URL(string: "http://localhost:33333/logs")!,
                                                      metricsURL: URL(string: "http://localhost:33333/metrics")!
                                                  ),
                                                  uploadCondition: { true })

        let spansExporter = try SpansExporter(config: configuration)

        let spanData = createBasicSpan()
        spansExporter.exportSpan(span: spanData)
        spansExporter.tracesStorage.writer.queue.sync {}

        waitForExpectations(timeout: 30) { error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                XCTFail()
            }
        }
        XCTAssertTrue(tracesSent)

        server.stop()
    }

    private func createBasicSpan() -> SpanData {
        SpanData(traceId: TraceId(),
                 spanId: SpanId(),
                 traceFlags: TraceFlags(),
                 traceState: TraceState(),
                 resource: Resource(),
                 instrumentationScope: InstrumentationScopeInfo(),
                 name: "spanName",
                 kind: .server,
                 startTime: Date(timeIntervalSinceReferenceDate: 3_000),
                 endTime: Date(timeIntervalSinceReferenceDate: 3_001),
                 hasRemoteParent: false)
    }
}
