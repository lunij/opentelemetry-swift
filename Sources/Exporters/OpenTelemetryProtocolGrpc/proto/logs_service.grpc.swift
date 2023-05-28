//
// DO NOT EDIT.
//
// Generated by the protocol buffer compiler.
// Source: opentelemetry/proto/collector/logs/v1/logs_service.proto
//

//
// Copyright 2018, gRPC Authors All rights reserved.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//
import GRPC
import NIO
import NIOConcurrencyHelpers
import OpenTelemetryProtocolExporterCommon
import SwiftProtobuf

/// Service that can be used to push logs between one Application instrumented with
/// OpenTelemetry and an collector, or between an collector and a central collector (in this
/// case logs are sent/received to/from multiple Applications).
///
/// Usage: instantiate `Opentelemetry_Proto_Collector_Logs_V1_LogsServiceClient`, then call methods of this protocol to make API calls.
public protocol Opentelemetry_Proto_Collector_Logs_V1_LogsServiceClientProtocol: GRPCClient {
    var serviceName: String { get }
    var interceptors: Opentelemetry_Proto_Collector_Logs_V1_LogsServiceClientInterceptorFactoryProtocol? { get }

    func export(
        _ request: Opentelemetry_Proto_Collector_Logs_V1_ExportLogsServiceRequest,
        callOptions: CallOptions?
    ) -> UnaryCall<Opentelemetry_Proto_Collector_Logs_V1_ExportLogsServiceRequest, Opentelemetry_Proto_Collector_Logs_V1_ExportLogsServiceResponse>
}

public extension Opentelemetry_Proto_Collector_Logs_V1_LogsServiceClientProtocol {
    var serviceName: String {
        "opentelemetry.proto.collector.logs.v1.LogsService"
    }

    /// For performance reasons, it is recommended to keep this RPC
    /// alive for the entire life of the application.
    ///
    /// - Parameters:
    ///   - request: Request to send to Export.
    ///   - callOptions: Call options.
    /// - Returns: A `UnaryCall` with futures for the metadata, status and response.
    func export(
        _ request: Opentelemetry_Proto_Collector_Logs_V1_ExportLogsServiceRequest,
        callOptions: CallOptions? = nil
    ) -> UnaryCall<Opentelemetry_Proto_Collector_Logs_V1_ExportLogsServiceRequest, Opentelemetry_Proto_Collector_Logs_V1_ExportLogsServiceResponse> {
        makeUnaryCall(
            path: Opentelemetry_Proto_Collector_Logs_V1_LogsServiceClientMetadata.Methods.export.path,
            request: request,
            callOptions: callOptions ?? defaultCallOptions,
            interceptors: interceptors?.makeExportInterceptors() ?? []
        )
    }
}

#if compiler(>=5.6)
@available(*, deprecated)
extension Opentelemetry_Proto_Collector_Logs_V1_LogsServiceClient: @unchecked Sendable {}
#endif // compiler(>=5.6)

@available(*, deprecated, renamed: "Opentelemetry_Proto_Collector_Logs_V1_LogsServiceNIOClient")
public final class Opentelemetry_Proto_Collector_Logs_V1_LogsServiceClient: Opentelemetry_Proto_Collector_Logs_V1_LogsServiceClientProtocol {
    private let lock = Lock()
    private var _defaultCallOptions: CallOptions
    private var _interceptors: Opentelemetry_Proto_Collector_Logs_V1_LogsServiceClientInterceptorFactoryProtocol?
    public let channel: GRPCChannel
    public var defaultCallOptions: CallOptions {
        get { lock.withLock { self._defaultCallOptions } }
        set { lock.withLockVoid { self._defaultCallOptions = newValue } }
    }

    public var interceptors: Opentelemetry_Proto_Collector_Logs_V1_LogsServiceClientInterceptorFactoryProtocol? {
        get { lock.withLock { self._interceptors } }
        set { lock.withLockVoid { self._interceptors = newValue } }
    }

