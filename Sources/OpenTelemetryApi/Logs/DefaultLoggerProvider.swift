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

    public func setEventDomain(_ eventDomain: String) -> LoggerBuilder {
        if eventDomain.isEmpty {
            return DefaultLoggerProvider.noopBuilderNoDomain
        }
        return DefaultLoggerProvider.noopBuilderWithDomain
    }

    public func setSchemaUrl(_: String) -> LoggerBuilder {
        self
    }

    public func setInstrumentationVersion(_: String) -> LoggerBuilder {
        self
    }

    public func setIncludeTraceContext(_: Bool) -> LoggerBuilder {
        self
    }

    public func setAttributes(_: [String: AttributeValue]) -> LoggerBuilder {
        self
    }

    public func build() -> Logger {
        DefaultLogger.getInstance(hasDomain)
    }
}
