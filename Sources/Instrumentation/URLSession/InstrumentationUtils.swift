/*
 * Copyright The OpenTelemetry Authors
 * SPDX-License-Identifier: Apache-2.0
 */

import Foundation
#if os(iOS) || os(tvOS)
import UIKit
#elseif os(watchOS)
import WatchKit
#endif

enum InstrumentationUtils {
    static func objc_getClassList() -> [AnyClass] {
        let expectedClassCount = ObjectiveC.objc_getClassList(nil, 0)
        let allClasses = UnsafeMutablePointer<AnyClass>.allocate(capacity: Int(expectedClassCount))
        let autoreleasingAllClasses = AutoreleasingUnsafeMutablePointer<AnyClass>(allClasses)
        let actualClassCount: Int32 = ObjectiveC.objc_getClassList(autoreleasingAllClasses, expectedClassCount)

        var classes = [AnyClass]()
        for index in 0 ..< actualClassCount {
            classes.append(allClasses[Int(index)])
        }
        allClasses.deallocate()
        return classes
    }

    static func instanceRespondsAndImplements(cls: AnyClass, selector: Selector) -> Bool {
        var implements = false
        if cls.instancesRespond(to: selector) {
            var methodCount: UInt32 = 0
            guard let methodList = class_copyMethodList(cls, &methodCount) else {
                return implements
            }
            defer { free(methodList) }
            if methodCount > 0 {
                enumerateCArray(array: methodList, count: methodCount) { _, method in
                    let sel = method_getName(method)
                    if sel == selector {
                        implements = true
                        return
                    }
                }
            }
        }
        return implements
    }

    private static func enumerateCArray<T>(array: UnsafePointer<T>, count: UInt32, function: (UInt32, T) -> Void) {
        var ptr = array
        for index in 0 ..< count {
            function(index, ptr.pointee)
            ptr = ptr.successor()
        }
    }

    static var usesUndocumentedAsyncAwaitMethods: Bool = {
        #if os(macOS)
        let version = ProcessInfo.processInfo.operatingSystemVersion
        if version.majorVersion >= 13 {
            return true
        }
        #elseif os(watchOS)
        let version = WKInterfaceDevice.current().systemVersion
        if let versionNumber = Double(version),
           versionNumber >= 9.0
        {
            return true
        }
        #else
        let version = UIDevice.current.systemVersion
        if let versionNumber = Double(version),
           versionNumber >= 16.0
        {
            return true
        }
        #endif
        return false
    }()
}
