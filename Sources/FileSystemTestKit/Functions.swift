/*
 * Copyright The OpenTelemetry Authors
 * SPDX-License-Identifier: Apache-2.0
 */

import FileSystem
import Foundation

public func obtainUniqueTemporaryDirectory() -> Directory {
    .temporaryDirectory.appending(path: "com.otel.tests.\(UUID().uuidString)")
}
