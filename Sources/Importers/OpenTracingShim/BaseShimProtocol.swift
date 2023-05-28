/*
 * Copyright The OpenTelemetry Authors
 * SPDX-License-Identifier: Apache-2.0
 */

import Foundation
import OpenTelemetryApi

protocol BaseShimProtocol {
    var telemetryInfo: TelemetryInfo { get }
}

extension BaseShimProtocol {
    var tracer: Tracer {
        telemetryInfo.tracer
    }

    var spanContextTable: SpanContextShimTable {
        telemetryInfo.spanContextTable
    }

    var baggageManager: BaggageManager {
        telemetryInfo.baggageManager
    }

    var propagators: ContextPropagators {
        telemetryInfo.propagators
    }
}
