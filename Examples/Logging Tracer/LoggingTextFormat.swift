/*
 * Copyright The OpenTelemetry Authors
 * SPDX-License-Identifier: Apache-2.0
 */

import Foundation
import OpenTelemetryApi

class LoggingTextFormat: TextMapPropagator {
    var fields = Set<String>()

    func inject<S>(spanContext: SpanContext, carrier _: inout [String: String], setter _: S) where S: Setter {
        Logger.log("LoggingTextFormat.Inject(\(spanContext), ...)")
    }

    func extract<G>(carrier _: [String: String], getter _: G) -> SpanContext? where G: Getter {
        Logger.log("LoggingTextFormat.Extract(...)")
        return nil
    }
}
