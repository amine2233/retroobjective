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

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() {
        var expectationValue: String?
        let expectation = self.expectation(description: #function)
        let mockClass = ConcretDelegateMock { value in
            expectationValue = value
            expectation.fulfill()
        }

    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
}

@objc protocol DelegateMock: NSObjectProtocol {
    @objc optional func mockData(give: String)
}

class MyDelegateMock: NSObject {
    weak var delegate: DelegateMock?

    init(delegate: DelegateMock?) {
        self.delegate = delegate
    }

    func testDelegate(give: String) {
        self.delegate?.mockData?(give: give)
    }
}

class ConcretDelegateMock: NSObject, DelegateMock {
    var myDelegateMock: MyDelegateMock?
    var callback: ((String) -> Void)?
    init(callback: ((String) -> Void)?) {
        super.init()
        self.callback = callback
        self.myDelegateMock = MyDelegateMock(delegate: self)
    }

    func mockData(give: String) {
        self.callback?(give)
    }
}

final class DelegateMockProxy: RetroObjectiveProxy, DelegateMock, RetroObjectiveProxyType {

    public func resetRetroObjectiveProxyType(owner: MyDelegateMock) {
        owner.delegate = self
    }
}
