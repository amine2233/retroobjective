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
