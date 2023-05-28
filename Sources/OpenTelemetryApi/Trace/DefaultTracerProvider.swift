/*
 * Copyright The OpenTelemetry Authors
 * SPDX-License-Identifier: Apache-2.0
 */

import Foundation

public class DefaultTracerProvider: TracerProvider {
    public static let instance = DefaultTracerProvider()

    public func get(instrumentationName _: String, instrumentationVersion _: String? = nil) -> Tracer {
        DefaultTracer.instance
    }
}
