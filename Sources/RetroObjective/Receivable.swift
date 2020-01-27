//
//  Receivable.swift
//  RetroObjective
//
//  Created by Amine Bensalah on 22/01/2020.
//

import Foundation

public protocol Receivable {
    func send(arguments: Arguments)
}

public extension Receivable {
    @discardableResult
    func subscribe(to proxy: RetroObjectiveProxy, selector: Selector) -> Self {
        proxy.receive(selector: selector, receiver: self)
        return self
    }
}

public protocol ReceivableValue {
    func send<Value>(arguments: Arguments) -> Value
}

public extension ReceivableValue {
    @discardableResult
    func subscribe(to proxy: RetroObjectiveProxy, selector: Selector) -> Self {
        proxy.receive(selector: selector, receiver: self)
        return self
    }
}
