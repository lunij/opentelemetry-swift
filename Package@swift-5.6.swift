// swift-tools-version:5.6
// The swift-tools-version declares the minimum version of Swift required to build this package.

import Foundation
import PackageDescription

let package = Package(
    name: "opentelemetry-swift",
    platforms: [
        .macOS(.v10_15),
        .iOS(.v11),
        .tvOS(.v11),
        .watchOS(.v3)
    ],
    products: [
        .library(name: "OpenTelemetryApi", type: .static, targets: ["OpenTelemetryApi"]),
        .library(name: "OpenTelemetrySdk", type: .static, targets: ["OpenTelemetrySdk"]),
        .library(name: "ResourceExtension", type: .static, targets: ["ResourceExtension"]),
        .library(name: "URLSessionInstrumentation", type: .static, targets: ["URLSessionInstrumentation"]),
        .library(name: "SignPostIntegration", type: .static, targets: ["SignPostIntegration"]),
        .library(name: "OpenTracingShim-experimental", type: .static, targets: ["OpenTracingShim"]),
        .library(name: "SwiftMetricsShim", type: .static, targets: ["SwiftMetricsShim"]),
        .library(name: "JaegerExporter", type: .static, targets: ["JaegerExporter"]),
        .library(name: "ZipkinExporter", type: .static, targets: ["ZipkinExporter"]),
        .library(name: "StdoutExporter", type: .static, targets: ["StdoutExporter"]),
        .library(name: "PrometheusExporter", type: .static, targets: ["PrometheusExporter"]),
        .library(name: "OpenTelemetryProtocolExporter", type: .static, targets: ["OpenTelemetryProtocolExporterGrpc"]),
        .library(name: "OpenTelemetryProtocolExporterHTTP", type: .static, targets: ["OpenTelemetryProtocolExporterHttp"]),
        .library(name: "PersistenceExporter", type: .static, targets: ["PersistenceExporter"]),
        .library(name: "InMemoryExporter", type: .static, targets: ["InMemoryExporter"]),
        .library(name: "DatadogExporter", type: .static, targets: ["DatadogExporter"]),
        .library(name: "NetworkStatus", type: .static, targets: ["NetworkStatus"]),
        .executable(name: "simpleExporter", targets: ["SimpleExporter"]),
        .executable(name: "OTLPExporter", targets: ["OTLPExporter"]),
        .executable(name: "OTLPHTTPExporter", targets: ["OTLPHTTPExporter"]),
        .executable(name: "loggingTracer", targets: ["LoggingTracer"])
    ],
    dependencies: [
        .package(url: "https://github.com/undefinedlabs/opentracing-objc", from: "0.5.2"),
        .package(url: "https://github.com/undefinedlabs/Thrift-Swift", from: "1.1.1"),
        .package(url: "https://github.com/apple/swift-nio.git", from: "2.0.0"),
        .package(url: "https://github.com/grpc/grpc-swift.git", from: "1.0.0"),
        .package(url: "https://github.com/apple/swift-protobuf.git", from: "1.20.2"),
        .package(url: "https://github.com/apple/swift-log.git", from: "1.4.4"),
        .package(url: "https://github.com/apple/swift-metrics.git", from: "2.1.1"),
        .package(url: "https://github.com/ashleymills/Reachability.swift", from: "5.1.0")
    ] + .plugins,
    targets: [
        .target(
            name: "OpenTelemetryApi",
            plugins: .default
        ),
        .target(
            name: "OpenTelemetrySdk",
            dependencies: ["OpenTelemetryApi"],
            plugins: .default
        ),
        .target(
            name: "ResourceExtension",
            dependencies: ["OpenTelemetrySdk"],
            path: "Sources/Instrumentation/SDKResourceExtension",
            exclude: ["README.md"],
            plugins: .default
        ),
        .target(
            name: "URLSessionInstrumentation",
            dependencies: ["OpenTelemetrySdk", "NetworkStatus"],
            path: "Sources/Instrumentation/URLSession",
            exclude: ["README.md"],
            plugins: .default
        ),
        .target(
            name: "NetworkStatus",
            dependencies: [
                "OpenTelemetryApi",
                .product(name: "Reachability", package: "Reachability.swift", condition: .when(platforms: [.iOS, .macOS, .tvOS, .macCatalyst, .linux]))
            ],
            path: "Sources/Instrumentation/NetworkStatus",
            linkerSettings: [.linkedFramework("CoreTelephony", .when(platforms: [.iOS], configuration: nil))],
            plugins: .default
        ),
        .target(
            name: "SignPostIntegration",
            dependencies: ["OpenTelemetrySdk"],
            path: "Sources/Instrumentation/SignPostIntegration",
            exclude: ["README.md"],
            plugins: .default
        ),
        .target(
            name: "OpenTracingShim",
            dependencies: [
                "OpenTelemetrySdk",
                .product(name: "Opentracing", package: "opentracing-objc")
            ],
            path: "Sources/Importers/OpenTracingShim",
            exclude: ["README.md"],
            plugins: .default
        ),
        .target(
            name: "SwiftMetricsShim",
            dependencies: [
                "OpenTelemetrySdk",
                .product(name: "CoreMetrics", package: "swift-metrics")
            ],
            path: "Sources/Importers/SwiftMetricsShim",
            exclude: ["README.md"],
            plugins: .default
        ),
        .target(
            name: "JaegerExporter",
            dependencies: [
                "OpenTelemetrySdk",
                .product(name: "Thrift", package: "Thrift-Swift", condition: .when(platforms: [.iOS, .macOS, .tvOS, .macCatalyst, .linux]))
            ],
            path: "Sources/Exporters/Jaeger",
            plugins: .default
        ),
        .target(
            name: "ZipkinExporter",
            dependencies: ["OpenTelemetrySdk"],
            path: "Sources/Exporters/Zipkin",
            plugins: .default
        ),
        .target(
            name: "PrometheusExporter",
            dependencies: [
                "OpenTelemetrySdk",
                .product(name: "NIO", package: "swift-nio"),
                .product(name: "NIOHTTP1", package: "swift-nio")
            ],
            path: "Sources/Exporters/Prometheus",
            plugins: .default
        ),
        .target(
            name: "OpenTelemetryProtocolExporterCommon",
            dependencies: [
                "OpenTelemetrySdk",
                .product(name: "Logging", package: "swift-log"),
                .product(name: "SwiftProtobuf", package: "swift-protobuf")
            ],
            path: "Sources/Exporters/OpenTelemetryProtocolCommon",
            plugins: .default
        ),
        .target(
            name: "OpenTelemetryProtocolExporterHttp",
            dependencies: [
                "OpenTelemetrySdk",
                "OpenTelemetryProtocolExporterCommon"
            ],
            path: "Sources/Exporters/OpenTelemetryProtocolHttp",
            plugins: .default
        ),
        .target(
            name: "OpenTelemetryProtocolExporterGrpc",
            dependencies: [
                "OpenTelemetrySdk",
                "OpenTelemetryProtocolExporterCommon",
                .product(name: "GRPC", package: "grpc-swift")
            ],
            path: "Sources/Exporters/OpenTelemetryProtocolGrpc",
            plugins: .default
        ),
        .target(
            name: "StdoutExporter",
            dependencies: ["OpenTelemetrySdk"],
            path: "Sources/Exporters/Stdout",
            plugins: .default
        ),
        .target(
            name: "InMemoryExporter",
            dependencies: ["OpenTelemetrySdk"],
            path: "Sources/Exporters/InMemory",
            plugins: .default
        ),
        .target(
            name: "DatadogExporter",
            dependencies: ["OpenTelemetrySdk"],
            path: "Sources/Exporters/DatadogExporter",
            exclude: ["NOTICE", "README.md"],
            plugins: .default
        ),
        .target(
            name: "PersistenceExporter",
            dependencies: ["OpenTelemetrySdk"],
            path: "Sources/Exporters/Persistence",
            plugins: .default
        ),
        .testTarget(
            name: "NetworkStatusTests",
            dependencies: [
                "NetworkStatus",
                .product(name: "Reachability", package: "Reachability.swift", condition: .when(platforms: [.iOS, .macOS, .tvOS, .macCatalyst, .linux]))
            ],
            path: "Tests/InstrumentationTests/NetworkStatusTests",
            plugins: .default
        ),
        .testTarget(
            name: "OpenTelemetryApiTests",
            dependencies: ["OpenTelemetryApi"],
            path: "Tests/OpenTelemetryApiTests",
            plugins: .default
        ),
        .testTarget(
            name: "OpenTelemetrySdkTests",
            dependencies: [
                "OpenTelemetryApi",
                "OpenTelemetrySdk"
            ],
            path: "Tests/OpenTelemetrySdkTests",
            plugins: .default
        ),
        .testTarget(
            name: "ResourceExtensionTests",
            dependencies: [
                "ResourceExtension",
                "OpenTelemetrySdk"
            ],
            path: "Tests/InstrumentationTests/SDKResourceExtensionTests",
            plugins: .default
        ),
        .testTarget(
            name: "URLSessionInstrumentationTests",
            dependencies: [
                "URLSessionInstrumentation",
                .product(name: "NIO", package: "swift-nio"),
                .product(name: "NIOHTTP1", package: "swift-nio")
            ],
            path: "Tests/InstrumentationTests/URLSessionTests",
            plugins: .default
        ),
        .testTarget(
            name: "OpenTracingShimTests",
            dependencies: [
                "OpenTracingShim",
                "OpenTelemetrySdk"
            ],
            path: "Tests/ImportersTests/OpenTracingShim",
            plugins: .default
        ),
        .testTarget(
            name: "SwiftMetricsShimTests",
            dependencies: [
                "SwiftMetricsShim",
                "OpenTelemetrySdk"
            ],
            path: "Tests/ImportersTests/SwiftMetricsShim",
            plugins: .default
        ),
        .testTarget(
            name: "JaegerExporterTests",
            dependencies: ["JaegerExporter"],
            path: "Tests/ExportersTests/Jaeger",
            plugins: .default
        ),
        .testTarget(
            name: "ZipkinExporterTests",
            dependencies: ["ZipkinExporter"],
            path: "Tests/ExportersTests/Zipkin",
            plugins: .default
        ),
        .testTarget(
            name: "PrometheusExporterTests",
            dependencies: ["PrometheusExporter"],
            path: "Tests/ExportersTests/Prometheus",
            plugins: .default
        ),
        .testTarget(
            name: "OpenTelemetryProtocolExporterTests",
            dependencies: [
                "OpenTelemetryProtocolExporterGrpc",
                "OpenTelemetryProtocolExporterHttp",
                .product(name: "NIO", package: "swift-nio"),
                .product(name: "NIOHTTP1", package: "swift-nio"),
                .product(name: "NIOTestUtils", package: "swift-nio")
            ],
            path: "Tests/ExportersTests/OpenTelemetryProtocol",
            plugins: .default
        ),
        .testTarget(
            name: "InMemoryExporterTests",
            dependencies: ["InMemoryExporter"],
            path: "Tests/ExportersTests/InMemory"
        ),
        .testTarget(
            name: "DatadogExporterTests",
            dependencies: [
                "DatadogExporter",
                .product(name: "NIO", package: "swift-nio"),
                .product(name: "NIOHTTP1", package: "swift-nio")
            ],
            path: "Tests/ExportersTests/DatadogExporter",
            plugins: .default
        ),
        .testTarget(
            name: "PersistenceExporterTests",
            dependencies: ["PersistenceExporter"],
            path: "Tests/ExportersTests/PersistenceExporter",
            plugins: .default
        ),
        .executableTarget(
            name: "LoggingTracer",
            dependencies: ["OpenTelemetryApi"],
            path: "Examples/Logging Tracer",
            plugins: .default
        ),
        .executableTarget(
            name: "SimpleExporter",
            dependencies: ["OpenTelemetrySdk", "JaegerExporter", "StdoutExporter", "ZipkinExporter", "ResourceExtension", "SignPostIntegration"],
            path: "Examples/Simple Exporter",
            exclude: ["README.md"],
            plugins: .default
        ),
        .executableTarget(
            name: "OTLPExporter",
            dependencies: ["OpenTelemetrySdk", "OpenTelemetryProtocolExporterGrpc", "StdoutExporter", "ZipkinExporter", "ResourceExtension", "SignPostIntegration"],
            path: "Examples/OTLP Exporter",
            exclude: ["README.md"],
            plugins: .default
        ),
        .executableTarget(
            name: "OTLPHTTPExporter",
            dependencies: ["OpenTelemetrySdk", "OpenTelemetryProtocolExporterHttp", "StdoutExporter", "ZipkinExporter", "ResourceExtension", "SignPostIntegration"],
            path: "Examples/OTLP HTTP Exporter",
            exclude: ["README.md"],
            plugins: .default
        ),
        .executableTarget(
            name: "PrometheusSample",
            dependencies: ["OpenTelemetrySdk", "PrometheusExporter"],
            path: "Examples/Prometheus Sample",
            exclude: ["README.md"],
            plugins: .default
        ),
        .executableTarget(
            name: "DatadogSample",
            dependencies: ["DatadogExporter"],
            path: "Examples/Datadog Sample",
            exclude: ["README.md"],
            plugins: .default
        ),
        .executableTarget(
            name: "NetworkSample",
            dependencies: ["URLSessionInstrumentation", "StdoutExporter"],
            path: "Examples/Network Sample",
            exclude: ["README.md"],
            plugins: .default
        )
    ]
)

extension [Target.PluginUsage] {
    static var `default`: [Element] {
        Environment.isDevelopment ? [
            .plugin(name: "SwiftFormatPrebuildPlugin", package: "SwiftFormatPlugin"),
            .plugin(name: "SwiftLintPrebuildFix", package: "SwiftLintPlugin"),
            .plugin(name: "SwiftLint", package: "SwiftLintPlugin")
        ] : []
    }
}

extension [Package.Dependency] {
    static var plugins: [Element] {
        Environment.isDevelopment ? [
            .package(url: "git@github.com:lunij/SwiftFormatPlugin", from: "0.50.7"),
            .package(url: "git@github.com:lunij/SwiftLintPlugin", from: "0.50.3")
        ] : []
    }
}

enum Environment {
    static var isDevelopment: Bool {
        ProcessInfo.processInfo.environment["OTDEV"] == "true"
    }
}
