/*
 * Copyright The OpenTelemetry Authors
 * SPDX-License-Identifier: Apache-2.0
 */

import Foundation

public class DefaultLoggerProvider: LoggerProvider {
    public static let instance: LoggerProvider = DefaultLoggerProvider()
    fileprivate static let noopBuilderWithDomain = NoopLoggerBuilder(true)
    fileprivate static let noopBuilderNoDomain = NoopLoggerBuilder(false)

    public func get(instrumentationScopeName: String) -> Logger {
        loggerBuilder(instrumentationScopeName: instrumentationScopeName).build()
    }

    public func loggerBuilder(instrumentationScopeName _: String) -> LoggerBuilder {
        Self.noopBuilderNoDomain
    }
}

private class NoopLoggerBuilder: LoggerBuilder {
    private let hasDomain: Bool

    fileprivate init(_ hasDomain: Bool) {
        self.hasDomain = hasDomain
    }

    public func setEventDomain(_ eventDomain: String) -> Self {
        if eventDomain.isEmpty {
            return DefaultLoggerProvider.noopBuilderNoDomain as! Self
        }
        return DefaultLoggerProvider.noopBuilderWithDomain as! Self
    }

    public func setSchemaUrl(_: String) -> Self {
        self
    }

    public func setInstrumentationVersion(_: String) -> Self {
        self
    }

    public func setIncludeTraceContext(_: Bool) -> Self {
        self
    }

    public func setAttributes(_: [String: AttributeValue]) -> Self {
        self
    }

    public func build() -> Logger {
        DefaultLogger.getInstance(hasDomain)
    }
}