    /// Creates a client for the opentelemetry.proto.collector.logs.v1.LogsService service.
    ///
    /// - Parameters:
    ///   - channel: `GRPCChannel` to the service host.
    ///   - defaultCallOptions: Options to use for each service call if the user doesn't provide them.
    ///   - interceptors: A factory providing interceptors for each RPC.
    public init(
        channel: GRPCChannel,
        defaultCallOptions: CallOptions = CallOptions(),
        interceptors: Opentelemetry_Proto_Collector_Logs_V1_LogsServiceClientInterceptorFactoryProtocol? = nil
    ) {
        self.channel = channel
        _defaultCallOptions = defaultCallOptions
        _interceptors = interceptors
    }
}

public struct Opentelemetry_Proto_Collector_Logs_V1_LogsServiceNIOClient: Opentelemetry_Proto_Collector_Logs_V1_LogsServiceClientProtocol {
    public var channel: GRPCChannel
    public var defaultCallOptions: CallOptions
    public var interceptors: Opentelemetry_Proto_Collector_Logs_V1_LogsServiceClientInterceptorFactoryProtocol?

    /// Creates a client for the opentelemetry.proto.collector.logs.v1.LogsService service.
    ///
    /// - Parameters:
    ///   - channel: `GRPCChannel` to the service host.
    ///   - defaultCallOptions: Options to use for each service call if the user doesn't provide them.
    ///   - interceptors: A factory providing interceptors for each RPC.
    public init(
        channel: GRPCChannel,
        defaultCallOptions: CallOptions = CallOptions(),
        interceptors: Opentelemetry_Proto_Collector_Logs_V1_LogsServiceClientInterceptorFactoryProtocol? = nil
    ) {
        self.channel = channel
        self.defaultCallOptions = defaultCallOptions
        self.interceptors = interceptors
    }
}

#if compiler(>=5.6)
/// Service that can be used to push logs between one Application instrumented with
/// OpenTelemetry and an collector, or between an collector and a central collector (in this
/// case logs are sent/received to/from multiple Applications).
@available(macOS 10.15, iOS 13, tvOS 13, watchOS 6, *)
public protocol Opentelemetry_Proto_Collector_Logs_V1_LogsServiceAsyncClientProtocol: GRPCClient {
    static var serviceDescriptor: GRPCServiceDescriptor { get }
    var interceptors: Opentelemetry_Proto_Collector_Logs_V1_LogsServiceClientInterceptorFactoryProtocol? { get }

    func makeExportCall(
        _ request: Opentelemetry_Proto_Collector_Logs_V1_ExportLogsServiceRequest,
        callOptions: CallOptions?
    ) -> GRPCAsyncUnaryCall<Opentelemetry_Proto_Collector_Logs_V1_ExportLogsServiceRequest, Opentelemetry_Proto_Collector_Logs_V1_ExportLogsServiceResponse>
}

@available(macOS 10.15, iOS 13, tvOS 13, watchOS 6, *)
public extension Opentelemetry_Proto_Collector_Logs_V1_LogsServiceAsyncClientProtocol {
    static var serviceDescriptor: GRPCServiceDescriptor {
        Opentelemetry_Proto_Collector_Logs_V1_LogsServiceClientMetadata.serviceDescriptor
    }

    var interceptors: Opentelemetry_Proto_Collector_Logs_V1_LogsServiceClientInterceptorFactoryProtocol? {
        nil
    }

    func makeExportCall(
        _ request: Opentelemetry_Proto_Collector_Logs_V1_ExportLogsServiceRequest,
        callOptions: CallOptions? = nil
    ) -> GRPCAsyncUnaryCall<Opentelemetry_Proto_Collector_Logs_V1_ExportLogsServiceRequest, Opentelemetry_Proto_Collector_Logs_V1_ExportLogsServiceResponse> {
        makeAsyncUnaryCall(
            path: Opentelemetry_Proto_Collector_Logs_V1_LogsServiceClientMetadata.Methods.export.path,
            request: request,
            callOptions: callOptions ?? defaultCallOptions,
            interceptors: interceptors?.makeExportInterceptors() ?? []
        )
    }
}

