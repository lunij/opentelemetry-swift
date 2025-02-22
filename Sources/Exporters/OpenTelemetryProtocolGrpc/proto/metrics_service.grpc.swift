//
// DO NOT EDIT.
//
// Generated by the protocol buffer compiler.
// Source: opentelemetry/proto/collector/metrics/v1/metrics_service.proto
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
import SwiftProtobuf
import OpenTelemetryProtocolExporterCommon

/// Service that can be used to push metrics between one Application
/// instrumented with OpenTelemetry and a collector, or between a collector and a
/// central collector.
///
/// Usage: instantiate `Opentelemetry_Proto_Collector_Metrics_V1_MetricsServiceClient`, then call methods of this protocol to make API calls.
public protocol Opentelemetry_Proto_Collector_Metrics_V1_MetricsServiceClientProtocol: GRPCClient {
  var serviceName: String { get }
  var interceptors: Opentelemetry_Proto_Collector_Metrics_V1_MetricsServiceClientInterceptorFactoryProtocol? { get }

  func export(
    _ request: Opentelemetry_Proto_Collector_Metrics_V1_ExportMetricsServiceRequest,
    callOptions: CallOptions?
  ) -> UnaryCall<Opentelemetry_Proto_Collector_Metrics_V1_ExportMetricsServiceRequest, Opentelemetry_Proto_Collector_Metrics_V1_ExportMetricsServiceResponse>
}

extension Opentelemetry_Proto_Collector_Metrics_V1_MetricsServiceClientProtocol {
  public var serviceName: String {
    return "opentelemetry.proto.collector.metrics.v1.MetricsService"
  }

  /// For performance reasons, it is recommended to keep this RPC
  /// alive for the entire life of the application.
  ///
  /// - Parameters:
  ///   - request: Request to send to Export.
  ///   - callOptions: Call options.
  /// - Returns: A `UnaryCall` with futures for the metadata, status and response.
  public func export(
    _ request: Opentelemetry_Proto_Collector_Metrics_V1_ExportMetricsServiceRequest,
    callOptions: CallOptions? = nil
  ) -> UnaryCall<Opentelemetry_Proto_Collector_Metrics_V1_ExportMetricsServiceRequest, Opentelemetry_Proto_Collector_Metrics_V1_ExportMetricsServiceResponse> {
    return self.makeUnaryCall(
      path: Opentelemetry_Proto_Collector_Metrics_V1_MetricsServiceClientMetadata.Methods.export.path,
      request: request,
      callOptions: callOptions ?? self.defaultCallOptions,
      interceptors: self.interceptors?.makeExportInterceptors() ?? []
    )
  }
}

#if compiler(>=5.6)
@available(*, deprecated)
extension Opentelemetry_Proto_Collector_Metrics_V1_MetricsServiceClient: @unchecked Sendable {}
#endif // compiler(>=5.6)

@available(*, deprecated, renamed: "Opentelemetry_Proto_Collector_Metrics_V1_MetricsServiceNIOClient")
public final class Opentelemetry_Proto_Collector_Metrics_V1_MetricsServiceClient: Opentelemetry_Proto_Collector_Metrics_V1_MetricsServiceClientProtocol {
  private let lock = Lock()
  private var _defaultCallOptions: CallOptions
  private var _interceptors: Opentelemetry_Proto_Collector_Metrics_V1_MetricsServiceClientInterceptorFactoryProtocol?
  public let channel: GRPCChannel
  public var defaultCallOptions: CallOptions {
    get { self.lock.withLock { return self._defaultCallOptions } }
    set { self.lock.withLockVoid { self._defaultCallOptions = newValue } }
  }
  public var interceptors: Opentelemetry_Proto_Collector_Metrics_V1_MetricsServiceClientInterceptorFactoryProtocol? {
    get { self.lock.withLock { return self._interceptors } }
    set { self.lock.withLockVoid { self._interceptors = newValue } }
  }

