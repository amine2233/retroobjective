//
//  RetroObjective_iOSTests.swift
//  RetroObjective iOSTests
//
//  Created by Amine Bensalah on 21/01/2020.
//

import XCTest
import Combine
import RetroObjective
@testable import RetroObjectiveCombine

class RetroObjectiveCombineTests: XCTestCase {

    var disposeBag = Set<AnyCancellable>()

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testDelegatePublisher() {
        var expectationValue: String?
        let expectation = self.expectation(description: #function)
        let delegateTester = DelegateTester()
        delegateTester.combine
            .value
            .sink { (value) in
                expectationValue = value
                expectation.fulfill()
            }
            .store(in: &disposeBag)

        let stringTest = "send new element"
        delegateTester.testDelegate(stringTest)

        waitForExpectations(timeout: 1.0) { error in
            if let error = error {
                XCTFail(error.localizedDescription)
            }
            XCTAssertEqual(expectationValue, stringTest)
        }
    }
}