@available(macOS 10.15, iOS 13, tvOS 13, watchOS 6, *)
public extension Opentelemetry_Proto_Collector_Logs_V1_LogsServiceAsyncClientProtocol {
    func export(
        _ request: Opentelemetry_Proto_Collector_Logs_V1_ExportLogsServiceRequest,
        callOptions: CallOptions? = nil
    ) async throws -> Opentelemetry_Proto_Collector_Logs_V1_ExportLogsServiceResponse {
        try await performAsyncUnaryCall(
            path: Opentelemetry_Proto_Collector_Logs_V1_LogsServiceClientMetadata.Methods.export.path,
            request: request,
            callOptions: callOptions ?? defaultCallOptions,
            interceptors: interceptors?.makeExportInterceptors() ?? []
        )
    }
}

@available(macOS 10.15, iOS 13, tvOS 13, watchOS 6, *)
public struct Opentelemetry_Proto_Collector_Logs_V1_LogsServiceAsyncClient: Opentelemetry_Proto_Collector_Logs_V1_LogsServiceAsyncClientProtocol {
    public var channel: GRPCChannel
    public var defaultCallOptions: CallOptions
    public var interceptors: Opentelemetry_Proto_Collector_Logs_V1_LogsServiceClientInterceptorFactoryProtocol?

    public init(
        channel: GRPCChannel,
        defaultCallOptions: CallOptions = CallOptions(),
        interceptors: Opentelemetry_Proto_Collector_Logs_V1_LogsServiceClientInterceptorFactoryProtocol? = nil
    ) {
        self.channel = channel
        self.defaultCallOptions = defaultCallOptions
        self.interceptors = interceptors
    }
}

#endif // compiler(>=5.6)

public protocol Opentelemetry_Proto_Collector_Logs_V1_LogsServiceClientInterceptorFactoryProtocol: GRPCSendable {
    /// - Returns: Interceptors to use when invoking 'export'.
    func makeExportInterceptors() -> [ClientInterceptor<Opentelemetry_Proto_Collector_Logs_V1_ExportLogsServiceRequest, Opentelemetry_Proto_Collector_Logs_V1_ExportLogsServiceResponse>]
}

public enum Opentelemetry_Proto_Collector_Logs_V1_LogsServiceClientMetadata {
    public static let serviceDescriptor = GRPCServiceDescriptor(
        name: "LogsService",
        fullName: "opentelemetry.proto.collector.logs.v1.LogsService",
        methods: [
            Opentelemetry_Proto_Collector_Logs_V1_LogsServiceClientMetadata.Methods.export
        ]
    )

    public enum Methods {
        public static let export = GRPCMethodDescriptor(
            name: "Export",
            path: "/opentelemetry.proto.collector.logs.v1.LogsService/Export",
            type: GRPCCallType.unary
        )
    }
}

/// Service that can be used to push logs between one Application instrumented with
/// OpenTelemetry and an collector, or between an collector and a central collector (in this
/// case logs are sent/received to/from multiple Applications).
///
/// To build a server, implement a class that conforms to this protocol.
public protocol Opentelemetry_Proto_Collector_Logs_V1_LogsServiceProvider: CallHandlerProvider {
    var interceptors: Opentelemetry_Proto_Collector_Logs_V1_LogsServiceServerInterceptorFactoryProtocol? { get }

    /// For performance reasons, it is recommended to keep this RPC
    /// alive for the entire life of the application.
    func export(request: Opentelemetry_Proto_Collector_Logs_V1_ExportLogsServiceRequest, context: StatusOnlyCallContext) -> EventLoopFuture<Opentelemetry_Proto_Collector_Logs_V1_ExportLogsServiceResponse>
}

public extension Opentelemetry_Proto_Collector_Logs_V1_LogsServiceProvider {
    var serviceName: Substring {
        Opentelemetry_Proto_Collector_Logs_V1_LogsServiceServerMetadata.serviceDescriptor.fullName[...]
    }

