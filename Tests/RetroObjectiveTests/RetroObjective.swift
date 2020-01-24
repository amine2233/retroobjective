//
//  RetroObjective.swift
//  RetroObjective
//
//  Created by Amine Bensalah on 24/01/2020.
//

import RetroObjective

@objc protocol TestDelegate {
    @objc optional func intEvent(_ value: Int)
}

@objc protocol TestInheritedDelegate: TestDelegate {
    func boolEvent(_ value: Bool)
}

final class DelegateTester: NSObject {
    weak var delegate: TestDelegate?

    func sendIntEvent(_ value: Int) {
        delegate?.intEvent!(value)
    }
}

final class InheritedDelegateTester: NSObject {
    weak var delegate: TestInheritedDelegate?

    func sendIntEvent(_ value: Int) {
        delegate?.intEvent!(value)
    }

    func sendBoolEvent(_ value: Bool) {
        delegate?.boolEvent(value)
    }
}

final class TestDelegateProxy: RetroObjectiveProxy, TestDelegate, RetroObjectiveProxyType {

    func resetRetroObjectiveProxyType(owner: DelegateTester) {
        owner.delegate = self
    }
}

final class DelegateImplementedProxy: DelegateProxy, TestDelegate {
    private(set) var receivedValues = [Int]()

    func intEvent(_ value: Int) {
        receivedValues.append(value)
    }
}

extension DelegateTester {
    var delegateProxy: TestDelegateProxy {
        return TestDelegateProxy.proxy(for: self)
    }
}
