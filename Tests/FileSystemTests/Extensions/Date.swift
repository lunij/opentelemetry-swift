//
// Copyright The OpenTelemetry Authors
// SPDX-License-Identifier: Apache-2.0
// 

import FileSystem
import Foundation

extension Date {
    /// Returns name of the logs file createde at this date.
    var toFileName: String {
        fileNameFrom(fileCreationDate: self)
    }

    func secondsAgo(_ seconds: TimeInterval) -> Date {
        addingTimeInterval(-seconds)
    }
}