    /// Determines, calls and returns the appropriate request handler, depending on the request's method.
    /// Returns nil for methods not handled by this service.
    func handle(
        method name: Substring,
        context: CallHandlerContext
    ) -> GRPCServerHandlerProtocol? {
        switch name {
        case "Export":
            return UnaryServerHandler(
                context: context,
                requestDeserializer: ProtobufDeserializer<Opentelemetry_Proto_Collector_Logs_V1_ExportLogsServiceRequest>(),
                responseSerializer: ProtobufSerializer<Opentelemetry_Proto_Collector_Logs_V1_ExportLogsServiceResponse>(),
                interceptors: interceptors?.makeExportInterceptors() ?? [],
                userFunction: export(request:context:)
            )

        default:
            return nil
        }
    }
}

#if compiler(>=5.6)

/// Service that can be used to push logs between one Application instrumented with
/// OpenTelemetry and an collector, or between an collector and a central collector (in this
/// case logs are sent/received to/from multiple Applications).
///
/// To implement a server, implement an object which conforms to this protocol.
@available(macOS 10.15, iOS 13, tvOS 13, watchOS 6, *)
public protocol Opentelemetry_Proto_Collector_Logs_V1_LogsServiceAsyncProvider: CallHandlerProvider {
    static var serviceDescriptor: GRPCServiceDescriptor { get }
    var interceptors: Opentelemetry_Proto_Collector_Logs_V1_LogsServiceServerInterceptorFactoryProtocol? { get }

    /// For performance reasons, it is recommended to keep this RPC
    /// alive for the entire life of the application.
    @Sendable func export(
        request: Opentelemetry_Proto_Collector_Logs_V1_ExportLogsServiceRequest,
        context: GRPCAsyncServerCallContext
    ) async throws -> Opentelemetry_Proto_Collector_Logs_V1_ExportLogsServiceResponse
}

@available(macOS 10.15, iOS 13, tvOS 13, watchOS 6, *)
public extension Opentelemetry_Proto_Collector_Logs_V1_LogsServiceAsyncProvider {
    static var serviceDescriptor: GRPCServiceDescriptor {
        Opentelemetry_Proto_Collector_Logs_V1_LogsServiceServerMetadata.serviceDescriptor
    }

    var serviceName: Substring {
        Opentelemetry_Proto_Collector_Logs_V1_LogsServiceServerMetadata.serviceDescriptor.fullName[...]
    }

    var interceptors: Opentelemetry_Proto_Collector_Logs_V1_LogsServiceServerInterceptorFactoryProtocol? {
        nil
    }

    func handle(
        method name: Substring,
        context: CallHandlerContext
    ) -> GRPCServerHandlerProtocol? {
        switch name {
        case "Export":
            return GRPCAsyncServerHandler(
                context: context,
                requestDeserializer: ProtobufDeserializer<Opentelemetry_Proto_Collector_Logs_V1_ExportLogsServiceRequest>(),
                responseSerializer: ProtobufSerializer<Opentelemetry_Proto_Collector_Logs_V1_ExportLogsServiceResponse>(),
                interceptors: interceptors?.makeExportInterceptors() ?? [],
                wrapping: export(request:context:)
            )

        default:
            return nil
        }
    }
}

#endif // compiler(>=5.6)

public protocol Opentelemetry_Proto_Collector_Logs_V1_LogsServiceServerInterceptorFactoryProtocol {
    /// - Returns: Interceptors to use when handling 'export'.
    ///   Defaults to calling `self.makeInterceptors()`.
    func makeExportInterceptors() -> [ServerInterceptor<Opentelemetry_Proto_Collector_Logs_V1_ExportLogsServiceRequest, Opentelemetry_Proto_Collector_Logs_V1_ExportLogsServiceResponse>]
}

public enum Opentelemetry_Proto_Collector_Logs_V1_LogsServiceServerMetadata {
    public static let serviceDescriptor = GRPCServiceDescriptor(
        name: "LogsService",
        fullName: "opentelemetry.proto.collector.logs.v1.LogsService",
        methods: [
            Opentelemetry_Proto_Collector_Logs_V1_LogsServiceServerMetadata.Methods.export
        ]
    )

    public enum Methods {
        public static let export = GRPCMethodDescriptor(
            name: "Export",
            path: "/opentelemetry.proto.collector.logs.v1.LogsService/Export",
            type: GRPCCallType.unary
        )
    }
}
