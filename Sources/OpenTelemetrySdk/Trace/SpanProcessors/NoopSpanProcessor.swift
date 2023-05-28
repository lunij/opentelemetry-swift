/*
 * Copyright The OpenTelemetry Authors
 * SPDX-License-Identifier: Apache-2.0
 */

import Foundation
import OpenTelemetryApi

struct NoopSpanProcessor: SpanProcessor {
    init() {}

    let isStartRequired = false
    let isEndRequired = false

    func onStart(parentContext _: SpanContext?, span _: ReadableSpan) {}

    func onEnd(span _: ReadableSpan) {}

    func shutdown() {}

    func forceFlush(timeout _: TimeInterval? = nil) {}
}
