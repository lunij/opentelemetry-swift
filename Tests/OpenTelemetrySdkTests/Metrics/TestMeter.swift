/*
 * Copyright The OpenTelemetry Authors
 * SPDX-License-Identifier: Apache-2.0
 */

import XCTest
@testable import OpenTelemetrySdk

class TestMeter: MeterSdk {
    let collectAction: () -> Void

    init(meterSharedState: MeterSharedState, instrumentationScopeInfo: InstrumentationScopeInfo, collectAction: @escaping () -> Void) {
        self.collectAction = collectAction
        super.init(meterSharedState: meterSharedState, instrumentationScopeInfo: instrumentationScopeInfo)
    }

    override func collect() {
        collectAction()
    }
}
