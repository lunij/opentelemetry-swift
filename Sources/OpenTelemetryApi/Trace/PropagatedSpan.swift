/*
 * Copyright The OpenTelemetry Authors
 * SPDX-License-Identifier: Apache-2.0
 */

import Foundation

/// The PropagatedSpan is the default Span that is used when no Span
/// implementation is available. All operations are no-op except context propagation.
class PropagatedSpan: Span {
    var name: String

    var kind: SpanKind

    var context: SpanContext

    func end() {
        OpenTelemetry.instance.contextProvider.removeContextForSpan(self)
    }

    func end(time _: Date) {
        end()
    }

    /// Returns a DefaultSpan with an invalid SpanContext.
    convenience init() {
        let invalidContext = SpanContext.create(traceId: TraceId(),
                                                spanId: SpanId(),
                                                traceFlags: TraceFlags(),
                                                traceState: TraceState())
        self.init(name: "", context: invalidContext, kind: .client)
    }

    /// Creates an instance of this class with the SpanContext.
    /// - Parameter context: the SpanContext
    convenience init(context: SpanContext) {
        self.init(name: "", context: context, kind: .client)
    }

    /// Creates an instance of this class with the SpanContext and Span kind
    /// - Parameters:
    ///   - context: the SpanContext
    ///   - kind: the SpanKind
    convenience init(context: SpanContext, kind: SpanKind) {
        self.init(name: "", context: context, kind: kind)
    }

    /// Creates an instance of this class with the SpanContext and Span name
    /// - Parameters:
    ///   - context: the SpanContext
    ///   - kind: the SpanKind
    convenience init(name: String, context: SpanContext) {
        self.init(name: name, context: context, kind: .client)
    }

    /// Creates an instance of this class with the SpanContext, Span kind and name
    /// - Parameters:
    ///   - context: the SpanContext
    ///   - kind: the SpanKind
    init(name: String, context: SpanContext, kind: SpanKind) {
        self.name = name
        self.context = context
        self.kind = kind
    }

    var isRecording: Bool {
        false
    }

    var status: Status {
        get {
            Status.ok
        }
        // swiftlint:disable:next unused_setter_value
        set {
            // noop
        }
    }

    var description: String {
        "PropagatedSpan"
    }

    func updateName(name _: String) {}

    func setAttribute(key _: String, value _: AttributeValue?) {}

    func addEvent(name _: String) {}

    func addEvent(name _: String, timestamp _: Date) {}

    func addEvent(name _: String, attributes _: [String: AttributeValue]) {}

    func addEvent(name _: String, attributes _: [String: AttributeValue], timestamp _: Date) {}
}
