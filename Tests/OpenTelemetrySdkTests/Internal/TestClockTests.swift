/*
 * Copyright The OpenTelemetry Authors
 * SPDX-License-Identifier: Apache-2.0
 */

import OpenTelemetrySdk
import XCTest

class TestClockTests: XCTestCase {
    func testSetAndGetTime() {
        let clock = TestClock(nanos: 1_234)
        XCTAssertEqual(clock.now, TestUtils.dateFromNanos(1_234))
        clock.setTime(nanos: 9_876_543_210)
        XCTAssertEqual(clock.now, TestUtils.dateFromNanos(9_876_543_210))
    }

    func testAdvanceMillis() {
        let clock = TestClock(nanos: 1_500_000_000)
        clock.advanceMillis(2_600)
        XCTAssertEqual(clock.now, TestUtils.dateFromNanos(4_100_000_000))
    }

    func testMeasureElapsedTime() {
        let clock = TestClock(nanos: 10_000_000_000)
        let nanos1 = clock.nanoTime
        clock.setTime(nanos: 11_000_000_000)
        let nanos2 = clock.nanoTime
        XCTAssertEqual(nanos2 - nanos1, 1_000_000_000)
    }
}
