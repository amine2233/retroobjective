//
//  AssociatedRetroObjectiveTests.swift
//  RetroObjective
//
//  Created by Amine Bensalah on 24/01/2020.
//

import XCTest
@testable import RetroObjective

final class AssociatedRetroObjectiveTests: XCTestCase {
    func testAssociatedProxy() {
        let tester = DelegateTester()
        let proxy1 = tester.delegateProxy
        let proxy2 = tester.delegateProxy

        XCTAssertEqual(proxy1, proxy2)
    }

    func testDelegateProxyExtension() {
        let tester = DelegateTester()

        var value = 0
        tester.delegateProxy.receive(selector: #selector(TestDelegate.intEvent(_:))) {
            guard let arg: Int = $0.value(at: 0) else {
                XCTAssert(false, "Invalid argument type")
                return
            }
            value += arg
        }

        tester.sendIntEvent(10)
        XCTAssertEqual(value, 10)

        tester.sendIntEvent(15)
        XCTAssertEqual(value, 15)
    }
}