  /// Creates a client for the opentelemetry.proto.collector.metrics.v1.MetricsService service.
  ///
  /// - Parameters:
  ///   - channel: `GRPCChannel` to the service host.
  ///   - defaultCallOptions: Options to use for each service call if the user doesn't provide them.
  ///   - interceptors: A factory providing interceptors for each RPC.
  public init(
    channel: GRPCChannel,
    defaultCallOptions: CallOptions = CallOptions(),
    interceptors: Opentelemetry_Proto_Collector_Metrics_V1_MetricsServiceClientInterceptorFactoryProtocol? = nil
  ) {
    self.channel = channel
    self._defaultCallOptions = defaultCallOptions
    self._interceptors = interceptors
  }
}

public struct Opentelemetry_Proto_Collector_Metrics_V1_MetricsServiceNIOClient: Opentelemetry_Proto_Collector_Metrics_V1_MetricsServiceClientProtocol {
  public var channel: GRPCChannel
  public var defaultCallOptions: CallOptions
  public var interceptors: Opentelemetry_Proto_Collector_Metrics_V1_MetricsServiceClientInterceptorFactoryProtocol?

  /// Creates a client for the opentelemetry.proto.collector.metrics.v1.MetricsService service.
  ///
  /// - Parameters:
  ///   - channel: `GRPCChannel` to the service host.
  ///   - defaultCallOptions: Options to use for each service call if the user doesn't provide them.
  ///   - interceptors: A factory providing interceptors for each RPC.
  public init(
    channel: GRPCChannel,
    defaultCallOptions: CallOptions = CallOptions(),
    interceptors: Opentelemetry_Proto_Collector_Metrics_V1_MetricsServiceClientInterceptorFactoryProtocol? = nil
  ) {
    self.channel = channel
    self.defaultCallOptions = defaultCallOptions
    self.interceptors = interceptors
  }
}

#if compiler(>=5.6)
/// Service that can be used to push metrics between one Application
/// instrumented with OpenTelemetry and a collector, or between a collector and a
/// central collector.
@available(macOS 10.15, iOS 13, tvOS 13, watchOS 6, *)
public protocol Opentelemetry_Proto_Collector_Metrics_V1_MetricsServiceAsyncClientProtocol: GRPCClient {
  static var serviceDescriptor: GRPCServiceDescriptor { get }
  var interceptors: Opentelemetry_Proto_Collector_Metrics_V1_MetricsServiceClientInterceptorFactoryProtocol? { get }

  func makeExportCall(
    _ request: Opentelemetry_Proto_Collector_Metrics_V1_ExportMetricsServiceRequest,
    callOptions: CallOptions?
  ) -> GRPCAsyncUnaryCall<Opentelemetry_Proto_Collector_Metrics_V1_ExportMetricsServiceRequest, Opentelemetry_Proto_Collector_Metrics_V1_ExportMetricsServiceResponse>
}

@available(macOS 10.15, iOS 13, tvOS 13, watchOS 6, *)
extension Opentelemetry_Proto_Collector_Metrics_V1_MetricsServiceAsyncClientProtocol {
  public static var serviceDescriptor: GRPCServiceDescriptor {
    return Opentelemetry_Proto_Collector_Metrics_V1_MetricsServiceClientMetadata.serviceDescriptor
  }

  public var interceptors: Opentelemetry_Proto_Collector_Metrics_V1_MetricsServiceClientInterceptorFactoryProtocol? {
    return nil
  }

  public func makeExportCall(
    _ request: Opentelemetry_Proto_Collector_Metrics_V1_ExportMetricsServiceRequest,
    callOptions: CallOptions? = nil
  ) -> GRPCAsyncUnaryCall<Opentelemetry_Proto_Collector_Metrics_V1_ExportMetricsServiceRequest, Opentelemetry_Proto_Collector_Metrics_V1_ExportMetricsServiceResponse> {
    return self.makeAsyncUnaryCall(
      path: Opentelemetry_Proto_Collector_Metrics_V1_MetricsServiceClientMetadata.Methods.export.path,
      request: request,
      callOptions: callOptions ?? self.defaultCallOptions,
      interceptors: self.interceptors?.makeExportInterceptors() ?? []
    )
  }
}

