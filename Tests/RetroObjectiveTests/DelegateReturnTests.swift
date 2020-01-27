//
//  DelegateReturnTests.swift
//  RetroObjective
//
//  Created by Amine Bensalah on 27/01/2020.
//

import XCTest

class DelegateReturnTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testReturnDelegate() {
        let proxy = TestReturnDelegateProxy()
        let tester = TestReturn()
        tester.delegate = proxy

        proxy.receive(selector: #selector(TestReturnDelegate.intValue(_:))) { args -> Bool in
            guard let arg: Int = args.value(at: 0) else {
                XCTAssert(false, "Invalid argument type")
                return false
            }
            if arg == 1 {
                return true
            } else {
                return false
            }
        }

        let caseOne = tester.intValue(1)
        XCTAssertTrue(caseOne)

        let caseTwo = tester.intValue(5)
        XCTAssertFalse(caseTwo)
    }

}
