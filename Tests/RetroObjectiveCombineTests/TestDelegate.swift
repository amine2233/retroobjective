//
//  File.swift
//  RetroObjectiveCombineTests
//
//  Created by Amine Bensalah on 20/06/2020.
//

import Foundation
import RetroObjectiveObjC
import RetroObjective
import Combine
import RetroObjectiveCombine

@objc protocol TestDelegate: NSObjectProtocol {
    @objc optional func mockData(_ give: String)
}

class DelegateTester: NSObject {
    weak var delegate: TestDelegate?

    func testDelegate(_ give: String) {
        self.delegate?.mockData?(give)
    }
}

final class TestDelegateProxy: RetroObjectiveProxy, TestDelegate, RetroObjectiveProxyType {
    public func resetRetroObjectiveProxyType(owner: DelegateTester) {
        owner.delegate = self
    }
}

final class DelegateImplementedProxy: RetroObjectiveProxy, TestDelegate {
    private(set) var receivedValues = [Int]()

    func intEvent(_ value: Int) {
        receivedValues.append(value)
    }
}

public struct CombineExtension<Base> {
    public let base: Base

    init(_ base: Base) {
        self.base = base
    }
}

public protocol CombineCompatible {}

extension CombineCompatible {
    public static var combine: CombineExtension<Self>.Type {
        return CombineExtension<Self>.self
    }

    public var combine: CombineExtension<Self> {
        return CombineExtension<Self>(self)
    }
}

extension NSObject: CombineCompatible {}

extension CombineExtension where Base: DelegateTester {
    var delegateProxy: TestDelegateProxy {
        .proxy(for: base)
    }

    var value: AnyPublisher<String, Never> {
        Publishers.proxyDelegate(delegateProxy, selector: #selector(TestDelegate.mockData(_:)))
            .compactMap { $0.value(at: 0) as? String }
            .eraseToAnyPublisher()
    }
}
