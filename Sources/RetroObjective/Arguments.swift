//
//  Arguments.swift
//  RetroObjective
//
//  Created by Amine Bensalah on 22/01/2020.
//

import Foundation

public final class Arguments {
    public let list: [Any]

    init(_ args: [Any]) {
        self.list = args
    }
}

public extension Arguments {
    func value(at index: Int) -> Any? {
        guard index > 0 && index < list.count else { return nil }
        return list[index]
    }

    func value<T>(at index: Int, as type: T.Type = T.self) -> T? {
        return value(at: index) as? T
    }
}
