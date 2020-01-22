//
//  Receiver.swift
//  RetroObjective
//
//  Created by Amine Bensalah on 22/01/2020.
//

import Foundation

public final class Receiver: Receivable {
    private let handler: (Arguments) -> Void

    public init(_ handler: @escaping (Arguments) -> Void) {
        self.handler = handler
    }

    public func send(arguments: Arguments) {
        handler(arguments)
    }
}