@available(macOS 10.15, iOS 13, tvOS 13, watchOS 6, *)
extension Opentelemetry_Proto_Collector_Metrics_V1_MetricsServiceAsyncClientProtocol {
  public func export(
    _ request: Opentelemetry_Proto_Collector_Metrics_V1_ExportMetricsServiceRequest,
    callOptions: CallOptions? = nil
  ) async throws -> Opentelemetry_Proto_Collector_Metrics_V1_ExportMetricsServiceResponse {
    return try await self.performAsyncUnaryCall(
      path: Opentelemetry_Proto_Collector_Metrics_V1_MetricsServiceClientMetadata.Methods.export.path,
      request: request,
      callOptions: callOptions ?? self.defaultCallOptions,
      interceptors: self.interceptors?.makeExportInterceptors() ?? []
    )
  }
}

@available(macOS 10.15, iOS 13, tvOS 13, watchOS 6, *)
public struct Opentelemetry_Proto_Collector_Metrics_V1_MetricsServiceAsyncClient: Opentelemetry_Proto_Collector_Metrics_V1_MetricsServiceAsyncClientProtocol {
  public var channel: GRPCChannel
  public var defaultCallOptions: CallOptions
  public var interceptors: Opentelemetry_Proto_Collector_Metrics_V1_MetricsServiceClientInterceptorFactoryProtocol?

  public init(
    channel: GRPCChannel,
    defaultCallOptions: CallOptions = CallOptions(),
    interceptors: Opentelemetry_Proto_Collector_Metrics_V1_MetricsServiceClientInterceptorFactoryProtocol? = nil
  ) {
    self.channel = channel
    self.defaultCallOptions = defaultCallOptions
    self.interceptors = interceptors
  }
}

#endif // compiler(>=5.6)

public protocol Opentelemetry_Proto_Collector_Metrics_V1_MetricsServiceClientInterceptorFactoryProtocol: GRPCSendable {

  /// - Returns: Interceptors to use when invoking 'export'.
  func makeExportInterceptors() -> [ClientInterceptor<Opentelemetry_Proto_Collector_Metrics_V1_ExportMetricsServiceRequest, Opentelemetry_Proto_Collector_Metrics_V1_ExportMetricsServiceResponse>]
}

public enum Opentelemetry_Proto_Collector_Metrics_V1_MetricsServiceClientMetadata {
  public static let serviceDescriptor = GRPCServiceDescriptor(
    name: "MetricsService",
    fullName: "opentelemetry.proto.collector.metrics.v1.MetricsService",
    methods: [
      Opentelemetry_Proto_Collector_Metrics_V1_MetricsServiceClientMetadata.Methods.export,
    ]
  )

  public enum Methods {
    public static let export = GRPCMethodDescriptor(
      name: "Export",
      path: "/opentelemetry.proto.collector.metrics.v1.MetricsService/Export",
      type: GRPCCallType.unary
    )
  }
}

/// Service that can be used to push metrics between one Application
/// instrumented with OpenTelemetry and a collector, or between a collector and a
/// central collector.
///
/// To build a server, implement a class that conforms to this protocol.
public protocol Opentelemetry_Proto_Collector_Metrics_V1_MetricsServiceProvider: CallHandlerProvider {
  var interceptors: Opentelemetry_Proto_Collector_Metrics_V1_MetricsServiceServerInterceptorFactoryProtocol? { get }

  /// For performance reasons, it is recommended to keep this RPC
  /// alive for the entire life of the application.
  func export(request: Opentelemetry_Proto_Collector_Metrics_V1_ExportMetricsServiceRequest, context: StatusOnlyCallContext) -> EventLoopFuture<Opentelemetry_Proto_Collector_Metrics_V1_ExportMetricsServiceResponse>
}

extension Opentelemetry_Proto_Collector_Metrics_V1_MetricsServiceProvider {
  public var serviceName: Substring {
    return Opentelemetry_Proto_Collector_Metrics_V1_MetricsServiceServerMetadata.serviceDescriptor.fullName[...]
  }

