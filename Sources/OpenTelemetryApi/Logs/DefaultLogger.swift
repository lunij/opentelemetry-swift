/*
 * Copyright The OpenTelemetry Authors
 * SPDX-License-Identifier: Apache-2.0
 */

import Foundation

public class DefaultLogger: Logger {
    private static let instanceWithDomain = DefaultLogger(true)
    private static let instanceNoDomain = DefaultLogger(false)
    private static let noopLogRecordBuilder = NoopLogRecordBuilder()

    private var hasDomain: Bool

    private init(_ hasDomain: Bool) {
        self.hasDomain = hasDomain
    }

    static func getInstance(_ hasDomain: Bool) -> Logger {
        if hasDomain {
            return Self.instanceWithDomain
        } else {
            return Self.instanceNoDomain
        }
    }

    public func eventBuilder(name _: String) -> EventBuilder {
        if !hasDomain {
            /// log error
        }
        return Self.noopLogRecordBuilder
    }

    public func logRecordBuilder() -> LogRecordBuilder {
        Self.noopLogRecordBuilder
    }

    private class NoopLogRecordBuilder: EventBuilder {
        func setTimestamp(_: Date) -> Self {
            self
        }

        func setObservedTimestamp(_: Date) -> Self {
            self
        }

        func setSpanContext(_: SpanContext) -> Self {
            self
        }

        func setSeverity(_: Severity) -> Self {
            self
        }

        func setBody(_: String) -> Self {
            self
        }

        func setAttributes(_: [String: AttributeValue]) -> Self {
            self
        }

        func emit() {}
    }
}
