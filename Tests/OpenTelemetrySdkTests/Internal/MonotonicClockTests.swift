/*
 * Copyright The OpenTelemetry Authors
 * SPDX-License-Identifier: Apache-2.0
 */

import OpenTelemetrySdk
import XCTest

class MonotonicClockTests: XCTestCase {
    let epochNanos: UInt64 = 1_234_000_005_678
    var testClock: TestClock!

    override func setUp() {
        testClock = TestClock(nanos: epochNanos)
    }

    func testNanoTime() {
        XCTAssertEqual(testClock.now, TestUtils.dateFromNanos(epochNanos))
        let monotonicClock = MonotonicClock(clock: testClock)
        XCTAssertEqual(monotonicClock.nanoTime, testClock.nanoTime)
        testClock.advanceNanos(12_345)
        XCTAssertEqual(monotonicClock.nanoTime, testClock.nanoTime)
    }

    func testNow_PositiveIncrease() {
        let monotonicClock = MonotonicClock(clock: testClock)
        XCTAssertEqual(monotonicClock.now, testClock.now)
        testClock.advanceNanos(3_210)
        XCTAssertEqual(monotonicClock.now, TestUtils.dateFromNanos(1_234_000_008_888))
        // Initial + 1000
        testClock.advanceNanos(-2_210)
        XCTAssertEqual(monotonicClock.now, TestUtils.dateFromNanos(1_234_000_006_678))
        testClock.advanceNanos(15_999_993_322)
        XCTAssertEqual(monotonicClock.now, TestUtils.dateFromNanos(1_250_000_000_000))
    }

    func testNow_NegativeIncrease() {
        let monotonicClock = MonotonicClock(clock: testClock)
        XCTAssertEqual(monotonicClock.now, testClock.now)
        testClock.advanceNanos(-3_456)
        XCTAssertEqual(monotonicClock.now, TestUtils.dateFromNanos(1_234_000_002_222))
        // Initial - 1000
        testClock.advanceNanos(2_456)
        XCTAssertEqual(monotonicClock.now, TestUtils.dateFromNanos(1_234_000_004_678))
        testClock.advanceNanos(-14_000_004_678)
        XCTAssertEqual(monotonicClock.now, TestUtils.dateFromNanos(1_220_000_000_000))
    }
}