  /// Determines, calls and returns the appropriate request handler, depending on the request's method.
  /// Returns nil for methods not handled by this service.
  public func handle(
    method name: Substring,
    context: CallHandlerContext
  ) -> GRPCServerHandlerProtocol? {
    switch name {
    case "Export":
      return UnaryServerHandler(
        context: context,
        requestDeserializer: ProtobufDeserializer<Opentelemetry_Proto_Collector_Metrics_V1_ExportMetricsServiceRequest>(),
        responseSerializer: ProtobufSerializer<Opentelemetry_Proto_Collector_Metrics_V1_ExportMetricsServiceResponse>(),
        interceptors: self.interceptors?.makeExportInterceptors() ?? [],
        userFunction: self.export(request:context:)
      )

    default:
      return nil
    }
  }
}

#if compiler(>=5.6)

/// Service that can be used to push metrics between one Application
/// instrumented with OpenTelemetry and a collector, or between a collector and a
/// central collector.
///
/// To implement a server, implement an object which conforms to this protocol.
@available(macOS 10.15, iOS 13, tvOS 13, watchOS 6, *)
public protocol Opentelemetry_Proto_Collector_Metrics_V1_MetricsServiceAsyncProvider: CallHandlerProvider {
  static var serviceDescriptor: GRPCServiceDescriptor { get }
  var interceptors: Opentelemetry_Proto_Collector_Metrics_V1_MetricsServiceServerInterceptorFactoryProtocol? { get }

  /// For performance reasons, it is recommended to keep this RPC
  /// alive for the entire life of the application.
  @Sendable func export(
    request: Opentelemetry_Proto_Collector_Metrics_V1_ExportMetricsServiceRequest,
    context: GRPCAsyncServerCallContext
  ) async throws -> Opentelemetry_Proto_Collector_Metrics_V1_ExportMetricsServiceResponse
}

@available(macOS 10.15, iOS 13, tvOS 13, watchOS 6, *)
extension Opentelemetry_Proto_Collector_Metrics_V1_MetricsServiceAsyncProvider {
  public static var serviceDescriptor: GRPCServiceDescriptor {
    return Opentelemetry_Proto_Collector_Metrics_V1_MetricsServiceServerMetadata.serviceDescriptor
  }

  public var serviceName: Substring {
    return Opentelemetry_Proto_Collector_Metrics_V1_MetricsServiceServerMetadata.serviceDescriptor.fullName[...]
  }

  public var interceptors: Opentelemetry_Proto_Collector_Metrics_V1_MetricsServiceServerInterceptorFactoryProtocol? {
    return nil
  }

  public func handle(
    method name: Substring,
    context: CallHandlerContext
  ) -> GRPCServerHandlerProtocol? {
    switch name {
    case "Export":
      return GRPCAsyncServerHandler(
        context: context,
        requestDeserializer: ProtobufDeserializer<Opentelemetry_Proto_Collector_Metrics_V1_ExportMetricsServiceRequest>(),
        responseSerializer: ProtobufSerializer<Opentelemetry_Proto_Collector_Metrics_V1_ExportMetricsServiceResponse>(),
        interceptors: self.interceptors?.makeExportInterceptors() ?? [],
        wrapping: self.export(request:context:)
      )

    default:
      return nil
    }
  }
}

#endif // compiler(>=5.6)

public protocol Opentelemetry_Proto_Collector_Metrics_V1_MetricsServiceServerInterceptorFactoryProtocol {

  /// - Returns: Interceptors to use when handling 'export'.
  ///   Defaults to calling `self.makeInterceptors()`.
  func makeExportInterceptors() -> [ServerInterceptor<Opentelemetry_Proto_Collector_Metrics_V1_ExportMetricsServiceRequest, Opentelemetry_Proto_Collector_Metrics_V1_ExportMetricsServiceResponse>]
}

public enum Opentelemetry_Proto_Collector_Metrics_V1_MetricsServiceServerMetadata {
  public static let serviceDescriptor = GRPCServiceDescriptor(
    name: "MetricsService",
    fullName: "opentelemetry.proto.collector.metrics.v1.MetricsService",
    methods: [
      Opentelemetry_Proto_Collector_Metrics_V1_MetricsServiceServerMetadata.Methods.export,
    ]
  )

  public enum Methods {
    public static let export = GRPCMethodDescriptor(
      name: "Export",
      path: "/opentelemetry.proto.collector.metrics.v1.MetricsService/Export",
      type: GRPCCallType.unary
    )
  }
}
